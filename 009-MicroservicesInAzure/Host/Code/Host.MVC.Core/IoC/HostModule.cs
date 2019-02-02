using Autofac;
using ContosoTravel.Web.Application.Data;
using ContosoTravel.Web.Application.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace ContosoTravel.Web.Host.MVC.Core.IoC
{
    public class HostModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<ASPNetCoreCartCookieProvider>().As<ICartCookieProvider>();
            builder.RegisterType<SQLServerConnectionProvider>().As<ISQLServerConnectionProvider>();
            builder.RegisterType<Services.AirportDataServiceClient>().As<IAirportDataProvider>().SingleInstance();
            builder.RegisterType<Services.CarDataServiceClient>().As<ICarDataProvider>().SingleInstance();
            builder.RegisterType<Services.FlightDataServiceClient>().As<IFlightDataProvider>().SingleInstance();
            builder.RegisterType<Services.HotelDataServiceClient>().As<IHotelDataProvider>().SingleInstance();
            builder.RegisterType<Services.ItineraryDataServiceClient>().As<IItineraryDataProvider>().SingleInstance();
            builder.RegisterType<Services.ItineraryPurchaseServiceClient>().As<IPurchaseService>().SingleInstance();
        }
    }
}
