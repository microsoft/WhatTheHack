namespace RockPaperScissorsBoom.Server.Helpers
{
    public interface IMessagingHelper
    {
        Task PublishMessageAsync(string messageType, string subject, DateTime dateTime, object data);
    }
}