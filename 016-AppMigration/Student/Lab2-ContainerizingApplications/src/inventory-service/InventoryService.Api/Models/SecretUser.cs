using System.ComponentModel.DataAnnotations;

namespace InventoryService.Api.Models
{
    public class SecretUser
    {
        [Key]
        public string Username { get; set; }
        public string Password { get; set; }
    }
}