using Newtonsoft.Json;

namespace WTHAzureCosmosDB.Models;

public abstract class Entity
{
    [JsonProperty(PropertyName = "id")]
    public virtual string Id { get; set; }
}