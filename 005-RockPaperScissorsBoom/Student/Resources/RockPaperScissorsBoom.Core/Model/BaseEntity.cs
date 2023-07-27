namespace RockPaperScissorsBoom.Core.Model
{
    public abstract class BaseEntity : IEquatable<BaseEntity>
    {
        public bool Equals(BaseEntity? other)
        {
            if (other is null) return false;
            return ReferenceEquals(this, other) || Id.Equals(other.Id);
        }

        public override bool Equals(object? obj)
        {
            if (obj is null) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;
            return Equals((BaseEntity)obj);
        }

        public override int GetHashCode()
        {
            return Id.GetHashCode();
        }

        public Guid Id { get; set; } = Guid.NewGuid();
    }
}