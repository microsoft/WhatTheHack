using Newtonsoft.Json.Linq;
using BuildYourOwnCopilot.Common.Exceptions;
using BuildYourOwnCopilot.Common.Extensions;
using BuildYourOwnCopilot.Common.Interfaces;
using BuildYourOwnCopilot.Common.Models;
using BuildYourOwnCopilot.Common.Models.BusinessDomain;
using BuildYourOwnCopilot.Common.Text;

namespace BuildYourOwnCopilot.Common.Services
{
    public class ModelRegistryItemTransformer : IItemTransformer
    {
        private readonly JObject? _jObjectItem;
        private readonly ModelRegistryEntry _typeMetadata;
        private readonly object _typedItem;
        private readonly string _itemName;
        private readonly JObject? _objectToEmbed;
        private readonly string? _textToEmbed;
        private readonly string? _embeddingId;
        private readonly string? _embeddingPartitionKey;
        private readonly ReadOnlyMemory<float> _embedding;

        private readonly bool _isEmbeddedEntity;

        public ModelRegistryItemTransformer(object item)
        {
            if (item is JObject jObject)
            {
                _typeMetadata = ModelRegistry.IdentifyType(jObject)
                    ?? throw new ItemTransformerException($"The Model Registry could not identify the type {item.GetType()}.");

                _jObjectItem = jObject;
                _typedItem = _jObjectItem.ToObject(_typeMetadata.Type!)!;
            }
            else
            {
                _typeMetadata = ModelRegistry.IdentifyType(item)
                    ?? throw new ItemTransformerException($"The Model Registry could not identify the type {item.GetType()}.");
                _typedItem = item;
            }

            _itemName = string.Join(" ", _typedItem.GetPropertyValues(_typeMetadata.NamingProperties!));

            if (_typedItem is EmbeddedEntity entity)
            {
                _isEmbeddedEntity = true;
                entity.entityType__ = _typeMetadata.Type!.Name;

                var transformedItem = EmbeddingUtility.Transform(_typedItem);
                _objectToEmbed = transformedItem.ObjectToEmbed;
                _textToEmbed = transformedItem.TextToEmbed;

                _embeddingId = string.Join(" ", _typedItem.GetPropertyValues(_typeMetadata.IdentifyingProperties!));
                if (string.IsNullOrWhiteSpace(_embeddingId))
                    _embeddingId = Guid.NewGuid().ToString().ToLower();

                _embeddingPartitionKey = string.Join(" ", _typedItem.GetPropertyValues(_typeMetadata.PartitioningProperties!));
                if (string.IsNullOrWhiteSpace(_embeddingPartitionKey))
                    _embeddingPartitionKey = _embeddingId;
            }
        }

        public string EmbeddingId =>
            _isEmbeddedEntity
                ? _embeddingId!
                : throw new ItemTransformerException("Only EmbeddedEntity objects can have an embedding identifier.");

        public string EmbeddingPartitionKey =>
            _isEmbeddedEntity
                ? _embeddingPartitionKey!
                : throw new ItemTransformerException("Only EmbeddedEntity objects can have an embedding partition key.");

        public string Name =>
            _itemName;

        public object TypedValue =>
            _typedItem;

        public JObject ObjectToEmbed =>
            _isEmbeddedEntity
                ? _objectToEmbed!
                : throw new ItemTransformerException("Only EmbeddedEntity objects can be embedded.");

        public string TextToEmbed =>
            _isEmbeddedEntity
                ? _textToEmbed!
                : throw new ItemTransformerException("Only EmbeddedEntity objects can be embedded.");

        public string? VectorIndexName =>
            _typeMetadata.VectorIndexCollectionName;
    }
}
