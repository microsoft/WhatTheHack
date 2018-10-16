using System.Collections.Generic;
using PartsUnlimited.Models;

namespace PartsUnlimited.Utils
{
	public interface IShippingTaxCalculator
	{
		OrderCostSummary CalculateCost(IEnumerable<ILineItem> items, string orderZip);
	}
}