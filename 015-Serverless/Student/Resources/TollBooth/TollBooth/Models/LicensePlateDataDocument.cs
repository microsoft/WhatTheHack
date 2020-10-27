using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Azure.Documents;

namespace TollBooth.Models
{
    /// <summary>
    /// LicensePlateDataDocument extends the Microsoft.Azure.Documents.Resource class,
    /// providing us access to internal properties of a Resource such as ETag, SelfLink, Id etc.
    /// When working with objects extending from Resource you get the benefit of not having to 
    /// dynamically cast between Document and your POCO.
    /// </summary>
    public class LicensePlateDataDocument : Resource
    {
        public string fileName { get; set; }
        public string licensePlateText { get; set; }
        public DateTime timeStamp { get; set; }
        public bool licensePlateFound { get; set; }
        public bool exported { get; set; }
    }
}
