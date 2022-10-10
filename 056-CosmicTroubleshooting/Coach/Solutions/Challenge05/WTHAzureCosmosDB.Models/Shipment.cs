using Newtonsoft.Json;

namespace WTHAzureCosmosDB.Models;

public class Shipment : Entity
{
    [JsonProperty(PropertyName = "customerId")]
    public string CustomerId { get; set; }

    [JsonProperty(PropertyName = "storeId")]
    public int StoreId { get; set; }

    [JsonProperty(PropertyName = "orderId")]
    public string OrderId { get; set; }

    [JsonProperty(PropertyName = "shippedOn")]
    public DateTime ShippedOn { get; set; }

    [JsonProperty(PropertyName = "type")]
    public string Type => $"Shipment-{CustomerId}";
}
