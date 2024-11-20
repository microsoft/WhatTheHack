namespace BuildYourOwnCopilot.Common.Models.BusinessDomain
{
    public class Product : EmbeddedEntity
    {
        public string categoryId { get; set; }

        [EmbeddingField(Label = "Product category name")]
        public string categoryName { get; set; }

        [EmbeddingField(Label = "Product stock keeping unit (SKU)")]
        public string sku { get; set; }

        [EmbeddingField(Label = "Product name")]
        public string name { get; set; }

        [EmbeddingField(Label = "Product description")]
        public string description { get; set; }

        [EmbeddingField(Label = "Product price")]
        public double price { get; set; }

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
        public string id { get; set; }

        public string type { get; set; }

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
        public string id { get; set; }

        [EmbeddingField(Label = "Product tag name")]
        public string name { get; set; }

        public Tag(string id, string name)
        {
            this.id = id;
            this.name = name;
        }
    }
}
