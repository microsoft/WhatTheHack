using System.Text.Json.Serialization;

namespace Verify_inator
{
    public class ResponseContent
    {
        public const string ApiVersion = "1.0.0";

        public ResponseContent()
        {
            this.version = ResponseContent.ApiVersion;
            this.action = "Continue";
        }

        public ResponseContent(string action, string displayName, string isValid, string isEmployee, int status, string msg)
        {
            this.version = ResponseContent.ApiVersion;
            this.action = action;
            this.displayName = displayName;
            this.isValid = isValid;
            this.isEmployee = isEmployee;
            this.status = status;
            this.userMessage = msg;
        }

        public string version { get; }
        public string action { get; set; }
        public string displayName { get; set; }
        [JsonPropertyName("extension_c25a588869c34cb48d8d87dbbce4816b_isValid")]
        public string isValid { get; set; }
        [JsonPropertyName("extension_c25a588869c34cb48d8d87dbbce4816b_isEmployee")]
        public string isEmployee { get; set; }
        public int status { get; set; }
        public string userMessage { get; set; }
    }    
}