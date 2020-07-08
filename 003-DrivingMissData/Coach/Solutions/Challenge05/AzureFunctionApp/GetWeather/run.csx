#r "Microsoft.WindowsAzure.Storage"
#r "Newtonsoft.Json"

using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Queue;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public static async Task Run(Stream inputData, string name, TraceWriter log)
{
    log.Info($"GetWeather function Processed blob\n Name: {name} with Size: {inputData.Length} Bytes");

    // Get storage acct reference
    string storageConnString = "DefaultEndpointsProtocol=https;AccountName=[PROVIDE];AccountKey=[PROVIDE]";
    CloudStorageAccount storageAccount = CloudStorageAccount.Parse(storageConnString);

    // Get queue reference
    string queueName = "[PROVIDE]";
    CloudQueueClient queueClient = storageAccount.CreateCloudQueueClient();
    CloudQueue queue = queueClient.GetQueueReference(queueName);
    await queue.CreateIfNotExistsAsync();

    // Prepare API data and HTTP client
	string apiRoot = "https://api.darksky.net/forecast/";
    string apiKey = "[PROVIDE]";
    HttpClient httpClient = new HttpClient();

    try
    {
        using (StreamReader sr = new StreamReader(inputData, Encoding.UTF8))
        {
            // Read the stream line by line until end
            while (!sr.EndOfStream)
            {
                string line = sr.ReadLine();

                log.Info(line);

                // The line contains three pieces (reference the query we wrote in Databricks to emit the input data for weather queries - Challenge05, 15*.scala)
                string[] apiParams = line.Split(',');
                string pickup_datetime = apiParams[0];
                string pickup_longitude = apiParams[1];
                string pickup_latitude = apiParams[2];

                // DarkSky API requires date/time in less precise format than emitted by Hive - we have to eliminate fractional seconds
                string pickup_datetime_darksky = pickup_datetime.Substring(0, 19) + "Z";

                // Assemble the full URL for this API call
                string address = apiRoot + $"{apiKey}/{pickup_latitude},{pickup_longitude},{pickup_datetime_darksky}?exclude=currently,minutely,hourly,alerts,flags";
                log.Info(address);
                
                // Call the API and get an HTTP response
                HttpResponseMessage response = await httpClient.GetAsync(address);

                // Get the payload out of the API response - that will be JSON weather data
                string apiResponseContent = await response.Content.ReadAsStringAsync();

                // We deserialize the JSON weather data so we can add to it
                JObject content = JObject.Parse(apiResponseContent);

                // Add the original pickup date/time so it's in the identical format to what we got from Databricks/Hive, so we can join on date/time + latitude + longitude
                content.Add("pickup_datetime", pickup_datetime);

                // Send weather data item to storage queue so it will be picked up by SaveToCosmosDb function
                await queue.AddMessageAsync(new CloudQueueMessage(content.ToString()));
           }
        }
    }
    catch (Exception ex)
    {
        log.Error(ex.Message);
    }
}
