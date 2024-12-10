using Newtonsoft.Json.Linq;
using BuildYourOwnCopilot.Common.Models.BusinessDomain;
using BuildYourOwnCopilot.Common.Models.Chat;

namespace BuildYourOwnCopilot.Common.Models
{
    public class ModelRegistry
    {
        public static Dictionary<string, ModelRegistryEntry> Models = new Dictionary<string, ModelRegistryEntry>
            {
                { 
                    nameof(Customer), 
                    new ModelRegistryEntry 
                    { 
                        Type = typeof(Customer),
                        TypeMatchingProperties = ["customerId", "firstName"],
                        NamingProperties = ["firstName", "lastName"],
                        IdentifyingProperties = ["customerId"],
                        PartitioningProperties = ["customerId"],
                        VectorIndexCollectionName = "customer-vector-store"
                    } 
                },
                { 
                    nameof(Product),
                    new ModelRegistryEntry 
                    { 
                        Type = typeof(Product),
                        TypeMatchingProperties = ["sku"],
                        NamingProperties = ["name"],
                        IdentifyingProperties = ["id"],
                        PartitioningProperties = ["categoryId"],
                        VectorIndexCollectionName = "product-vector-store"
                    } 
                },
                { 
                    nameof(SalesOrder),  
                    new ModelRegistryEntry 
                    { 
                        Type = typeof(SalesOrder),
                        TypeMatchingProperties = ["orderDate", "shipDate"],
                        NamingProperties = ["id"],
                        IdentifyingProperties = ["id"],
                        PartitioningProperties = ["customerId"],
                        VectorIndexCollectionName = "customer-vector-store"
                    } 
                },
                {
                    nameof(ShortTermMemory),
                    new ModelRegistryEntry
                    {
                        Type = typeof(ShortTermMemory),
                        TypeMatchingProperties = ["memory__"],
                        NamingProperties = ["id"],
                        IdentifyingProperties = ["id"],
                        PartitioningProperties = ["id"]
                    }
                }
            };

        public static ModelRegistryEntry? IdentifyType(JObject obj)
        {
            var objProps = obj.Properties().Select(p => p.Name);

            var result = ModelRegistry
                .Models
                .Select(m => m.Value)
                .SingleOrDefault(x => objProps.Intersect(x.TypeMatchingProperties!).Count() == x.TypeMatchingProperties!.Count());

            return result;
        }

        public static ModelRegistryEntry? IdentifyType(object obj)
        {
            if (Models.TryGetValue(obj.GetType().Name, out var result))
            {
                return result;
            }

            return null;
        }
    }

    public class ModelRegistryEntry
    {
        public Type? Type { get; init; }
        public List<string>? TypeMatchingProperties { get; init; }
        public List<string>? NamingProperties { get; init; }
        public List<string>? IdentifyingProperties { get; init; }
        public List<string>? PartitioningProperties { get; init; }
        public string? VectorIndexCollectionName { get; init; }
    }
}
