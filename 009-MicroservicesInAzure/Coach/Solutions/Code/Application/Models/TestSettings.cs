using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ContosoTravel.Web.Application.Models
{
    public class TestSettings
    {
        public static Random random = new Random();

        public static TestSettings GetNewTest(IEnumerable<AirportModel> airportModels)
        {
            var airports = airportModels.ToArray();
            int minutesInADay = 60 * 24;
            int minutesInAWeek = minutesInADay * 7;
            int minutesInAMonth = minutesInADay * 30;

            TestSettings newSettings = new TestSettings();

            newSettings.DepartFrom = airports[random.Next(airports.Length - 1)].AirportCode;
            newSettings.ArriveAt = airports[random.Next(airports.Length - 1)].AirportCode;
            newSettings.DepartOn = DateTimeOffset.Now.AddMinutes(random.NextDouble() * minutesInAWeek);
            newSettings.ReturnOn = newSettings.DepartOn.AddMinutes(random.NextDouble() * minutesInAWeek);
            newSettings.PurchasedOn = newSettings.DepartOn.AddMinutes(random.NextDouble() * -1 * minutesInAMonth);

            return newSettings;
        }

        public string DepartFrom { get; set; }
        public DateTimeOffset DepartOn { get; set; }
        public string ArriveAt { get; set; }
        public DateTimeOffset ReturnOn { get; set; }
        public DateTimeOffset PurchasedOn { get; set; }
    }
}
