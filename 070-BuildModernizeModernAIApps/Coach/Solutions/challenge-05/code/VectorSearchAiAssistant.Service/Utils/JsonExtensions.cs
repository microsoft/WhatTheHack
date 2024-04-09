using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VectorSearchAiAssistant.Service.Utils
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
