using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contoso.Data.Entities
{
    [Table("PolicyHolders")]
    public class PolicyHolder
    {
        [Key]
        public int Id { get; set; }
        public int PersonId { get; set; }
        public virtual Person Person { get; set; }
        public bool Active { get; set; } = false;
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string Username { get; set; }
        public string PolicyNumber { get; set; }
        public int PolicyId { get; set; }
        public virtual Policy Policy { get; set; }
        public string FilePath { get; set; }
        public decimal PolicyAmount { get; set; }
        public decimal Deductible { get; set; }
        public decimal OutOfPocketMax { get; set; }
        public DateTime EffectiveDate { get; set; }
        public DateTime ExpirationDate { get; set; }
    }
}