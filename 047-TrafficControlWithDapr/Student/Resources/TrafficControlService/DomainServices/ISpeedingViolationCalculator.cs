using System;

namespace TrafficControlService.DomainServices
{
    public interface ISpeedingViolationCalculator
    {
        int DetermineSpeedingViolationInKmh(DateTime entryTimestamp, DateTime exitTimestamp);
        string GetRoadId();
    }
}