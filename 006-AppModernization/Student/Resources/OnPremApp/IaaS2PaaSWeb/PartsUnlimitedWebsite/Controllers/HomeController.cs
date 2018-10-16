using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Caching;
using System.Web.Mvc;
using PartsUnlimited.Models;
using PartsUnlimited.ViewModels;

namespace PartsUnlimited.Controllers
{
    public class HomeController : Controller
    {
        private readonly IPartsUnlimitedContext _db;
        public int roco_count = 1000;

        public HomeController(IPartsUnlimitedContext context)
        {
            _db = context;
        }

        //
        // GET: /Home/
        public ActionResult Index()
        {
            // Get most popular products
            var topSellingProducts = MemoryCache.Default["topselling"] as List<Product>;
            if (topSellingProducts == null)
            {
                topSellingProducts = GetTopSellingProducts(4);
                MemoryCache.Default.Add("topselling", topSellingProducts, new CacheItemPolicy { AbsoluteExpiration = DateTimeOffset.UtcNow.AddMinutes(10) });
            }

            var newProducts = MemoryCache.Default["newarrivals"] as List<Product>;
            if (newProducts == null)
            {
                newProducts = GetNewProducts(4);
                MemoryCache.Default.Add("newarrivals", newProducts, new CacheItemPolicy { AbsoluteExpiration = DateTimeOffset.UtcNow.AddMinutes(10) });
            }

            var viewModel = new HomeViewModel
            {
                NewProducts = newProducts,
                TopSellingProducts = topSellingProducts,
                CommunityPosts = GetCommunityPosts()
            };

            return View(viewModel);
        }
        
        private List<Product> GetTopSellingProducts(int count)
        {
            // Group the order details by product and return
            // the products with the highest count

            // TODO [EF] We don't query related data as yet, so the OrderByDescending isn't doing anything
            return _db.Products
                .OrderByDescending(a => a.OrderDetails.Count())
                .Take(count)
                .ToList();
        }


public ActionResult Recomendations()
        {
            ViewBag.Message = "Your application description page.";
            //See file /home/Recomendations.cshtml for initial rendering

            // Group the order details by product and return
            // the products the top recomendations for the recomendations page
            
            int count = 0;
            while (count < roco_count
                   ) 
            {
                _db.Products
                    .OrderByDescending(a => a.OrderDetails.Count())
                    .Take(count++)
                    .ToList();
            }


            return View();
        }
        //stubbing in a recomendations action



        private List<Product> GetNewProducts(int count)
        {
            return _db.Products
                .OrderByDescending(a => a.Created)
                .Take(count)
                .ToList();
        }

        private List<CommunityPost> GetCommunityPosts()
        {
            return new List<CommunityPost>{
                new CommunityPost {
                    Content= "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus commodo tellus lorem, et bibendum velit sagittis in. Integer nisl augue, cursus id tellus in, sodales porta.",
                    DatePosted = DateTime.Now,
                    Image = "community_1.png",
                    Source = CommunitySource.Facebook
                },
                new CommunityPost {
                    Content= " Donec tincidunt risus in ligula varius, feugiat placerat nisi condimentum. Quisque rutrum eleifend venenatis. Phasellus a hendrerit urna. Cras arcu leo, hendrerit vel mollis nec.",
                    DatePosted = DateTime.Now,
                    Image = "community_2.png",
                    Source = CommunitySource.Facebook
                },
                new CommunityPost {
                    Content= "Aenean vestibulum non lacus non molestie. Curabitur maximus interdum magna, ullamcorper facilisis tellus fermentum eu. Pellentesque iaculis enim ac vestibulum mollis.",
                    DatePosted = DateTime.Now,
                    Image = "community_3.png",
                    Source = CommunitySource.Facebook
                },
                new CommunityPost {
                    Content= "Ut consectetur sed justo vel convallis. Vestibulum quis metus leo. Nulla hendrerit pharetra dui, vel euismod lectus elementum sit amet. Nam dolor turpis, sodales non mi nec.",
                    DatePosted = DateTime.Now,
                    Image = "community_4.png",
                    Source = CommunitySource.Facebook
                }
            };
        }
    }
}
