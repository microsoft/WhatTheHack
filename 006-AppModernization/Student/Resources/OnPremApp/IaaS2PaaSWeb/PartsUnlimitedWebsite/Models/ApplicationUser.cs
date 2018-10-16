using Microsoft.AspNet.Identity.EntityFramework;

namespace PartsUnlimited.Models
{
    public class ApplicationUser : IdentityUser
    {
        public string Name { get; set; }
    }
}