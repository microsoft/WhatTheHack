using ContosoTravel.Web.Application.Interfaces.MVC;
using ContosoTravel.Web.Application.Models;
using Microsoft.AspNetCore.Mvc;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Host.MVC.Core.Controllers
{
    public class CarsController : Controller
    {
        private readonly ICarsController _carsController;

        public CarsController(ICarsController carsController)
        {
            _carsController = carsController;
        }

        public async Task<IActionResult> Index(CancellationToken cancellationToken)
        {
            return View("Search", await _carsController.Index(cancellationToken));
        }

        [HttpPost]
        public async Task<IActionResult> Search(SearchModel searchRequest, CancellationToken cancellationToken)
        {
            return View("CarResults", await _carsController.Search(searchRequest, cancellationToken));
        }

        [HttpPost]
        public async Task<IActionResult> Purchase(CarReservationModel car, CancellationToken cancellationToken)
        {
            await _carsController.Purchase(car, cancellationToken);
            return RedirectToAction("Index", "Cart");
        }
    }
}