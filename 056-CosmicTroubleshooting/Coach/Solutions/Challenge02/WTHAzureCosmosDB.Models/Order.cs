using Newtonsoft.Json;

namespace WTHAzureCosmosDB.Models;

public class CustomerOrder : Entity
{

    [JsonProperty(PropertyName = "customerId")]
    public string CustomerId { get; set; }
    
    [JsonProperty(PropertyName = "storeId")]
    public int StoreId { get; set; }

    [JsonProperty(PropertyName = "orderedItems")]
    public List<CustomerOrderItem> OrderedItems { get; set; }

    [JsonProperty(PropertyName = "type")]
    public string Type  => $"CustomerOrder-{CustomerId}";

    [JsonProperty(PropertyName = "status")]
    public string Status { get; set; }
}

public class CustomerOrderItem {

    [JsonProperty(PropertyName = "customerId")]
    public string CustomerId { get; set; }

    [JsonProperty(PropertyName = "productId")]
    public string ProductId { get; set; }

    [JsonProperty(PropertyName = "storeId")]
    public int StoreId { get; set; }

    [JsonProperty(PropertyName = "productName")]
    public string ProductName { get; set; }

    [JsonProperty(PropertyName = "productPrice")]
    public decimal ProductPrice { get; set; }

    [JsonProperty(PropertyName = "quantity")]
    public int Quantity { get; set; }
}