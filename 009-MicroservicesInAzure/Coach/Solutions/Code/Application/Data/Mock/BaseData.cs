using System;
using System.Collections.Generic;
using System.Text;

namespace ContosoTravel.Web.Application.Data.Mock
{


    public class FlightTime
    {
        public string DepartingFrom { get; set; }
        public string ArrivingAt { get; set; }
        public TimeSpan Duration { get; set; }


        public static List<FlightTime> GetAll()
        {
            return Newtonsoft.Json.JsonConvert.DeserializeObject<List<FlightTime>>(BaseData.FLIGHTTIMESJSON);
        }
    }

    public static class BaseData
    {
        private static int _baseEntityKey = 0;

        public static int GetNextKey()
        {
            return System.Threading.Interlocked.Increment(ref _baseEntityKey);
        }
        #region Airports

        public const string AIRPORTSJSON = @"
[{id:'ATL', airportName:'Hartsfield–Jackson Atlanta International Airport', cityName:'Atlanta',  state:'GA', timeZone:'Eastern Standard Time'},
{id:'ORD', airportName:'O\'Hare International Airport', cityName:'Chicago',  state:'IL', timeZone:'Central Standard Time'},
{id:'DFW', airportName:'Dallas/Fort Worth International Airport', cityName:'Dallas/Fort Worth',  state:'TX', timeZone:'Central Standard Time'},
{id:'DEN', airportName:'Denver International Airport', cityName:'Denver',  state:'CO', timeZone:'Mountain Standard Time'},
{id:'JFK', airportName:'John F. Kennedy International Airport', cityName:'New York',  state:'NY', timeZone:'Eastern Standard Time'},
{id:'LAS', airportName:'McCarran International Airport', cityName:'Las Vegas',  state:'NV', timeZone:'Pacific Standard Time'},
{id:'SEA', airportName:'Seattle–Tacoma International Airport', cityName:'Seattle/Tacoma',  state:'WA', timeZone:'Pacific Standard Time'},
{id:'MCO', airportName:'Orlando International Airport', cityName:'Orlando',  state:'FL', timeZone:'Eastern Standard Time'}]
";
        #endregion

