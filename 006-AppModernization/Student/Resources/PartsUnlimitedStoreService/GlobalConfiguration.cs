using System.Net.Http;
using System.Web.Http;

namespace PartsUnlimitedStoreService
{
    internal static class GlobalConfiguration
    {
        internal static void SetConfiguration(HttpRequestMessage req)
        {
            HttpConfiguration config = req.GetConfiguration();

            ((Newtonsoft.Json.Serialization.DefaultContractResolver)config.Formatters.JsonFormatter.SerializerSettings.ContractResolver).IgnoreSerializableAttribute = true;

            config.Formatters.JsonFormatter.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore;
        }
    }

}
