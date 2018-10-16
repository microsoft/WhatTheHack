using System.Web.Optimization;

namespace PartsUnlimited
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                    "~/Scripts/jquery-{version}.js",
                    "~/Scripts/jquery-ui-{version}.js"));
            
            bundles.Add(new ScriptBundle("~/bundles/jquery.validate").Include(
                    "~/Scripts/jquery.validate.js",
                    "~/Scripts/jquery.validate.unobtrusive.js"));

            bundles.Add(new ScriptBundle("~/bundles/jquery.zoom").Include(
                    "~/Scripts/jquery.zoom.js"));

            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                    "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                    "~/Scripts/bootstrap.js"));


            //bundles.Add(new ScriptBundle("~/bundles/signalr").Include(
            //        "~/Scripts/jquery.signalR-{version}.js",
            //        "~/signalr/hubs"));

            bundles.Add(new ScriptBundle("~/bundles/site").Include(
                    //"~/Scripts/NewStoreArrivals.js",
                    "~/Scripts/UI-Initialization.js",
                    "~/Scripts/Recommendations.js"));

            bundles.Add(new ScriptBundle("~/bundles/respond").Include(
                    "~/Scripts/respond.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                    "~/Content/bootstrap.css",
                    "~/Content/jquery-ui.css",
                    "~/Content/Site.css",
                    "~/Content/Home.css",
                    "~/Content/Account.css",
                    "~/Content/ShoppingCart.css",
                    "~/Content/Store.css"));
        }
    }
}