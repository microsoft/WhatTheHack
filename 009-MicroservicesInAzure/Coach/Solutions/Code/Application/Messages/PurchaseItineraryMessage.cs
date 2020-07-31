using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Text;

namespace ContosoTravel.Web.Application.Messages
{
    public class PurchaseItineraryMessage
    {
        public string CartId { get; set; }
        public DateTimeOffset PurchasedOn { get; set; }
    }
}
