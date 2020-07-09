using System;
using System.ComponentModel.DataAnnotations;

namespace InventoryService.Api.Models
{
    public class InventoryItem
    {
        [Key]
        public string Sku { get; set; }
        public int Quantity { get; set; }
        public DateTime Modified { get; set; }
    }
}