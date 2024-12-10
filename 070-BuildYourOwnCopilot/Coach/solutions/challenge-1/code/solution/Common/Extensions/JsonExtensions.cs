using Newtonsoft.Json.Linq;

namespace BuildYourOwnCopilot.Common.Extensions
{
    public static class JsonExtensions
    {
        public static object ToObject(this JObject obj, Type type)
        {
            var classType = typeof(JObject);
            var methodInfo = classType.GetMethod("ToObject").MakeGenericMethod(type);
            return methodInfo.Invoke(obj, new object[] { });
        }
    }
}
