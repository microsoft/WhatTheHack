using Azure.Search.Documents.Indexes;
using VectorSearchAiAssistant.SemanticKernel.Models;
using VectorSearchAiAssistant.SemanticKernel.TextEmbedding;

namespace VectorSearchAiAssistant.Service.Models.Search
{

    public class Product : EmbeddedEntity
    {
        [SimpleField]
        public string categoryId { get; set; }
        [SearchableField(IsFilterable = true, IsFacetable = true)]
        [EmbeddingField(Label = "Product category name")]
        public string categoryName { get; set; }
        [SimpleField]
        [EmbeddingField(Label = "Product stock keeping unit (SKU)")]
        public string sku { get; set; }
        [SimpleField]
        [EmbeddingField(Label = "Product name")]
        public string name { get; set; }
        [SimpleField]
        [EmbeddingField(Label = "Product description")]
        public string description { get; set; }
        [SimpleField]
        [EmbeddingField(Label = "Product price")]
        public double price { get; set; }
        [SimpleField]
        [EmbeddingField(Label = "Product tags")]
        public List<Tag> tags { get; set; }

        public Product(string id, string categoryId, string categoryName, string sku, string name, string description, double price, List<Tag> tags)
        {
            this.id = id;
            this.categoryId = categoryId;
            this.categoryName = categoryName;
            this.sku = sku;
            this.name = name;
            this.description = description;
            this.price = price;
            this.tags = tags;
        }

        public Product()
        {
        }
    }

    public class ProductCategory
    {
        [SimpleField]
        public string id { get; set; }
        [SimpleField]
        public string type { get; set; }
        [SimpleField]
        public string name { get; set; }

        public ProductCategory(string id, string type, string name)
        {
            this.id = id;
            this.type = type;
            this.name = name;
        }
    }

    public class Tag
    {
        [SimpleField]
        public string id { get; set; }
        [SimpleField]
        [EmbeddingField(Label = "Product tag name")]
        public string name { get; set; }

        public Tag(string id, string name)
        {
            this.id = id;
            this.name = name;
        }
    }
}
