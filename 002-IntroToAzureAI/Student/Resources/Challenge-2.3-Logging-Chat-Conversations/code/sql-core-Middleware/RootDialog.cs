namespace MiddlewareBot
{
    using System;
    using System.Threading.Tasks;
    using Microsoft.Bot.Builder.Dialogs;
    using Microsoft.Bot.Connector;
    
    #pragma warning disable 1998

    [Serializable]
    public class RootDialog : IDialog<object>
    {
        public async Task StartAsync(IDialogContext context)
        {
            context.Wait(this.MessageReceivedAsync);
        }

        private async Task MessageReceivedAsync(IDialogContext context, IAwaitable<IMessageActivity> result)
        {
            var message = await result;

            /*
            if (message.Text.Contains("Exit"))
            {

                //System.Environment.Exit(0);
                context.EndConversation("End of Conversation");
               
                
            }*/

            await context.PostAsync($"You sent {message.Text} which was {message.Text.Length} characters");

            context.Wait(this.MessageReceivedAsync);
        }
    }
}
