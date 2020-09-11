using System;
using System.Collections.Generic;
using System.Text;

namespace ContosoTravel.Web.Application.Models
{
    public class ItineraryModel : CartModel
    {
        public string RecordLocator { get; set; }
    }

    public class ItineraryPersistenceModel : CartPersistenceModel
    {
        public string RecordLocator { get; set; }
        public DateTimeOffset PurchasedOn { get; set; }
    }
}
