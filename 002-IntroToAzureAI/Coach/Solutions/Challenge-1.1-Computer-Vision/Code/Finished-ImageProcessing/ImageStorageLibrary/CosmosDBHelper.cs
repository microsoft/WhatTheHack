using System;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using Microsoft.Azure.Documents;
using Microsoft.Azure.Documents.Client;

namespace ImageStorageLibrary
{
    /// <summary>
    /// Helper for accessing CosmosDB. Set the endpoint URI and Access Key (find these in the portal), your DB and Collection names, and then build your instance.
    /// </summary>
    public class CosmosDBHelper
    {
        public static string EndpointUri { get; set; }
        public static string AccessKey { get; set; }
        public static string DatabaseName { get; set; }
        public static string CollectionName { get; set; }

        public static async Task<CosmosDBHelper> BuildAsync()
        {
            if (string.IsNullOrWhiteSpace(EndpointUri))
                throw new ArgumentNullException("EndpointUri");
            if (string.IsNullOrWhiteSpace(AccessKey))
                throw new ArgumentNullException("AccessKey");
            if (string.IsNullOrWhiteSpace(DatabaseName))
                throw new ArgumentNullException("DatabaseName");
            if (string.IsNullOrWhiteSpace(CollectionName))
                throw new ArgumentNullException("CollectionName");

            var client = new DocumentClient(new Uri(EndpointUri), AccessKey);
            var db = (await client.CreateDatabaseIfNotExistsAsync(new Database() {Id = DatabaseName})).Resource;
            var coll = (await client.CreateDocumentCollectionIfNotExistsAsync(UriFactory.CreateDatabaseUri(db.Id),
                new DocumentCollection() {Id = CollectionName})).Resource;

            return new CosmosDBHelper() {Client = client, Database = db, Collection = coll};
        }

        private CosmosDBHelper()
        {
        }

        private DocumentClient Client { get; set; }
        private Database Database { get; set; }
        private DocumentCollection Collection { get; set; }

        /// <summary>
        /// Create a document with the given ID in the DB/Collection, unless it already exists. If it exists, return the existing version.
        /// </summary>
        /// <typeparam name="T">Type of the document.</typeparam>
        /// <param name="document">Document to create.</param>
        /// <param name="id">ID for the created document, used in Document URI so must be valid DocuemntDB ID.</param>
        /// <returns>Tuple with whether document was created or not, and either created or existing document.</returns>
        public async Task<Tuple<bool, T>> CreateDocumentIfNotExistsAsync<T>(T document, string id)
            where T : new()
        {
            try
            {
                return
                Tuple.Create(false, (await this.Client.ReadDocumentAsync<T>(DocumentUri(id))).Document);
            }
            catch (DocumentClientException)
            {
                await this.Client.CreateDocumentAsync(CollectionUri(), document);
                return Tuple.Create(true, document);
            }
        }

        /// <summary>
        /// Update/replace the existing document with the given ID.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="update">Document to update</param>
        /// <param name="id">ID for the updated document, used in Cosmos URI so must be valid Cosmos DB ID.</param>
        /// <returns>Updated document.</returns>
        public async Task<T> UpdateDocumentAsync<T>(T update, string id)
            where T : new()
        {
            await this.Client.ReplaceDocumentAsync(DocumentUri(id), update);
            return update;
        }

        /// <summary>
        /// Find all documents in the collection.
        /// </summary>
        /// <typeparam name="T">Type of documents to find.</typeparam>
        /// <returns>Queryable capable of returning all documents.</returns>
        public IQueryable<T> FindAllDocuments<T>()
            where T : new()
        {
            var queryOptions = new FeedOptions() {MaxItemCount = -1};
            return this.Client.CreateDocumentQuery<T>(
                CollectionUri(), queryOptions);
        }

        /// <summary>
        /// Find all documents matching the given query in the collection.
        /// </summary>
        /// <typeparam name="T">Type of documents to find.</typeparam>
        /// <param name="query">Query against the document store.</param>
        /// <returns>Queryable capable of returning all matching documents.</returns>
        public IQueryable<T> FindMatchingDocuments<T>(string query)
            where T : new()
        {
            var queryOptions = new FeedOptions() { MaxItemCount = -1 };
            return this.Client.CreateDocumentQuery<T>(
                CollectionUri(), query, queryOptions);
        }

        /// <summary>
        /// Simple "find by ID" query.
        /// </summary>
        /// <typeparam name="T">Type of document to find.</typeparam>
        /// <param name="id">ID of the document, will be used to look up by CosmosDB URI.</param>
        /// <returns>Found document, or null (assuming T is nullable).</returns>
        public async Task<T> FindDocumentByIdAsync<T>(string id)
            where T : new()
        {
            try
            {
                return (await this.Client.ReadDocumentAsync<T>(DocumentUri(id))).Document;
            }
            catch (DocumentClientException e)
            {
                if (e.StatusCode == HttpStatusCode.NotFound) return default(T);
                throw;
            }
        }

        private Uri CollectionUri()
        {
            return UriFactory.CreateDocumentCollectionUri(this.Database.Id, this.Collection.Id);
        }

        private Uri DocumentUri(string documentId)
        {
            return UriFactory.CreateDocumentUri(this.Database.Id, this.Collection.Id, documentId);
        }
    }
}
