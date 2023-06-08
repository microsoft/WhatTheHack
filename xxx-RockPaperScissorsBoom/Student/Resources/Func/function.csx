#r "Microsoft.Azure.EventGrid"
#r "System.Net.Http"
using Microsoft.Azure.EventGrid.Models;

public static void Run(EventGridEvent eventGridEvent, ILogger log)
{
    var url = "https://AzureLogicAppUrl";
    HttpClient Client = new HttpClient();
    var content = new StringContent(eventGridEvent.Data.ToString(), System.Text.Encoding.UTF8, "application/json");
    var r = Client.PostAsync(url, content).Result;
}
