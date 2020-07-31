using System;
using System.Collections.Generic;
using System.Text;
using ContosoTravel.Web.Application.Data.Mock;

namespace ContosoTravel.Web.Application.Models
{
    public class SearchModel
    {
        public bool IncludeEndLocation { get; set; }
        public string StartLocation { get; set; }
        public string StartLocationLabel { get; set; }
        public string EndLocation { get; set; }
        public string EndLocationLabel { get; set; }
        public DateTimeOffset StartDate { get; set; }
        public string StartDateLabel { get; set; }

        public DateTimeOffset EndDate { get; set; }
        public string EndDateLabel { get; set; }
        public SearchMode SearchMode { get; set; }
        public IEnumerable<AirportModel> AirPorts { get; set; }

        public bool IsTest { get; set; }
    }

    public enum SearchMode
    {
        Flights,
        Hotels,
        Cars
    }
}