        #region Flight Times
        public const string FLIGHTTIMESJSON = @"
[
    {
      departingFrom:'ATL',
      arrivingAt:'DEN',
      duration:'3:15:00'
    },
    {
      departingFrom:'ATL',
      arrivingAt:'DFW',
      duration:'2:15:00'
    },
    {
      departingFrom:'ATL',
      arrivingAt:'JFK',
      duration:'2:10:00'
    },
    {
      departingFrom:'ATL',
      arrivingAt:'LAS',
      duration:'4:20:00'
    },
    {
      departingFrom:'ATL',
      arrivingAt:'MCO',
      duration:'1:30:00'
    },
    {
      departingFrom:'ATL',
      arrivingAt:'ORD',
      duration:'2:00:00'
    },
    {
      departingFrom:'ATL',
      arrivingAt:'SEA',
      duration:'5:30:00'
    },
    {
      departingFrom:'DEN',
      arrivingAt:'ATL',
      duration:'2:50:00'
    },
    {
      departingFrom:'DEN',
      arrivingAt:'DFW',
      duration:'1:55:00'
    },
    {
      departingFrom:'DEN',
      arrivingAt:'JFK',
      duration:'3:45:00'
    },
    {
      departingFrom:'DEN',
      arrivingAt:'LAS',
      duration:'1:55:00'
    },
    {
      departingFrom:'DEN',
      arrivingAt:'MCO',
      duration:'3:30:00'
    },
    {
      departingFrom:'DEN',
      arrivingAt:'ORD',
      duration:'2:25:00'
    },
    {
      departingFrom:'DEN',
      arrivingAt:'SEA',
      duration:'3:00:00'
    },
    {
      departingFrom:'DFW',
      arrivingAt:'ATL',
      duration:'2:05:00'
    },
    {
      departingFrom:'DFW',
      arrivingAt:'DEN',
      duration:'2:05:00'
    },
    {
      departingFrom:'DFW',
      arrivingAt:'JFK',
      duration:'3:25:00'
    },
    {
      departingFrom:'DFW',
      arrivingAt:'LAS',
      duration:'2:50:00'
    },
    {
      departingFrom:'DFW',
      arrivingAt:'MCO',
      duration:'2:20:00'
    },
    {
      departingFrom:'DFW',
      arrivingAt:'ORD',
      duration:'2:35:00'
    },
    {
      departingFrom:'DFW',
      arrivingAt:'SEA',
      duration:'4:20:00'
    },
    {
      departingFrom:'JFK',
      arrivingAt:'ATL',
      duration:'2:30:00'
    },
    {
      departingFrom:'JFK',
      arrivingAt:'DEN',
      duration:'4:25:00'
    },
    {
      departingFrom:'JFK',
      arrivingAt:'DFW',
      duration:'3:55:00'
    },
    {
      departingFrom:'JFK',
      arrivingAt:'LAS',
      duration:'5:40:00'
    },
    {
      departingFrom:'JFK',
      arrivingAt:'MCO',
      duration:'2:50:00'
    },
    {
      departingFrom:'JFK',
      arrivingAt:'ORD',
      duration:'2:35:00'
    },
    {
      departingFrom:'JFK',
      arrivingAt:'SEA',
      duration:'6:15:00'
    },
    {
      departingFrom:'LAS',
      arrivingAt:'ATL',
      duration:'3:50:00'
    },
    {
      departingFrom:'LAS',
      arrivingAt:'DEN',
      duration:'1:50:00'
    },
    {
      departingFrom:'LAS',
      arrivingAt:'DFW',
      duration:'2:40:00'
    },
    {
      departingFrom:'LAS',
      arrivingAt:'JFK',
      duration:'4:55:00'
    },
    {
      departingFrom:'LAS',
      arrivingAt:'MCO',
      duration:'4:30:00'
    },
    {
      departingFrom:'LAS',
      arrivingAt:'ORD',
      duration:'3:35:00'
    },
    {
      departingFrom:'LAS',
      arrivingAt:'SEA',
      duration:'2:40:00'
    },
    {
      departingFrom:'MCO',
      arrivingAt:'ATL',
      duration:'1:30:00'
    },
    {
      departingFrom:'MCO',
      arrivingAt:'DEN',
      duration:'3:55:00'
    },
    {
      departingFrom:'MCO',
      arrivingAt:'DFW',
      duration:'2:50:00'
    },
    {
      departingFrom:'MCO',
      arrivingAt:'JFK',
      duration:'2:35:00'
    },
    {
      departingFrom:'MCO',
      arrivingAt:'LAS',
      duration:'4:55:00'
    },
    {
      departingFrom:'MCO',
      arrivingAt:'ORD',
      duration:'2:55:00'
    },
    {
      departingFrom:'MCO',
      arrivingAt:'SEA',
      duration:'6:10:00'
    },
    {
      departingFrom:'ORD',
      arrivingAt:'ATL',
      duration:'1:55:00'
    },
    {
      departingFrom:'ORD',
      arrivingAt:'DEN',
      duration:'2:40:00'
    },
    {
      departingFrom:'ORD',
      arrivingAt:'DFW',
      duration:'2:25:00'
    },
    {
      departingFrom:'ORD',
      arrivingAt:'JFK',
      duration:'2:10:00'
    },
    {
      departingFrom:'ORD',
      arrivingAt:'LAS',
      duration:'3:55:00'
    },
    {
      departingFrom:'ORD',
      arrivingAt:'MCO',
      duration:'2:40:00'
    },
    {
      departingFrom:'ORD',
      arrivingAt:'SEA',
      duration:'4:35:00'
    },
    {
      departingFrom:'SEA',
      arrivingAt:'ATL',
      duration:'4:40:00'
    },
    {
      departingFrom:'SEA',
      arrivingAt:'DEN',
      duration:'2:40:00'
    },
    {
      departingFrom:'SEA',
      arrivingAt:'DFW',
      duration:'4:00:00'
    },
    {
      departingFrom:'SEA',
      arrivingAt:'JFK',
      duration:'5:15:00'
    },
    {
      departingFrom:'SEA',
      arrivingAt:'LAS',
      duration:'2:35:00'
    },
    {
      departingFrom:'SEA',
      arrivingAt:'MCO',
      duration:'5:30:00'
    },
    {
      departingFrom:'SEA',
      arrivingAt:'ORD',
      duration:'4:00:00'
    }
  ]";
        #endregion
    }
}
