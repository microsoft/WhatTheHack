using PartsUnlimited.Utils;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace PartsUnlimited.Areas.Admin.Controllers
{
    public class RaincheckController : AdminController
    {
        private readonly IRaincheckQuery _query;

        public RaincheckController(IRaincheckQuery query)
        {
            _query = query;
        }

        public async Task<ActionResult> Index()
        {
            var rainchecks = await _query.GetAllAsync();

            return View(rainchecks);
        }
    }
}
