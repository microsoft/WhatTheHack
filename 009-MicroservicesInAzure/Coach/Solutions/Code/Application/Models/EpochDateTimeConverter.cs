using Newtonsoft.Json;
using System;

namespace ContosoTravel.Web.Application.Models
{
    // from: https://azure.microsoft.com/en-us/blog/working-with-dates-in-azure-documentdb-4/
    public class EpochDateTimeConverter : JsonConverter
    {
        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            int seconds;
            if (value is DateTimeOffset)
            {
                DateTimeOffset dt = (DateTimeOffset)value;
                if (!dt.Equals(DateTimeOffset.MinValue))
                    seconds = dt.ToEpoch();
                else
                    seconds = int.MinValue;
            }
            else
            {
                throw new Exception("Expected date object value.");
            }

            writer.WriteValue(seconds);
        }

        public override object ReadJson(JsonReader reader, Type type, object value, JsonSerializer serializer)
        {
            if (reader.TokenType == JsonToken.None || reader.TokenType == JsonToken.Null)
                return null;

            if (reader.TokenType != JsonToken.Integer)
            {
                throw new Exception(
                    String.Format("Unexpected token parsing date. Expected Integer, got {0}.",
                    reader.TokenType));
            }

            int seconds = (int)reader.Value;
            return new DateTimeOffset(new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc).AddSeconds(seconds));
        }

        public override bool CanConvert(Type objectType)
        {
            return objectType.Equals(typeof(DateTimeOffset));
        }
    }
}