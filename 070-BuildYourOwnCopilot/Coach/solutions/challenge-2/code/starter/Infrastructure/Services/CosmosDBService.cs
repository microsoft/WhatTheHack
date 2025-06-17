using BuildYourOwnCopilot.Common.Interfaces;
using BuildYourOwnCopilot.Common.Models.BusinessDomain;
using BuildYourOwnCopilot.Common.Models.Chat;
using BuildYourOwnCopilot.Common.Models.Configuration;
using BuildYourOwnCopilot.Infrastructure.Interfaces;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Cosmos.Fluent;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Newtonsoft.Json.Linq;
using System.Diagnostics;

namespace BuildYourOwnCopilot.Infrastructure.Services
{
    /// <summary>
    /// Service to access Azure Cosmos DB for NoSQL.
    /// </summary>
    public class CosmosDBService : ICosmosDBService
    {
        private readonly Container _completions;
        private readonly Container _customer;
        private readonly Container _product;
        private readonly Container _leases;
        private readonly Database _database;
        private readonly Dictionary<string, Container> _containers;

        private readonly IItemTransformerFactory _itemTransformerFactory;
        private readonly IRAGService _ragService;
        private readonly CosmosDBSettings _settings;
        private readonly ILogger _logger;

        private List<ChangeFeedProcessor> _changeFeedProcessors;
        private bool _changeFeedsInitialized = false;

        public bool IsInitialized => _changeFeedsInitialized;

        public CosmosDBService(
            IItemTransformerFactory itemTransformerFactory,
            IRAGService ragService,
            IOptions<CosmosDBSettings> settings, 
            ILogger<CosmosDBService> logger)
        {
            _itemTransformerFactory = itemTransformerFactory;
            _ragService = ragService;

            _settings = settings.Value;
            ArgumentException.ThrowIfNullOrEmpty(_settings.Endpoint);
            ArgumentException.ThrowIfNullOrEmpty(_settings.Key);
            ArgumentException.ThrowIfNullOrEmpty(_settings.Database);
            ArgumentException.ThrowIfNullOrEmpty(_settings.Containers);

            _logger = logger;

            _logger.LogInformation("Initializing Cosmos DB service.");

            if (!_settings.EnableTracing)
            {
                Type defaultTrace = Type.GetType("Microsoft.Azure.Cosmos.Core.Trace.DefaultTrace,Microsoft.Azure.Cosmos.Direct");
                TraceSource traceSource = (TraceSource)defaultTrace.GetProperty("TraceSource").GetValue(null);
                traceSource.Switch.Level = SourceLevels.All;
                traceSource.Listeners.Clear();
            }

            CosmosSerializationOptions options = new()
            {
                PropertyNamingPolicy = CosmosPropertyNamingPolicy.CamelCase
            };

            CosmosClient client = new CosmosClientBuilder(_settings.Endpoint, _settings.Key)
                .WithSerializerOptions(options)
                .WithConnectionModeGateway()
                .Build();

            Database? database = client?.GetDatabase(_settings.Database);

            _database = database ??
                        throw new ArgumentException("Unable to connect to existing Azure Cosmos DB database.");


            //Dictionary of container references for all containers listed in config
            _containers = new Dictionary<string, Container>();

            List<string> containers = _settings.Containers.Split(',').ToList();

            foreach (string containerName in containers)
            {
                Container? container = database?.GetContainer(containerName.Trim()) ??
                                       throw new ArgumentException("Unable to connect to existing Azure Cosmos DB container or database.");

                _containers.Add(containerName.Trim(), container);
            }

            _completions = _containers["completions"];
            _customer = _containers["customer"];
            _product = _containers["product"];

            _leases = database?.GetContainer(_settings.ChangeFeedLeaseContainer)
                ?? throw new ArgumentException($"Unable to connect to the {_settings.ChangeFeedLeaseContainer} container required to listen to the CosmosDB change feed.");

            Task.Run(() => StartChangeFeedProcessors());
            _logger.LogInformation("Cosmos DB service initialized.");
        }

