using System.ComponentModel.DataAnnotations;

namespace InventoryService.Api.Models
{
    public class Payroll
    {
        [Key]
        public string EmployeeName { get; set; }
        public string Title { get; set; }
        public int Salary { get; set; }
    }
}