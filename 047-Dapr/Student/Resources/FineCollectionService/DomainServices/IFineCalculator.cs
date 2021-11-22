namespace FineCollectionService.DomainServices
{
    public interface IFineCalculator
    {
        public int CalculateFine(string licenseKey, int violationInKmh);
    }
}