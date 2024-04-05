using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VectorSearchAiAssistant.Service.Models.Search;

namespace VectorSearchAiAssistant.Service.Models
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
                        TypeMatchingProperties = new List<string> { "customerId", "firstName" },
                        NamingProperties = new List<string> { "firstName", "lastName" },
                    } 
                },
                { 
                    nameof(Product),
                    new ModelRegistryEntry 
                    { 
                        Type = typeof(Product),
                        TypeMatchingProperties = new List<string> { "sku" },
                        NamingProperties = new List<string> { "name" }
                    } 
                },
                { 
                    nameof(SalesOrder),  
                    new ModelRegistryEntry 
                    { 
                        Type = typeof(SalesOrder),
                        TypeMatchingProperties = new List<string> { "orderDate", "shipDate" },
                        NamingProperties = new List<string> { "id" }
                    } 
                },
                {
                    nameof(ShortTermMemory),
                    new ModelRegistryEntry
                    {
                        Type = typeof(ShortTermMemory),
                        TypeMatchingProperties = new List<string> { "memory__" },
                        NamingProperties = new List<string>()
                    }
                }
            };

        public static ModelRegistryEntry? IdentifyType(JObject obj)
        {
            var objProps = obj.Properties().Select(p => p.Name);

            var result = ModelRegistry
                .Models
                .Select(m => m.Value)
                .SingleOrDefault(x => objProps.Intersect(x.TypeMatchingProperties).Count() == x.TypeMatchingProperties.Count());

            return result;
        }
    }

    public class ModelRegistryEntry
    {
        public Type? Type { get; init; }
        public List<string>? TypeMatchingProperties { get; init; }
        public List<string>? NamingProperties { get; init; }
    }
}
