namespace PartsUnlimited.Models
{
    public class Raincheck
    {
        public int RaincheckId { get; set; }

        public string Name { get; set; }

        public int ProductId { get; set; }

        public virtual Product Product { get; set; }

        public int Count { get; set; }

        public double SalePrice { get; set; }

        public int StoreId { get; set; }

        public virtual Store IssuerStore { get; set; }
    }
}