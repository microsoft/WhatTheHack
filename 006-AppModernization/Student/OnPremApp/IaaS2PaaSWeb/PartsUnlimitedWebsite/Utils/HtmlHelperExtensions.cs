using System;
using System.Web;
using System.Web.Mvc;

namespace PartsUnlimited.Utils
{
    public static class HtmlHelperExtensions
    {
        public static HtmlString Image(this HtmlHelper helper, string src, string alt = null)
        {
            if (string.IsNullOrWhiteSpace(src))
            {
                throw new ArgumentOutOfRangeException("src", src, "Must not be null or whitespace");
            }

            var img = new TagBuilder("img");

            img.MergeAttribute("src", GetCdnSource(src));

            if (!string.IsNullOrWhiteSpace(alt))
            {
                img.MergeAttribute("alt", alt);
            }

            return new HtmlString(img.ToString(TagRenderMode.SelfClosing));
        }

        private static string GetCdnSource(string src)
        {
            return string.Format("{0}/{1}", ConfigurationHelpers.GetString("ImagePath"), src);
        }
    }
}