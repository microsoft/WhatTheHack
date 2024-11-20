using Newtonsoft.Json.Linq;
using System.Reflection;
using System.Text;
using BuildYourOwnCopilot.Common.Models.BusinessDomain;

namespace BuildYourOwnCopilot.Common.Text
{
    public static class EmbeddingUtility
    {
        public static (JObject ObjectToEmbed, string TextToEmbed) Transform(object item, int maxRecursionLevels = 3)
        {
            if (maxRecursionLevels < 0)
                throw new ArgumentException("Invalid recursion level.", nameof(maxRecursionLevels));

            var embeddingFields = new Dictionary<string, string>();
            FindEmbeddingFieldAttributes(item.GetType(), embeddingFields, string.Empty, maxRecursionLevels);

            var jObj = JObject.FromObject(item);
            var embeddingTextBuilder = new StringBuilder();
            PrepareOject(jObj, embeddingFields, string.Empty, maxRecursionLevels, embeddingTextBuilder);

            // If the object type has no EmbeddingFieldAttribute decorations at all, then use the full JSON representation for embedding
            return (
                jObj,
                embeddingTextBuilder.Length == 0 ? jObj.ToString() : embeddingTextBuilder.ToString());
        }
        /// <summary>
        /// This function takes json and returns streamlined text, more suitable to use in generating AI responses
        /// </summary>
        /// <param name="item"></param>
        /// <param name="types"></param>
        /// <param name="maxRecursionLevels"></param>
        /// <returns></returns>
        /// <exception cref="ArgumentException"></exception>
        public static (JObject ObjectToEmbed, string TextToEmbed) Transform(string item, Dictionary<string, Type> types, int maxRecursionLevels = 3)
        {
            if (maxRecursionLevels < 0)
                throw new ArgumentException("Invalid recursion level.", nameof(maxRecursionLevels));

            var jObj = JObject.Parse(item);

            // If the object's type given by entityType__ is not available, leave the object unchanged
            if (!types.ContainsKey((jObj["entityType__"] as JValue).Value.ToString()))
                return (jObj, jObj.ToString());

            var embeddingFields = new Dictionary<string, string>();
            FindEmbeddingFieldAttributes(types[(jObj["entityType__"] as JValue).Value.ToString()], embeddingFields, string.Empty, maxRecursionLevels);

            var embeddingTextBuilder = new StringBuilder();
            PrepareOject(jObj, embeddingFields, string.Empty, maxRecursionLevels, embeddingTextBuilder);

            // If the object type has no EmbeddingFieldAttribute decorations at all, then use the full JSON representation for embedding
            return (
                jObj,
                embeddingTextBuilder.Length == 0 ? jObj.ToString() : embeddingTextBuilder.ToString());
        }

        static void FindEmbeddingFieldAttributes(Type type, Dictionary<string, string> embeddingFields, string currentPath, int remainingRecursionLevels)
        {
            // TODO: Improve the handling of various types

            foreach (var property in type.GetProperties())
            {
                var embeddingFieldAttribute = property.GetCustomAttributes(true)
                    .SingleOrDefault(a => a.GetType() == typeof(EmbeddingFieldAttribute)) as EmbeddingFieldAttribute;

                if (embeddingFieldAttribute != null)
                {
                    var newCurrentPath = string.IsNullOrEmpty(currentPath) ? property.Name : $"{currentPath}.{property.Name}";
                    embeddingFields.Add(newCurrentPath, embeddingFieldAttribute.Label);

                    var propertyInfo = property.PropertyType.GetTypeInfo();
                    if (propertyInfo.ImplementedInterfaces.Select(ii => ii.Name).Contains("IEnumerable")
                        && propertyInfo.IsGenericType
                        && remainingRecursionLevels > 0)
                    {
                        FindEmbeddingFieldAttributes(propertyInfo.GenericTypeArguments[0], embeddingFields, newCurrentPath, remainingRecursionLevels - 1);
                    }
                }
            }
        }

        static void PrepareOject(JObject item, Dictionary<string, string> embeddingFields, string currentPath, int remainingRecursionLevels, StringBuilder embeddingTextBuilder)
        {
            var childrenToRemove = new List<JProperty>();

            foreach (JProperty childItem in item.Children())
            {
                var newCurrentPath = string.IsNullOrEmpty(currentPath) ? childItem.Name : $"{currentPath}.{childItem.Name}";
                if (embeddingFields.ContainsKey(newCurrentPath) && childItem.HasValues)
                {
                    if (childItem.Value is JArray array && remainingRecursionLevels > 0)
                    {
                        embeddingTextBuilder.AppendLine($"{embeddingFields[newCurrentPath]}:");
                        foreach (var value in array)
                            PrepareOject(value as JObject, embeddingFields, newCurrentPath, remainingRecursionLevels - 1, embeddingTextBuilder);
                    }
                    else
                        embeddingTextBuilder.AppendLine(embeddingFields[newCurrentPath] == null
                            ? childItem.Value.ToString()
                            : $"{embeddingFields[newCurrentPath]}: {childItem.Value}");
                }
                else
                    childrenToRemove.Add(childItem);
            }

            foreach (var childItemToRemove in childrenToRemove)
                childItemToRemove.Remove();
        }
    }
}
