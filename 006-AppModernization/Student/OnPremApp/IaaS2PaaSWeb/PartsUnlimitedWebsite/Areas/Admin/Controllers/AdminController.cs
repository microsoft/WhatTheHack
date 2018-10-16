using System.Web.Mvc;

namespace PartsUnlimited.Areas.Admin.Controllers
{
    [Authorize(Roles = AdminConstants.Role)]
    public abstract class AdminController : Controller
    {
    }
}