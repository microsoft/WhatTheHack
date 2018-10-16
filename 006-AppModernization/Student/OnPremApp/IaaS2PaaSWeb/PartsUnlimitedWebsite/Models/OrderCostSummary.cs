namespace PartsUnlimited.Models
{
    public class OrderCostSummary
    {
        public string CartSubTotal { get; set; }
        public string CartShipping { get; set; }
        public string CartTax { get; set; }
        public string CartTotal { get; set; }
    }
}