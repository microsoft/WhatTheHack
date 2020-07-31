using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace DataLoader
{
    public interface IDataDeployment
    {
        Task Configure(CancellationToken cancellationToken);
    }
}
