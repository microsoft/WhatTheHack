using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contoso.Data.Entities
{
    [Table("Dependents")]
    public class Dependent
    {
        [Key]
        public int Id { get; set; }
        public int PersonId { get; set; }
        public virtual Person Person { get; set; }
        public int PolicyHolderId { get; set; }
        public virtual PolicyHolder PolicyHolder { get; set; }
        public bool Active { get; set; } = false;
    }
}