namespace PartsUnlimited.Models
{
    public class OrderDetail : ILineItem
    {
        public int OrderDetailId { get; set; }

        public int OrderId { get; set; }

        public int ProductId { get; set; }

        public int Count { get; set; }

        public decimal UnitPrice { get; set; }

        public virtual Product Product { get; set; }

        public virtual Order Order { get; set; }
    }
}