using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contoso.Data.Entities
{
    [Table("Policies")]
    public class Policy
    {
        [Key]
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public decimal DefaultDeductible { get; set; }
        public decimal DefaultOutOfPocketMax { get; set; }
    }
}