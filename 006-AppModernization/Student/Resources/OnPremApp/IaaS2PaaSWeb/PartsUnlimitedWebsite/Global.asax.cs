using System;
using System.Data.Entity;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using Microsoft.Practices.Unity;
using PartsUnlimited.Utils;
using Unity.Mvc4;

namespace PartsUnlimited
{
    public class Global : HttpApplication
    {
        internal static IUnityContainer UnityContainer;

        protected void Application_Start(object sender, EventArgs e)
        {
            AreaRegistration.RegisterAllAreas();

            Database.SetInitializer(new PartsUnlimitedDbInitializer());

            UnityContainer = UnityConfig.BuildContainer();
            DependencyResolver.SetResolver(new UnityDependencyResolver(UnityContainer));
            GlobalConfiguration.Configure(WebApiConfig.Register);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }
    }
}