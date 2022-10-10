using Newtonsoft.Json;

namespace WTHAzureCosmosDB.Models;

public class Product : Entity
{
    [JsonProperty(PropertyName = "itemId")]
    public string ItemId { get; set; }
    
    [JsonProperty(PropertyName = "storeId")]
    public int StoreId { get; set; }
    
    [JsonProperty(PropertyName = "name")]
    public string Name { get; set; }

    [JsonProperty(PropertyName = "price")]
    public decimal Price { get; set; }

    [JsonProperty(PropertyName = "imageURI")]
    public string ImageURI { get; set; }

    [JsonProperty(PropertyName = "description")]
    public string Description { get; set; }

    [JsonProperty(PropertyName = "type")]
    public string Type  = "Product";    
}
