using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Runtime.Caching;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Mvc;
using Microsoft.AspNet.SignalR;
using PartsUnlimited.Hubs;
using PartsUnlimited.Models;
using PartsUnlimited.ViewModels;

namespace PartsUnlimited.Areas.Admin.Controllers
{
    public enum SortField { Name, Title, Price }
    public enum SortDirection { Up, Down }

    public class StoreManagerController : AdminController
    {
        private readonly IPartsUnlimitedContext db;

        public StoreManagerController(IPartsUnlimitedContext context)
        {
            db = context;
        }

        //
        // GET: /StoreManager/

        public ActionResult Index(SortField sortField = SortField.Name, SortDirection sortDirection = SortDirection.Up)
        {
            var products = db.Products.Include("Category").ToList();

            var sorted = Sort(products, sortField, sortDirection);

            return View(sorted);
        }

        private IEnumerable<Product> Sort(IEnumerable<Product> products, SortField sortField, SortDirection sortDirection)
        {
            if (sortField == SortField.Name)
            {
                if (sortDirection == SortDirection.Up)
                {
                    return products.OrderBy(o => o.Category.Name);
                }
                else
                {
                    return products.OrderByDescending(o => o.Category.Name);
                }
            }

            if (sortField == SortField.Price)
            {
                if (sortDirection == SortDirection.Up)
                {
                    return products.OrderBy(o => o.Price);
                }
                else
                {
                    return products.OrderByDescending(o => o.Price);
                }
            }

            if (sortField == SortField.Title)
            {
                if (sortDirection == SortDirection.Up)
                {
                    return products.OrderBy(o => o.Title);
                }
                else
                {
                    return products.OrderByDescending(o => o.Title);
                }
            }

            // Should not reach here, but return products for compiler
            return products;
        }


        //
        // GET: /StoreManager/Details/5

        public ActionResult Details(int id)
        {
            string cacheId = string.Format("product_{0}", id);
            var product = MemoryCache.Default[cacheId] as Product;
            if (product == null)
            {
                product = db.Products.Include("Categories").FirstOrDefault(a => a.ProductId == id);
                if (product != null)
                {
                    MemoryCache.Default.Add(cacheId, product, DateTimeOffset.Now.AddMinutes(10));
                }
            }

            if (product == null)
            {
                MemoryCache.Default.Remove(cacheId);
                return View();
            }

            return View(product);
        }

        //
        // GET: /StoreManager/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: /StoreManager/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Create(Product product)
        {
            if (ModelState.IsValid)
            {
                db.Products.Add(product);
                await db.SaveChangesAsync(CancellationToken.None);

                var annoucementHub = GlobalHost.ConnectionManager.GetHubContext<AnnouncementHub>();
                annoucementHub.Clients.All.announcement(new ProductData() { Title = product.Title, Url = Url.Action("Details", "Store", new { id = product.ProductId }) });
                
                MemoryCache.Default.Remove("latestProduct");
                return RedirectToAction("Index");
            }

            return View(product);
        }

        //
        // GET: /StoreManager/Edit/5
        public ActionResult Edit(int id)
        {
            Product product = db.Products.FirstOrDefault(a => a.ProductId == id);

            if (product == null)
            {
                return View(product);
            }

            ViewBag.categories = db.Categories
                .Select(x => new SelectListItem
                {
                    Text = x.Name, 
                    Value = x.CategoryId.ToString(), 
                    Selected = product.CategoryId == x.CategoryId
                });

            return View(product);
        }


        //
        // POST: /StoreManager/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Edit(Product product)
        {
            if (ModelState.IsValid)
            {
                db.Entry(product).State = EntityState.Modified;
                await db.SaveChangesAsync(CancellationToken.None);
                //Invalidate the cache entry as it is modified
                MemoryCache.Default.Remove(string.Format("product_{0}", product.ProductId));
                return RedirectToAction("Index");
            }

            ViewBag.Categories = new SelectList(db.Categories, "CategoryId", "Name", product.CategoryId);
            return View(product);
        }

        //
        // GET: /StoreManager/RemoveProduct/5
        public ActionResult RemoveProduct(int id)
        {
            Product product = db.Products.Where(a => a.ProductId == id).FirstOrDefault();
            return View(product);
        }

        //
        // POST: /StoreManager/RemoveProduct/5
        [HttpPost, ActionName("RemoveProduct")]
        public async Task<ActionResult> RemoveProductConfirmed(int id)
        {
            Product product = db.Products.Where(a => a.ProductId == id).FirstOrDefault();

            if (product != null)
            {
                db.Products.Remove(product);
                await db.SaveChangesAsync(CancellationToken.None);
                //Remove the cache entry as it is removed
                MemoryCache.Default.Remove(string.Format("product_{0}", id));
            }

            return RedirectToAction("Index");
        }

#if TESTING
        //
        // GET: /StoreManager/GetProductIdFromName
        // Note: Added for automated testing purpose. Application does not use this.
        [HttpGet]
        public ActionResult GetProductIdFromName(string productName)
        {
            var product = db.Products.Where(a => a.Title == productName).FirstOrDefault();

            if (product == null)
            {
                return HttpNotFound();
            }

            return new ContentResult { Content = product.ProductId.ToString(), ContentType = "text/plain" };
        }
#endif
    }
}
