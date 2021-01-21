package pzinsta.pizzeria.model.pizza;

import pzinsta.pizzeria.model.Constants;

import javax.money.MonetaryAmount;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Objects;

@Entity
public class PizzaItem implements Serializable {

    @Id
    @GeneratedValue(generator = Constants.ID_GENERATOR)
    private Long id;

    @Min(1)
    @NotNull
    private int quantity;

    @ManyToOne
    private Ingredient ingredient;

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof PizzaItem)) {
            return false;
        }
        PizzaItem that = (PizzaItem) obj;
        return Objects.equals(this.getIngredient(), that.getIngredient()) && (this.getQuantity() == that.getQuantity());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getIngredient(), getQuantity());
    }

    public MonetaryAmount getCost() {
        return getIngredient().getPrice().multiply(quantity);
    }

    public Ingredient getIngredient() {
        return ingredient;
    }

    public void setIngredient(Ingredient ingredient) {
        this.ingredient = ingredient;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
}
