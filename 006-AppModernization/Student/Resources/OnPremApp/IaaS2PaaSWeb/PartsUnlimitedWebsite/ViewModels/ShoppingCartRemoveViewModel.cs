namespace PartsUnlimited.ViewModels
{
    public class ShoppingCartRemoveViewModel
    {
        public string Message { get; set; }
        public string CartSubTotal { get; set; }
        public string CartShipping { get; set; }
        public string CartTax { get; set; }
        public string CartTotal { get; set; }
        public int CartCount { get; set; }
        public int ItemCount { get; set; }
        public int DeleteId { get; set; }
    }
}