using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace ContosoMasks.ServiceHost.Models
{
    public class LoadTestRun
    {
        public LoadTestRun(string url, string id)
        {
            ID = id;
            Url = url;
            Regions = new Dictionary<string, IEnumerable<Stat>>();
            RegionRequests = new Dictionary<string, long>();
        }

        public void AddFile(string region, string file)
        {
            (var stats, var numberOfReqs) = Stat.ParseFile(file);

            IEnumerable<Stat> alreadyThere;

            if ( !Regions.TryGetValue(region, out alreadyThere))
            {
                Regions[region] = stats;
                RegionRequests[region] = numberOfReqs;
            }
            else
            {
                long regionRequests = RegionRequests[region];

                alreadyThere.SafeForEach(curStat =>
                {
                    var newStat = stats.SafeFirstOrDefault(s => s.Name.EqualsOI(curStat.Name));
                    if ( newStat != null )
                    {
                        curStat.Average = ((curStat.Average * regionRequests) + (newStat.Average * numberOfReqs)) / (regionRequests + numberOfReqs);
                        curStat.Minimum = ((curStat.Minimum * regionRequests) + (newStat.Minimum * numberOfReqs)) / (regionRequests + numberOfReqs);
                        curStat.Median = ((curStat.Median * regionRequests) + (newStat.Median * numberOfReqs)) / (regionRequests + numberOfReqs);
                        curStat.Maximum = ((curStat.Maximum * regionRequests) + (newStat.Maximum * numberOfReqs)) / (regionRequests + numberOfReqs);
                        curStat.Percentile90 = ((curStat.Percentile90 * regionRequests) + (newStat.Percentile90 * numberOfReqs)) / (regionRequests + numberOfReqs);
                        curStat.Percentile95 = ((curStat.Percentile95 * regionRequests) + (newStat.Percentile95 * numberOfReqs)) / (regionRequests + numberOfReqs);
                    }
                });

                RegionRequests[region] = regionRequests + numberOfReqs;
            }
        }

        public Dictionary<string, IEnumerable<Stat>> Regions { get; set; }
        public Dictionary<string, long> RegionRequests { get; set; }
        public string ID { get; set; }
        public string Url { get; set; }
    }

    public class Stat
    {
        static Regex LINE = new Regex(@"^\s+([^\s^\.]+)\.+:\s+avg=([\d\.]+\S+)\s+min=([\d\.]+\S+)\s+med=([\d\.]+\S+)\s+max=([\d\.]+\S+)\s+p\(90\)=([\d\.]+\S+)\s+p\(95\)=([\d\.]+\S+)\s*$", RegexOptions.Compiled | RegexOptions.IgnoreCase);
        static Regex REQSLINE = new Regex(@"^\s+http_reqs\.+:\s+([\d]+)\s+\S+\s*$", RegexOptions.Compiled | RegexOptions.IgnoreCase);
        static Regex NUMBER = new Regex(@"^([\d\.]+)([^\d^\.]+)$", RegexOptions.Compiled | RegexOptions.IgnoreCase); 
        static Regex MINNUMBER = new Regex(@"^([\d]+)m([\d]+)s$", RegexOptions.Compiled | RegexOptions.IgnoreCase); 

        public static (IEnumerable<Stat>, long)  ParseFile(string file)
        {
            var lines = file.Split('\n');
            var statLines = lines.Where(line => LINE.IsMatch(line)).ToList();
            var totalReq = lines.SafeFirstOrDefault(line => REQSLINE.IsMatch(line));
            long totalReqs = 0;

            if ( !string.IsNullOrEmpty(totalReq))
            {
                var matches = REQSLINE.Match(totalReq);
                totalReqs = long.Parse(matches.Groups[1].Value);
            }

            return (statLines.Select(line =>
            {
                var matches = LINE.Match(line);
                return new Stat()
                {
                    Name = matches.Groups[1].Value,
                    Average = toMicroSeconds(matches.Groups[2].Value),
                    Minimum = toMicroSeconds(matches.Groups[3].Value),
                    Median = toMicroSeconds(matches.Groups[4].Value),
                    Maximum = toMicroSeconds(matches.Groups[5].Value),
                    Percentile90 = toMicroSeconds(matches.Groups[6].Value),
                    Percentile95 = toMicroSeconds(matches.Groups[7].Value),
                };
            }).ToList(), totalReqs);
        }

        private static long toMicroSeconds(string val)
        {
            if ( string.IsNullOrEmpty(val))
            {
                return 0;
            }

            if ( MINNUMBER.IsMatch(val))
            {
                var minMatches = MINNUMBER.Match(val);
                return (long)((double.Parse(minMatches.Groups[1].Value) * 1000d * 1000d * 60d) + (double.Parse(minMatches.Groups[1].Value) * 1000d * 1000d));
            }

            var matches = NUMBER.Match(val);
            double number = double.Parse(matches.Groups[1].Value);
            switch (matches.Groups[2].Value)
            {
                case "ms":
                    return (long)(number * 1000d);
                case "s":
                    return (long)(number * 1000d * 1000d);
                case "m":
                    return (long)(number * 1000d * 1000d * 60d);
            }

            return (long)number;
        }

        public string Name { get; set; }
        public long Average { get; set; }
        public long Minimum { get; set; }
        public long Median { get; set; }
        public long Maximum { get; set; }
        public long Percentile90 { get; set; }
        public long Percentile95 { get; set; }

    }
}
