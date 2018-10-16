using System.Collections.Generic;
using System.Web.Mvc;
using PartsUnlimited.Models;

namespace PartsUnlimited.ViewModels
{
    public class EditProductViewModel
    {
        public Product Product { get; set; }
        public IEnumerable<SelectListItem> Categories { get; set; }
    }
}