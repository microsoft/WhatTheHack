using Microsoft.Bot.Schema;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PictureBot.Models
{
    public class SearchHitStyler
    {
        public void Apply<T>(ref IMessageActivity activity, string prompt, IReadOnlyList<T> options, IReadOnlyList<string> descriptions = null)
        {
            var hits = options as IList<SearchHit>;
            if (hits != null)
            {
                var cards = hits.Select(h => new HeroCard
                {
                    Title = h.Title,
                    Images = new[] { new CardImage(h.PictureUrl) },
                    Text = h.Description
                });

                activity.AttachmentLayout = AttachmentLayoutTypes.Carousel;
                activity.Attachments = cards.Select(c => c.ToAttachment()).ToList();
                activity.Text = prompt;
            }
        }
    }
}
