using Microsoft.AspNetCore.Html;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Razor.TagHelpers;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.Encodings.Web;

namespace ContosoMasks.ServiceHost
{
    [HtmlTargetElement("*", Attributes = CDNLinkAttributeName, TagStructure = TagStructure.Unspecified)]
    public class CDNTagHelper : TagHelper
    {
        public const string CDNLinkAttributeName = "cdnify";
        private bool useCDN = false;

        public CDNTagHelper(IHttpContextAccessor contextFactory)
        {
            useCDN = contextFactory.HttpContext.Request.Query.ContainsKey("cdn");
        }

        public override void Process(TagHelperContext context, TagHelperOutput output)
        {
            TagHelperAttribute attr = null;
            string cdnEndpoint = SiteConfiguration.StaticAssetRoot;

            if (context.AllAttributes.TryGetAttribute(CDNLinkAttributeName, out attr) && bool.TrueString.EqualsOI(attr.Value?.ToString()))
            {
                UpdateCDNAttr(context, output, "src", cdnEndpoint);
                UpdateCDNAttr(context, output, "href", cdnEndpoint);
                base.Process(context, output);
            }
        }

        private void UpdateCDNAttr(TagHelperContext context, TagHelperOutput output, string tag, string cdnEndpoint)
        {
            string url = string.Empty;
            var foundOutputAttr = output.Attributes.SafeWhere(attr => attr.Name.EqualsOI(tag));
            if ( !foundOutputAttr.SafeAny() )
            {
                foundOutputAttr = context.AllAttributes.SafeWhere(attr => attr.Name.EqualsOI(tag)); 
            }

            if (foundOutputAttr.SafeAny())
            {
                var foundHREFsWithVersion = foundOutputAttr.SafeWhere(href => href.Value?.ToString().Contains("v=", StringComparison.OrdinalIgnoreCase) ?? false);

                if (foundHREFsWithVersion.SafeAny())
                {
                    url = getValue(foundHREFsWithVersion.First());
                }
                else
                {
                    url = getValue(foundOutputAttr.First());
                }
            }
            else
            {
                return;
            }

            var cdnifyAttr = output.Attributes.FirstOrDefault(attr => attr.Name.EqualsOI(CDNLinkAttributeName));

            if ( cdnifyAttr != null )
            {
                output.Attributes.Remove(cdnifyAttr);
            }

            foundOutputAttr.ToList().SafeForEach(attr => output.Attributes.Remove(attr));

            bool hasVersion = url.Contains("v=", StringComparison.OrdinalIgnoreCase);

            string formattedUrl;

            if (string.IsNullOrEmpty(cdnEndpoint) || !useCDN)
            {
                formattedUrl = url.TrimStart('~');
            }
            else
            {
                formattedUrl = $"{cdnEndpoint.TrimEnd('/')}/{url.TrimStart('~').TrimStart('/')}";
            }

            output.Attributes.Add(tag, $"{formattedUrl}{(!hasVersion && !string.IsNullOrEmpty(SiteConfiguration.CDNVersion) ? $"?v={SiteConfiguration.CDNVersion}" : "")}");
        }

        private static string getValue(TagHelperAttribute tagHelperAttribute)
        {
            object attributeValue = tagHelperAttribute.Value;
            var stringValue = attributeValue as string;
            if (stringValue != null)
            {
                var encodedStringValue = HtmlEncoder.Default.Encode(stringValue);
                return encodedStringValue;
            }
            else
            {
                var htmlContent = attributeValue as IHtmlContent;
                if (htmlContent != null)
                {
                    var htmlString = htmlContent as HtmlString;
                    if (htmlString != null)
                    {
                        // No need for a StringWriter in this case.
                        stringValue = htmlString.ToString();
                    }
                    else
                    {
                        using (var writer = new StringWriter())
                        {
                            htmlContent.WriteTo(writer, HtmlEncoder.Default);
                            stringValue = writer.ToString();
                        }
                    }

                    return stringValue;
                }
            }

            return attributeValue.ToString();
        }
    }
}

