using ContosoTravel.Web.Application.Data.Mock;
using Newtonsoft.Json;
using System.Collections.Generic;

namespace ContosoTravel.Web.Application.Models
{
    public class AirportModel
    {
        [JsonProperty(PropertyName = "id")]
        public string AirportCode { get; set; }
        public string AirportName { get; set; }
        public string CityName { get; set; }
        public string State { get; set; }
        public string TimeZone { get; set; }

        public static List<AirportModel> GetAll()
        {
            return Newtonsoft.Json.JsonConvert.DeserializeObject<List<AirportModel>>(BaseData.AIRPORTSJSON);
        }
    }
}
