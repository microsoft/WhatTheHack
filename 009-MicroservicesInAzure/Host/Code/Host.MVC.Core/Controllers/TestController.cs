using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using ContosoTravel.Web.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace Host.MVC.Core.Controllers
{
    public class TestController : Controller
    {
        private readonly IAirportDataProvider _airportDataProvider;

        public TestController(IAirportDataProvider airportDataProvider)
        {
            _airportDataProvider = airportDataProvider;
        }

        public async Task<IActionResult> Index(CancellationToken cancellationToken)
        {
            return View(ContosoTravel.Web.Application.Models.TestSettings.GetNewTest(await _airportDataProvider.GetAll(cancellationToken)));
        }
    }
}