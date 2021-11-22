using System;

namespace TrafficControlService.DomainServices
{
    public class DefaultSpeedingViolationCalculator : ISpeedingViolationCalculator
    {
        private readonly string _roadId;
        private readonly int _sectionLengthInKm;
        private readonly int _maxAllowedSpeedInKmh;
        private readonly int _legalCorrectionInKmh;

        public DefaultSpeedingViolationCalculator(string roadId, int sectionLengthInKm, int maxAllowedSpeedInKmh, int legalCorrectionInKmh)
        {
            _roadId = roadId;
            _sectionLengthInKm = sectionLengthInKm;
            _maxAllowedSpeedInKmh = maxAllowedSpeedInKmh;
            _legalCorrectionInKmh = legalCorrectionInKmh;
        }

        public int DetermineSpeedingViolationInKmh(DateTime entryTimestamp, DateTime exitTimestamp)
        {
            double elapsedMinutes = exitTimestamp.Subtract(entryTimestamp).TotalSeconds; // 1 sec. == 1 min. in simulation
            double avgSpeedInKmh = Math.Round((_sectionLengthInKm / elapsedMinutes) * 60);
            int violation = Convert.ToInt32(avgSpeedInKmh - _maxAllowedSpeedInKmh - _legalCorrectionInKmh);
            return violation;
        }

        public string GetRoadId()
        {
            return _roadId;
        }
    }
}