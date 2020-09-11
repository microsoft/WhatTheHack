using Autofac;
using Autofac.Extensions.DependencyInjection;
using ContosoTravel.Web.Application;
using ContosoTravel.Web.Application.Data.Mock;
using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Models;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Nito.AsyncEx;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace DataLoader
{
    public class Program
    {
        static IContainer Container = null;
        static AutofacServiceProvider ServiceProvider = null;
        static IConfiguration AppConfig = null;

        static void Main(string[] args)
        {
            AsyncContext.Run(() => MainAsync(args));
            Console.WriteLine("DataLoader Complete!");
            Console.ReadLine();
        }

        static async Task MainAsync(string[] args)
        {
            CancellationTokenSource cts = new CancellationTokenSource();
            AppConfig = new ConfigurationBuilder()
                        .SetBasePath(Directory.GetCurrentDirectory())
                           .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
                           .AddEnvironmentVariables().Build();
            SetupIoC();
            await SetupData(cts.Token);
            await DataLoad(cts.Token);
        }

        private static async Task SetupData(CancellationToken token)
        {
            var deployer = Container.Resolve<IDataDeployment>();
            await deployer.Configure(token);
        }

        private static async Task DataLoad(CancellationToken cancellationToken)
        {
            await LoadData<IAirportDataProvider, AirportModel>(cancellationToken);
            await Task.WhenAll(LoadData<ICarDataProvider, CarModel>(cancellationToken),
                               LoadData<IHotelDataProvider, HotelModel>(cancellationToken),
                               LoadData<IFlightDataProvider, FlightModel>(cancellationToken));
            //await LoadData<ICarDataProvider, CarModel>(cancellationToken);
            //await LoadData<IHotelDataProvider, HotelModel>(cancellationToken);
            //await LoadData<IFlightDataProvider, FlightModel>(cancellationToken);
        }

        public static IEnumerable<T[]> GetChunk<T>(IEnumerable<T> input, int size)
        {
            int i = 0;
            while (input.Count() > size * i)
            {
                yield return input.Skip(size * i).Take(size).ToArray();
                i++;
            }
        }

        private static async Task LoadData<IData, DataType>(CancellationToken cancellationToken)
        {
            var dataAdapter = (IWritableDataProvider<DataType>)Container.Resolve<IData>();
            var dataSource = Container.Resolve<IGetAllProvider<DataType>>();

            var allItems = await dataSource.GetAll(cancellationToken);
            Console.WriteLine($"Loading {typeof(DataType).Name}");
            int count = 0;
            int increment = 20;
            foreach (var items in GetChunk(allItems, increment))
            {
                Console.WriteLine($"\tLoadint {typeof(DataType).Name}: [{count * increment} to {(++count) * increment}] out of {allItems.Count()}]");

                List<Task> waitForMe = new List<Task>();
                foreach (DataType item in items)
                {
                    waitForMe.Add(dataAdapter.Persist(item, cancellationToken));
                }

                await Task.WhenAll(waitForMe);
            }
        }

        private static void SetupIoC()
        {
            // The Microsoft.Extensions.DependencyInjection.ServiceCollection
            // has extension methods provided by other .NET Core libraries to
            // regsiter services with DI.
            var serviceCollection = new ServiceCollection();

            // The Microsoft.Extensions.Logging package provides this one-liner
            // to add logging services.
            serviceCollection.AddLogging();

            var containerBuilder = new ContainerBuilder();

            // Once you've registered everything in the ServiceCollection, call
            // Populate to bring those registrations into Autofac. This is
            // just like a foreach over the list of things in the collection
            // to add them to Autofac.
            containerBuilder.Populate(serviceCollection);

            Setup.InitCotoso(AppConfig["KeyVaultUrl"], Directory.GetCurrentDirectory(), typeof(Program).Assembly, containerBuilder, true);

            Container = containerBuilder.Build();
            ServiceProvider = new AutofacServiceProvider(Container);
        }
    }
}
