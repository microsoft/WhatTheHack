using Autofac;
using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Interfaces.MVC;
using ContosoTravel.Web.Application.Services;
using ContosoTravel.Web.Application.Services.EventGrid;
using ContosoTravel.Web.Application.Services.Monolith;
using ContosoTravel.Web.Application.Services.ServiceBus;

namespace ContosoTravel.Web.Application.IoC
{
    public class ServicesModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<FulfillmentService>()
                   .AsSelf()
                   .SingleInstance();

            switch (ContosoConfiguration.ServicesType)
            {
                case ServicesType.Monolith:
                    builder.RegisterType<PurchaseMonolithService>()
                           .As<IPurchaseService>()
                           .SingleInstance();
                            break;
                case ServicesType.EventGrid:
                    builder.RegisterType<PurchaseEventGridService>()
                           .As<IPurchaseService>()
                           .SingleInstance();
                    break;
                case ServicesType.ServiceBus:
                    builder.RegisterType<PurchaseServiceBusService>()
                           .As<IPurchaseService>()
                           .SingleInstance();
                    break;
            }

        }
    }
}
