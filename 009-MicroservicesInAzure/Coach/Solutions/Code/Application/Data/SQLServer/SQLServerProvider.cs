using ContosoTravel.Web.Application.Interfaces;
using Dapper;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Transactions;

namespace ContosoTravel.Web.Application.Data.SQLServer
{
    public class SQLServerProvider
    {
        private readonly ISQLServerConnectionProvider _connectionProvider;

        public SQLServerProvider(ISQLServerConnectionProvider connectionProvider)
        {
            _connectionProvider = connectionProvider;
        }

        public async Task<IEnumerable<RETVAL>> Query<PARAMS, RETVAL>(string storedProcName, PARAMS parameters, CancellationToken cancellationToken)
        {
            using (TransactionScope scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                using (var connection = await _connectionProvider.GetOpenConnection(cancellationToken))
                {
                    CommandDefinition commandDefinition = new CommandDefinition(storedProcName, parameters, 
                                                                                commandType: System.Data.CommandType.StoredProcedure, 
                                                                                cancellationToken: cancellationToken);
                    var results = await connection.QueryAsync<RETVAL>(commandDefinition);
                    scope.Complete();
                    return results;
                }
            }
        }

        public async Task Execute<PARAMS>(string storedProcName, PARAMS parameters, CancellationToken cancellationToken)
        {
            using (TransactionScope scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                using (var connection = await _connectionProvider.GetOpenConnection(cancellationToken))
                {
                    CommandDefinition commandDefinition = new CommandDefinition(storedProcName, parameters,
                                                                                commandType: System.Data.CommandType.StoredProcedure,
                                                                                cancellationToken: cancellationToken);
                    await connection.ExecuteAsync(commandDefinition);
                    scope.Complete();
                    return;
                }
            }
        }

        public int? NullIfZero(int val)
        {
            if (val == default(int)) return (int?)null;
            return val;
        }

        public double? NullIfZero(double val)
        {
            if (val == default(double)) return (int?)null;
            return val;
        }
    }

    public class SQLServerEmptyParams
    {

    }

    public class SQLServerFindByIdParam
    {
        public int Id { get; set; }
    }
}
