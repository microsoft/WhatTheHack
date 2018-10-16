using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web.Http;
using PartsUnlimited.Models;
using System.Web.Mvc;

namespace PartsUnlimited.Api
{
    [System.Web.Http.RoutePrefix("api/products")]
    public class ProductsController : ApiController
    {
        private readonly IPartsUnlimitedContext _context;

        public ProductsController(IPartsUnlimitedContext context)
        {
            _context = context;
        }

        [System.Web.Http.HttpGet, System.Web.Http.Route, System.Web.Http.ActionName("GetProducts")]
        public IList<Product> Get(bool sale = false)
        {
            if (!sale)
            {
                return _context.Products.ToList();
            }

            return _context.Products.Where(p => p.Price != p.SalePrice).ToList();
        }

        [System.Web.Http.HttpGet, System.Web.Http.Route("{id}"), System.Web.Http.ActionName("GetProduct")]
        public async Task<IHttpActionResult> Get(int id)
        {
            var product = await _context.Products.FirstOrDefaultAsync(p => p.ProductId == id);
            if (product == null)
            {
                return NotFound();
            }

            return Content(HttpStatusCode.OK, product);
        }
    }
}
