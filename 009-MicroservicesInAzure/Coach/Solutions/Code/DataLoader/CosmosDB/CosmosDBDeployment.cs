using ContosoTravel.Web.Application;
using ContosoTravel.Web.Application.Data.CosmosSQL;
using ContosoTravel.Web.Application.Interfaces;
using Microsoft.SqlServer.Management.Common;
using Microsoft.SqlServer.Management.Smo;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace DataLoader.CosmosDB
{
    public class CosmosSQLDeployment : IDataDeployment
    {
        private readonly CosmosDBProvider _cosmosDBProvider;
        private readonly ContosoConfiguration _contosoConfiguration;

        public CosmosSQLDeployment(CosmosDBProvider cosmosDBProvider, ContosoConfiguration contosoConfiguration)
        {
            _cosmosDBProvider = cosmosDBProvider;
            _contosoConfiguration = contosoConfiguration;
        }

        public async Task Configure(CancellationToken cancellationToken)
        {
            var client = _cosmosDBProvider.GetDocumentClient();
            await client.CreateDatabaseIfNotExistsAsync(new Microsoft.Azure.Documents.Database() { Id = _contosoConfiguration.DatabaseName });
        }
    }    
}
