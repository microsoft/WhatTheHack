using PartsUnlimited.Models;

namespace PartsUnlimited.ViewModels
{
    public class OrderDetailsViewModel
    {
        public OrderCostSummary OrderCostSummary { get; set; }
        public Order Order { get; set; }
    }
}