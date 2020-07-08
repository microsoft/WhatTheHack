namespace MiddlewareBot
{
    using System.Web.Http;
    using Autofac;
    using Microsoft.Bot.Builder.Dialogs;
    using System.Diagnostics;

    public class WebApiApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            Conversation.UpdateContainer(builder =>
            {
                builder.RegisterType<DebugActivityLogger>().AsImplementedInterfaces().InstancePerDependency();
            });

            GlobalConfiguration.Configure(WebApiConfig.Register);
        }
    }
}
