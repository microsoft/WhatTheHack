using Newtonsoft.Json;

namespace WTHAzureCosmosDB.Models;

public class CustomerCart : Entity
{
    [JsonProperty(PropertyName = "customerId")]
    public string CustomerId { get; set; }

    [JsonProperty(PropertyName = "type")]
    public string Type => $"CustomerCart-{StoreId}";

    [JsonProperty(PropertyName = "storeId")]
    public int StoreId { get; set; }
    
    [JsonProperty(PropertyName = "items")]
    public List<CustomerCartItem> Items { get; set; }
}

public class CustomerCartItem {

    [JsonProperty(PropertyName = "productId")]
    public string ProductId { get; set; }

    [JsonProperty(PropertyName = "productName")]
    public string ProductName { get; set; }

    [JsonProperty(PropertyName = "productPrice")]
    public decimal ProductPrice { get; set; }

    [JsonProperty(PropertyName = "quantity")]
    public int Quantity { get; set; }
}