using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using ContosoMasks.ServiceHost.Models;
using Microsoft.Azure.Storage.Blob;
using Microsoft.Azure.Storage.Auth;
using Microsoft.Azure.Storage;
using Microsoft.Azure.Services.AppAuthentication;

namespace ContosoMasks.ServiceHost.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Index(bool frontdoor = false, bool cdn = false)
        {
            if ( frontdoor )
            {
                string url = string.IsNullOrEmpty(SiteConfiguration.FrontDoorURL) ? "/" : SiteConfiguration.FrontDoorURL;
                if ( cdn )
                { 
                    return Redirect(url + "?cdn=true");
                }
                else
                {
                    return Redirect(url);
                }
            }

            string cdnEndPoint = SiteConfiguration.StaticAssetRoot;

            if ( string.IsNullOrEmpty(cdnEndPoint))
            {
                cdnEndPoint = "/";
            }
            else
            {
                cdnEndPoint = cdnEndPoint.TrimEnd('/') + "/";
            }

            this.Response.Headers.Add("X-ContosoMasks-StaticEndpoint", cdnEndPoint);

            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Message()
        {
            string cdnEndPoint = SiteConfiguration.StaticAssetRoot;

            if (string.IsNullOrEmpty(cdnEndPoint))
            {
                cdnEndPoint = "/";
            }
            else
            {
                cdnEndPoint = cdnEndPoint.TrimEnd('/') + "/";
            }

            this.Response.Headers.Add("X-ContosoMasks-StaticEndpoint", cdnEndPoint);

            
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public async Task<IActionResult> LoadTests()
        {
            var blobClient = await getBlobClient();

            var container = blobClient.GetContainerReference("logfiles");

            var allBlobs = container.ListBlobs();

            List<LoadTestRun> runs = new List<LoadTestRun>();

            if ( allBlobs != null && allBlobs.Count() > 0 )
            {
                foreach (CloudBlockBlob blob in allBlobs )
                {
                    var blobContent = await blob.DownloadTextAsync();
                    string[] toks = blob.Name.Split('-');
                    string id = toks[2];
                    string url = string.Join('.', toks.Skip(4));

                    LoadTestRun run = runs.SafeFirstOrDefault(r => r.ID.EqualsOI(id));
                    if ( run == null )
                    {
                        run = new LoadTestRun(url, id);
                        runs.Add(run);
                    }
                    
                    run.AddFile(toks[1], blobContent);
                }
            }

            return View(runs);
        }

        private async Task<CloudBlobClient> getBlobClient()
        {
            string accessToken = await new AzureServiceTokenProvider().GetAccessTokenAsync($"https://{SiteConfiguration.StorageAccount}.blob.core.windows.net");
            TokenCredential tokenCredential = new TokenCredential(accessToken);

            StorageCredentials storageCredentials = new StorageCredentials(tokenCredential);

            // blobs access
            CloudBlobClient blobClient = new CloudBlobClient(new StorageUri(new Uri($"https://{SiteConfiguration.StorageAccount}.blob.core.windows.net")), storageCredentials);
            return blobClient;
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
