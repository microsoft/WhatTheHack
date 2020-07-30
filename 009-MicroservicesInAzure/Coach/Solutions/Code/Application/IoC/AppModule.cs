using Autofac;
using ContosoTravel.Web.Application.Interfaces.MVC;
using ContosoTravel.Web.Application.Services;

namespace ContosoTravel.Web.Application.IoC
{
    public class AppModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {  
            builder.RegisterType<AzureManagement>()
                   .AsSelf()
                   .SingleInstance();

        }
    }
}