        private async Task StartChangeFeedProcessors()
        {
            _logger.LogInformation("Initializing the change feed processors...");
            _changeFeedProcessors = new List<ChangeFeedProcessor>();

            try
            {
                foreach (string monitoredContainerName in _settings.MonitoredContainers.Split(',').Select(s => s.Trim()))
                {
                    var changeFeedProcessor = _containers[monitoredContainerName]
                        .GetChangeFeedProcessorBuilder<dynamic>($"{monitoredContainerName}ChangeFeed", GenericChangeFeedHandler)
                        .WithInstanceName($"{monitoredContainerName}ChangeInstance")
                        .WithErrorNotification(GenericChangeFeedErrorHandler)
                        .WithLeaseContainer(_leases)
                        .Build();
                    await changeFeedProcessor.StartAsync();
                    _changeFeedProcessors.Add(changeFeedProcessor);
                    _logger.LogInformation($"Initialized the change feed processor for the {monitoredContainerName} container.");
                }

                _changeFeedsInitialized = true;
                _logger.LogInformation("Cosmos DB change feed processors initialized.");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error initializing change feed processors.");
            }
        }

        // This is an example of a dynamic change feed handler that can handle a range of preconfigured entities.
        private async Task GenericChangeFeedHandler(
            ChangeFeedProcessorContext context,
            IReadOnlyCollection<dynamic> changes,
            CancellationToken cancellationToken)
        {
            if (changes.Count == 0)
                return;

            var batchRef = Guid.NewGuid().ToString();
            _logger.LogInformation($"Starting to generate embeddings for {changes.Count} entities (batch ref {batchRef}).");

            // Using dynamic type as this container has two different entities
            foreach (var item in changes)
            {
                try
                {
                    if (cancellationToken.IsCancellationRequested)
                        break;

                    if (item is JObject jObject)
                    {

                        IItemTransformer itemTransformer = _itemTransformerFactory.CreateItemTransformer(jObject);

                        // Add the entity to the Semantic Kernel memory used by the RAG service
                        await _ragService.AddMemory(itemTransformer);
                    }
                    else
                        throw new InvalidCastException($"The Cosmos DB change feed cannot providess objects of type {item.GetType()}.");
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, $"Error processing an item in the change feed handler: {item}");
                }
            }

            _logger.LogInformation($"Finished generating embeddings (batch ref {batchRef}).");
        }

        private async Task GenericChangeFeedErrorHandler(
            string LeaseToken,
            Exception exception)
        {
            if (exception is ChangeFeedProcessorUserException userException)
            {
                Console.WriteLine($"Lease {LeaseToken} processing failed with unhandled exception from user delegate {userException.InnerException}");
            }
            else
            {
                Console.WriteLine($"Lease {LeaseToken} failed with {exception}");
            }

            await Task.CompletedTask;
        }

        /// <summary>
        /// Gets a list of all current chat sessions.
        /// </summary>
        /// <returns>List of distinct chat session items.</returns>
        public async Task<List<Session>> GetSessionsAsync()
        {
            QueryDefinition query = new QueryDefinition("SELECT DISTINCT * FROM c WHERE c.type = @type")
                .WithParameter("@type", nameof(Session));

            FeedIterator<Session> response = _completions.GetItemQueryIterator<Session>(query);

            List<Session> output = [];
            while (response.HasMoreResults)
            {
                FeedResponse<Session> results = await response.ReadNextAsync();
                output.AddRange(results);
            }

            return output;
        }

        /// <summary>
        /// Performs a point read to retrieve a single chat session item.
        /// </summary>
        /// <returns>The chat session item.</returns>
        public async Task<Session> GetSessionAsync(string id)
        {
            return await _completions.ReadItemAsync<Session>(
                id: id,
                partitionKey: new PartitionKey(id));
        }

