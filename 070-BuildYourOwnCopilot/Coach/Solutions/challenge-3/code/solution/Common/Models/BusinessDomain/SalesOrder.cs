namespace BuildYourOwnCopilot.Common.Models.BusinessDomain
{
    public class SalesOrder : EmbeddedEntity
    {
        [EmbeddingField(Label = "Customer sales order type")]
        public string type { get; set; }

        public string customerId { get; set; }

        public string orderDate { get; set; }

        public string shipDate { get; set; }

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
        [EmbeddingField(Label = "Customer sales order detail stock keeping unit (SKU)")]
        public string sku { get; set; }

        [EmbeddingField(Label = "Customer sales order detail product name")]
        public string name { get; set; }

        [EmbeddingField(Label = "Customer sales order detail product price")]
        public double price { get; set; }

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
