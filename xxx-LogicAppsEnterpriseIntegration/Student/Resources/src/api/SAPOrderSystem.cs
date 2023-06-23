using System.Collections.Generic;
using System.Net;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;

namespace api
{
  public class SAPOrderSystem
  {
    private readonly ILogger _logger;

    public SAPOrderSystem(ILoggerFactory loggerFactory)
    {
      _logger = loggerFactory.CreateLogger<SAPOrderSystem>();
    }

    [Function("SAPOrderSystem")]
    public async Task<HttpResponseData> Run([HttpTrigger(AuthorizationLevel.Anonymous, "post")] HttpRequestData req, string orderName)
    {
      _logger.LogInformation("C# HTTP trigger function processed a request.");

      var response = req.CreateResponse(HttpStatusCode.OK);
      var returnValue = new SAPOrder
      {
        OrderId = new Random().Next(1, 1000000),
        OrderName = orderName
      };

      await response.WriteAsJsonAsync<SAPOrder>(returnValue);

      return response;
    }
  }

  public class SAPOrder
  {
    public int OrderId { get; set; }
    public string? OrderName { get; set; }
  }
}
