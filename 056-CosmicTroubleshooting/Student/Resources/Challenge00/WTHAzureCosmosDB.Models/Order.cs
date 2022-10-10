using Newtonsoft.Json;

namespace WTHAzureCosmosDB.Models;

public class CustomerOrder : Entity
{

    [JsonProperty(PropertyName = "customerId")]
    public string CustomerId { get; set; }

    [JsonProperty(PropertyName = "storeId")]
    public int StoreId { get; set; }

    [JsonProperty(PropertyName = "orderedItems")]
    public IEnumerable<CustomerCart> OrderedItems { get; set; }

    [JsonProperty(PropertyName = "type")]
    public string Type = "CustomerOrder";

    [JsonProperty(PropertyName = "status")]
    public string Status { get; set; }
}
