using Contoso.Web.Configuration;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Net.Http;
using System.Threading.Tasks;

namespace Contoso.Web.Controllers
{
    [Authorize]
    public class StaticController : Controller
    {
        private readonly IConfiguration _configuration;

        public StaticController(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        public IActionResult Index()
        {
            var config = new WebAppConfiguration
            {
                ApiUrl = _configuration["ApiUrl"],
                PolicyDocumentsPath = _configuration["PolicyDocumentsPath"],
                ApimSubscriptionKey = _configuration["ApimSubscriptionKey"]
            };
            return View(config);
        }

        public IActionResult Dependents()
        {
            return View();
        }

        public IActionResult Dependent()
        {
            return View();
        }

        public IActionResult People()
        {
            return View();
        }

        public IActionResult Person()
        {
            return View();
        }

        public IActionResult Policies()
        {
            return View();
        }

        public IActionResult Policy()
        {
            return View();
        }

        public IActionResult PolicyHolders()
        {
            return View();
        }

        public IActionResult PolicyHolder()
        {
            return View();
        }

        [HttpGet("download/{policyHolder}/{policyNumber}")]
        public async Task<IActionResult> DownloadPolicyDocument(string policyHolder, string policyNumber)
        {
            using (var client = new HttpClient())
            {
                try
                {
                    client.DefaultRequestHeaders.Add("Ocp-Apim-Subscription-Key", _configuration["ApimSubscriptionKey"]);
                    var policyDocumentsPath = _configuration["PolicyDocumentsPath"];
                    var url = policyDocumentsPath.Replace("{policyHolder}", policyHolder).Replace("{policyNumber}", policyNumber);

                    var bytes = await client.GetByteArrayAsync(url);

                    return File(bytes, "application/pdf");
                }
                catch(Exception ex)
                {
                    return NotFound();
                }
            }
        }
    }
}