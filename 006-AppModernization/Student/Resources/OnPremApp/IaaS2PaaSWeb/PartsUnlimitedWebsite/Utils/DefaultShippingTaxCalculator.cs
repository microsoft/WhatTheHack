using PartsUnlimited.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PartsUnlimited.Utils
{
	public class DefaultShippingTaxCalculator : IShippingTaxCalculator
	{
		public OrderCostSummary CalculateCost(IEnumerable<ILineItem> items, string postalCode)
		{
			decimal subTotal = 0, tax = 0, shipping = 0, total = 0;
			int itemsCount = 0;
			if (items != null)
			{
				subTotal = items.Sum(x => x.Count * x.Product.Price);
				itemsCount = items.Sum(x => x.Count);
				shipping = CalculateShipping(itemsCount);
				tax = CalculateTax(subTotal + shipping, postalCode);
				total = subTotal + shipping + tax;
			}

			return new OrderCostSummary()
			{
				CartSubTotal = subTotal.ToString("C"),
				CartShipping = shipping.ToString("C"),
				CartTax = tax.ToString("C"),
				CartTotal = total.ToString("C")
			};
		}

		protected decimal CalculateTax(decimal taxable, string postalCode = null)
		{
			var taxRate = (decimal)0.06;
			if (postalCode?.StartsWith("98") == true)
			{
				taxRate = (decimal)0.075;
			}
			return taxable * taxRate;
		}

		protected decimal CalculateShipping(int itemsCount)
		{
			return itemsCount * (decimal)5.0;
		}
	}
}