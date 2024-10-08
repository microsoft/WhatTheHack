namespace BuildYourOwnCopilot.Common.Models.BusinessDomain
{
    public class Customer : EmbeddedEntity
    {
        [EmbeddingField(Label = "Customer type")]
        public string type { get; set; }

        public string customerId { get; set; }

        [EmbeddingField(Label = "Customer title")]
        public string title { get; set; }

        [EmbeddingField(Label = "Customer first name")]
        public string firstName { get; set; }

        [EmbeddingField(Label = "Customer last name")]
        public string lastName { get; set; }

        [EmbeddingField(Label = "Customer email address")]
        public string emailAddress { get; set; }

        [EmbeddingField(Label = "Customer phone number")]
        public string phoneNumber { get; set; }

        public string creationDate { get; set; }

        [EmbeddingField(Label = "Customer addresses")]
        public List<CustomerAddress> addresses { get; set; }

        public Password password { get; set; }

        public double salesOrderCount { get; set; }

        public Customer(string id, string type, string customerId, string title,
            string firstName, string lastName, string emailAddress, string phoneNumber,
            string creationDate, List<CustomerAddress> addresses, Password password,
            double salesOrderCount)
        {
            this.id = id;
            this.type = type;
            this.customerId = customerId;
            this.title = title;
            this.firstName = firstName;
            this.lastName = lastName;
            this.emailAddress = emailAddress;
            this.phoneNumber = phoneNumber;
            this.creationDate = creationDate;
            this.addresses = addresses;
            this.password = password;
            this.salesOrderCount = salesOrderCount;
        }
    }

    public class Password
    {
        public string hash { get; set; }

        public string salt { get; set; }

        public Password(string hash, string salt)
        {
            this.hash = hash;
            this.salt = salt;
        }
    }

    public class CustomerAddress
    {
        [EmbeddingField(Label = "Customer address line 1")]
        public string addressLine1 { get; set; }

        [EmbeddingField(Label = "Customer address line 2")]
        public string addressLine2 { get; set; }

        [EmbeddingField(Label = "Customer address city")]
        public string city { get; set; }

        [EmbeddingField(Label = "Customer address state")]
        public string state { get; set; }

        [EmbeddingField(Label = "Customer address country")]
        public string country { get; set; }

        [EmbeddingField(Label = "Customer address zip code")]
        public string zipCode { get; set; }

        public Location location { get; set; }

        public CustomerAddress(string addressLine1, string addressLine2, string city, string state, string country, string zipCode, Location location)
        {
            this.addressLine1 = addressLine1;
            this.addressLine2 = addressLine2;
            this.city = city;
            this.state = state;
            this.country = country;
            this.zipCode = zipCode;
            this.location = location;
        }
    }

    public class Location
    {
        public string type { get; set; }

        public List<float> coordinates { get; set; }

        public Location(string type, List<float> coordinates)
        {
            this.type = type;
            this.coordinates = coordinates;
        }
    }
}
