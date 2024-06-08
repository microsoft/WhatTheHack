using Azure.Search.Documents.Indexes;
using VectorSearchAiAssistant.SemanticKernel.Models;
using VectorSearchAiAssistant.SemanticKernel.TextEmbedding;

namespace VectorSearchAiAssistant.Service.Models.Search
{
    public class SalesOrder : EmbeddedEntity
    {
        [SimpleField]
        [EmbeddingField(Label = "Customer sales order type")]
        public string type { get; set; }
        [SimpleField]
        public string customerId { get; set; }
        [SimpleField]
        public string orderDate { get; set; }
        [SimpleField]
        public string shipDate { get; set; }
        [SimpleField]
        [EmbeddingField(Label = "Customer sales order details")]
        public List<SalesOrderDetails> details { get; set; }

        public SalesOrder(string id, string type, string customerId, string orderDate, string shipDate, List<SalesOrderDetails> details)
        {
            this.id = id;
            this.type = type;
            this.customerId = customerId;
            this.orderDate = orderDate;
            this.shipDate = shipDate;
            this.details = details;
        }
    }

    public class SalesOrderDetails
    {
        [SimpleField]
        [EmbeddingField(Label = "Customer sales order detail stock keeping unit (SKU)")]
        public string sku { get; set; }
        [SimpleField]
        [EmbeddingField(Label = "Customer sales order detail product name")]
        public string name { get; set; }
        [SimpleField]
        [EmbeddingField(Label = "Customer sales order detail product price")]
        public double price { get; set; }
        [SimpleField]
        [EmbeddingField(Label = "Customer sales order detail product quantity")]
        public double quantity { get; set; }

        public SalesOrderDetails(string sku, string name, double price, double quantity)
        {
            this.sku = sku;
            this.name = name;
            this.price = price;
            this.quantity = quantity;
        }
    }
}
