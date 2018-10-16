using Microsoft.Practices.Unity;
using PartsUnlimited.Models;
using PartsUnlimited.ProductSearch;
using PartsUnlimited.Recommendations;
using PartsUnlimited.Utils;

namespace PartsUnlimited
{
    public class UnityConfig
    {
        public static UnityContainer BuildContainer()
        {
            var container = new UnityContainer();

            container.RegisterType<IPartsUnlimitedContext, PartsUnlimitedContext>();
            container.RegisterType<IOrdersQuery, OrdersQuery>();
            container.RegisterType<IRaincheckQuery, RaincheckQuery>();
            container.RegisterType<IRecommendationEngine, AzureMLFrequentlyBoughtTogetherRecommendationEngine>();
            container.RegisterType<ITelemetryProvider, TelemetryProvider>();
            container.RegisterType<IProductSearch, StringContainsProductSearch>();
            container.RegisterType<IShippingTaxCalculator, DefaultShippingTaxCalculator>();

			container.RegisterInstance<IHttpClient>(container.Resolve<HttpClientWrapper>());

            return container;
        }
    }
}