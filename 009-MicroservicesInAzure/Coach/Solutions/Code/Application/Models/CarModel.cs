using ContosoTravel.Web.Application.Data.Mock;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;
using System.Text;

namespace ContosoTravel.Web.Application.Models
{
    public class CarModel
    {
        public CarModel()
        {
            Id = BaseData.GetNextKey();
        }

        [JsonProperty(PropertyName = "id")]
        public string IdString
        {
            get
            {
                return Id.ToString();
            }
            set
            {
                int tmp;
                if (int.TryParse(value, out tmp))
                {
                    Id = tmp;
                }
            }
        }

        [JsonIgnore]
        public int Id { get; set; }
        public string Location { get; set; }

        public AirportModel LocationAirport { get; set; }

        public DateTimeOffset StartingTime { get; set; }
        public int StartingTimeEpoc
        {
            get
            {
                return StartingTime.ToEpoch();
            }
            set
            {

            }
        }

        public DateTimeOffset EndingTime { get; set; }
        public int EndingTimeEpoc
        {
            get
            {
                return EndingTime.ToEpoch();
            }
            set
            {

            }
        }

        public double Cost { get; set; }
        [JsonConverter(typeof(StringEnumConverter))]
        public CarType CarType { get; set; }
    }

    public class CarModelWithPrice
    {
        public CarModelWithPrice(CarModel car, double numberOfDays)
        {
            Car = car;
            NumberOfDays = numberOfDays;
        }

        public CarModel Car { get; set; }
        public string TotalPrice => string.Format("{0:c}", Car.Cost * NumberOfDays);
        public double NumberOfDays { get; set; }
    }

    public enum CarType : int
    {
        Compact = 0,
        Intermediate = 1,
        Full = 2,
        SUV = 3,
        Minivan = 4,
        Convertable = 5
    }
}
