using Autofac;
using ContosoTravel.Web.Application.Interfaces.MVC;

namespace ContosoTravel.Web.Application.IoC
{
    public class MVCModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {  
            builder.RegisterType<Controllers.MVC.FlightsController>()
                   .As<IFlightsController>()
                   .SingleInstance();

            builder.RegisterType<Controllers.MVC.HotelsController>()
                  .As<IHotelsController>()
                  .SingleInstance();

            builder.RegisterType<Controllers.MVC.CarsController>()
                   .As<ICarsController>()
                   .SingleInstance();

            builder.RegisterType<Controllers.MVC.CartController>()
                   .As<ICartController>()
                   .SingleInstance();

            builder.RegisterType<Controllers.MVC.ItineraryController>()
                   .As<IItineraryController>()
                   .SingleInstance();

        }
    }
}
