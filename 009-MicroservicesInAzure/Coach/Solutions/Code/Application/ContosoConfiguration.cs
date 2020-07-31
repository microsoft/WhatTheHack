using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Configuration;

namespace ContosoTravel.Web.Application
{
    public class ContosoConfiguration
    {
        public static ContosoConfiguration PopulateFromConfig(IConfiguration appConfig, bool withDBSecrets = false)
        {
            DataType = (DataType)Enum.Parse(typeof(DataType), appConfig["DataType"]);
            ServicesType = (ServicesType)Enum.Parse(typeof(ServicesType), appConfig["ServicesType"]);

            var newConfig = appConfig.Get<ContosoConfiguration>();

            if ( !withDBSecrets )
            {
                newConfig.DataAdministratorLogin = string.Empty;
                newConfig.DataAdministratorLoginPassword = string.Empty;
            }

            return newConfig;
        }

        public static ServicesType ServicesType { get; set; } = ServicesType.Monolith;
        public static DataType DataType { get; set; } = DataType.Mock;
        public string ServicesMiddlewareAccountName { get; set; }
        public string ServiceConnectionString { get; set; }
        public string DataAccountName { get; set; }
        public string DatabaseName { get; set; }
        public string SubscriptionId { get; set; }
        public string ResourceGroupName { get; set; }
        public string AzureRegion { get; set; }
        public string TenantId { get; set; }
        public string DataAdministratorLogin { get; set; }
        public string DataAdministratorLoginPassword { get; set; }
        public string DataAccountPassword { get; set; }
        public string DataAccountUserName { get; set; }

    }

    public enum ServicesType
    {
        Monolith,
        ServiceBus,
        EventGrid
    }

    public enum DataType
    {
        Mock,
        CosmosSQL,
        SQL
    }
}