        /// <summary>
        /// Gets a list of all current chat messages for a specified session identifier.
        /// </summary>
        /// <param name="sessionId">Chat session identifier used to filter messsages.</param>
        /// <returns>List of chat message items for the specified session.</returns>
        public async Task<List<Message>> GetSessionMessagesAsync(string sessionId)
        {
            QueryDefinition query =
                new QueryDefinition("SELECT * FROM c WHERE c.sessionId = @sessionId AND c.type = @type")
                    .WithParameter("@sessionId", sessionId)
                    .WithParameter("@type", nameof(Message));

            FeedIterator<Message> results = _completions.GetItemQueryIterator<Message>(query);

            List<Message> output = new();
            while (results.HasMoreResults)
            {
                FeedResponse<Message> response = await results.ReadNextAsync();
                output.AddRange(response);
            }

            return output;
        }

        /// <summary>
        /// Creates a new chat session.
        /// </summary>
        /// <param name="session">Chat session item to create.</param>
        /// <returns>Newly created chat session item.</returns>
        public async Task<Session> InsertSessionAsync(Session session)
        {
            PartitionKey partitionKey = new(session.SessionId);
            return await _completions.CreateItemAsync(
                item: session,
                partitionKey: partitionKey
            );
        }

        /// <summary>
        /// Creates a new chat message.
        /// </summary>
        /// <param name="message">Chat message item to create.</param>
        /// <returns>Newly created chat message item.</returns>
        public async Task<Message> InsertMessageAsync(Message message)
        {
            PartitionKey partitionKey = new(message.SessionId);
            return await _completions.CreateItemAsync(
                item: message,
                partitionKey: partitionKey
            );
        }

        /// <summary>
        /// Updates an existing chat message.
        /// </summary>
        /// <param name="message">Chat message item to update.</param>
        /// <returns>Revised chat message item.</returns>
        public async Task<Message> UpdateMessageAsync(Message message)
        {
            PartitionKey partitionKey = new(message.SessionId);
            return await _completions.ReplaceItemAsync(
                item: message,
                id: message.Id,
                partitionKey: partitionKey
            );
        }

        /// <summary>
        /// Updates a message's rating through a patch operation.
        /// </summary>
        /// <param name="id">The message id.</param>
        /// <param name="sessionId">The message's partition key (session id).</param>
        /// <param name="rating">The rating to replace.</param>
        /// <returns>Revised chat message item.</returns>
        public async Task<Message> UpdateMessageRatingAsync(string id, string sessionId, bool? rating)
        {
            var response = await _completions.PatchItemAsync<Message>(
                id: id,
                partitionKey: new PartitionKey(sessionId),
                patchOperations:
                [
                    PatchOperation.Set("/rating", rating),
                ]
            );
            return response.Resource;
        }

        /// <summary>
        /// Updates an existing chat session.
        /// </summary>
        /// <param name="session">Chat session item to update.</param>
        /// <returns>Revised created chat session item.</returns>
        public async Task<Session> UpdateSessionAsync(Session session)
        {
            PartitionKey partitionKey = new(session.SessionId);
            return await _completions.ReplaceItemAsync(
                item: session,
                id: session.Id,
                partitionKey: partitionKey
            );
        }

        /// <summary>
        /// Updates a session's name through a patch operation.
        /// </summary>
        /// <param name="id">The session id.</param>
        /// <param name="name">The session's new name.</param>
        /// <returns>Revised chat session item.</returns>
        public async Task<Session> UpdateSessionNameAsync(string id, string name)
        {
            var response = await _completions.PatchItemAsync<Session>(
                id: id,
                partitionKey: new PartitionKey(id),
                patchOperations: new[]
                {
                    PatchOperation.Set("/name", name),
                }
            );
            return response.Resource;
        }

        /// <summary>
        /// Batch create or update chat messages and session.
        /// </summary>
        /// <param name="messages">Chat message and session items to create or replace.</param>
        public async Task UpsertSessionBatchAsync(params dynamic[] messages)
        {
            if (messages.Select(m => m.SessionId).Distinct().Count() > 1)
            {
                throw new ArgumentException("All items must have the same partition key.");
            }

            PartitionKey partitionKey = new(messages.First().SessionId);
            var batch = _completions.CreateTransactionalBatch(partitionKey);
            foreach (var message in messages)
            {
                batch.UpsertItem(
                    item: message
                );
            }

            await batch.ExecuteAsync();
        }

