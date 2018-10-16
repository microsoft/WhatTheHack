using System.Collections.Generic;
using PartsUnlimited.Models;

namespace PartsUnlimited.ViewModels
{
    public class HomeViewModel
    {
        public List<Product> NewProducts { get; set; }
        public List<Product> TopSellingProducts { get; set; }
        public List<CommunityPost> CommunityPosts { get; set; }
    }
}