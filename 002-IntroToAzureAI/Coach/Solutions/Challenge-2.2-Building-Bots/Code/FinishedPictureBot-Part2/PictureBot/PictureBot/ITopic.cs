using System.Threading.Tasks;
using Microsoft.Bot.Builder;

namespace PictureBot
{
    public interface ITopic
    {
        /// <summary>
        /// Name of the topic
        /// </summary>
        string Name { get; set; }

        /// <summary>
        /// Called when topic starts
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        Task<bool> StartTopic(ITurnContext context);

        /// <summary>
        /// Called while topic active
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        Task<bool> ContinueTopic(ITurnContext context);

        /// <summary>
        ///  Called when a topic is resumed
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        Task<bool> ResumeTopic(ITurnContext context);
    }
}