        /// <summary>
        /// Batch deletes an existing chat session and all related messages.
        /// </summary>
        /// <param name="sessionId">Chat session identifier used to flag messages and sessions for deletion.</param>
        public async Task DeleteSessionAndMessagesAsync(string sessionId)
        {
            PartitionKey partitionKey = new(sessionId);

            // TODO: await container.DeleteAllItemsByPartitionKeyStreamAsync(partitionKey);

            var query = new QueryDefinition("SELECT c.id FROM c WHERE c.sessionId = @sessionId")
                .WithParameter("@sessionId", sessionId);

            var response = _completions.GetItemQueryIterator<Message>(query);

            var batch = _completions.CreateTransactionalBatch(partitionKey);
            while (response.HasMoreResults)
            {
                var results = await response.ReadNextAsync();
                foreach (var item in results)
                {
                    batch.DeleteItem(
                        id: item.Id
                    );
                }
            }

            await batch.ExecuteAsync();
        }

        /// <summary>
        /// Inserts a product into the product container.
        /// </summary>
        /// <param name="product">Product item to create.</param>
        /// <returns>Newly created product item.</returns>
        public async Task<Product> InsertProductAsync(Product product)
        {
            try
            {
                return await _product.CreateItemAsync(product);
            }
            catch (CosmosException ex)
            {
                // Ignore conflict errors.
                if (ex.StatusCode == System.Net.HttpStatusCode.Conflict)
                {
                    _logger.LogInformation("Product already added.");
                }
                else
                {
                    _logger.LogError(ex.Message);
                    throw;
                }
                return product;
            }
        }

        /// <summary>
        /// Inserts a customer into the customer container.
        /// </summary>
        /// <param name="product">Customer item to create.</param>
        /// <returns>Newly created customer item.</returns>
        public async Task<Customer> InsertCustomerAsync(Customer customer)
        {
            try
            {
                return await _customer.CreateItemAsync(customer);
            }
            catch (CosmosException ex)
            {
                // Ignore conflict errors.
                if (ex.StatusCode == System.Net.HttpStatusCode.Conflict)
                {
                    _logger.LogInformation("Customer already added.");
                }
                else
                {
                    _logger.LogError(ex.Message);
                    throw;
                }
                return customer;
            }
        }

        /// <summary>
        /// Inserts a sales order into the customer container.
        /// </summary>
        /// <param name="product">Sales order item to create.</param>
        /// <returns>Newly created sales order item.</returns>
        public async Task<SalesOrder> InsertSalesOrderAsync(SalesOrder salesOrder)
        {
            try
            {
                return await _customer.CreateItemAsync(salesOrder);
            }
            catch (CosmosException ex)
            {
                // Ignore conflict errors.
                if (ex.StatusCode == System.Net.HttpStatusCode.Conflict)
                {
                    _logger.LogInformation("Sales order already added.");
                }
                else
                {
                    _logger.LogError(ex.Message);
                    throw;
                }
                return salesOrder;
            }
        }

        /// <summary>
        /// Deletes a product by its Id and category (its partition key).
        /// </summary>
        /// <param name="productId">The Id of the product to delete.</param>
        /// <param name="categoryId">The category Id of the product to delete.</param>
        /// <returns></returns>
        public async Task DeleteProductAsync(string productId, string categoryId)
        {
            try
            {
                // Delete from Cosmos product container
                await _product.DeleteItemAsync<Product>(id: productId, partitionKey: new PartitionKey(categoryId));
            }
            catch (CosmosException ex)
            {
                if (ex.StatusCode == System.Net.HttpStatusCode.NotFound)
                {
                    _logger.LogInformation("The product has already been removed.");
                }
                else
                    throw;
            }
        }

        public async Task<CompletionPrompt> GetCompletionPrompt(string sessionId, string completionPromptId)
        {
            return await _completions.ReadItemAsync<CompletionPrompt>(
                id: completionPromptId,
                partitionKey: new PartitionKey(sessionId));
        }
    }
}
