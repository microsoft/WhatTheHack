using System.Web.Http;
using Autofac;
using Microsoft.Bot.Builder.Dialogs;
using System.IO;
using System.Diagnostics;
using System;

namespace MiddlewareBot
{

    public class WebApiApplication : System.Web.HttpApplication
    {
        static TextWriter tw = null;
        protected void Application_Start()
        {
            tw = new StreamWriter("C:\\Users\\miprasad\\Downloads\\log.txt", true);
            Conversation.UpdateContainer(builder =>
            {
                builder.RegisterType<DebugActivityLogger>().AsImplementedInterfaces().InstancePerDependency().WithParameter("inputFile", tw);
            });
            GlobalConfiguration.Configure(WebApiConfig.Register);
        }

        protected void Application_End()
        {
            tw.Close();
        }
    }
}
