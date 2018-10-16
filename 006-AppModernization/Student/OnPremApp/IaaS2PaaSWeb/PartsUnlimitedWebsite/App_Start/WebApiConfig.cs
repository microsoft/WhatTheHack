using System.Web.Http;
using Microsoft.Practices.Unity;
using Unity.WebApi;

namespace PartsUnlimited
{
    public class WebApiConfig
    {
        public static void RegisterWebApi(HttpConfiguration config, IUnityContainer container)
        {
            config.DependencyResolver = new UnityDependencyResolver(container);

            // Web API routes
            config.MapHttpAttributeRoutes();

            config.Formatters.JsonFormatter.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore;

            config.Routes.MapHttpRoute(
                name: "API Default",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );
        }

        public static void Register(HttpConfiguration config)
        {
            config.DependencyResolver = new UnityDependencyResolver(UnityConfig.BuildContainer());

            // Web API routes
            config.MapHttpAttributeRoutes();

            config.Formatters.JsonFormatter.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore;
        }
    }
}