package pzinsta.pizzeria.model.pizza;

import pzinsta.pizzeria.model.Constants;
import pzinsta.pizzeria.model.MonetaryAmountAttributeConverter;

import javax.money.MonetaryAmount;
import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Positive;
import javax.validation.constraints.Size;
import java.io.Serializable;
import java.util.Objects;

@Entity
public class PizzaSize  implements Serializable {
    @Id
    @GeneratedValue(generator = Constants.ID_GENERATOR)
	private Long id;
    
    @NotNull
    @Size(max = 100)
	private String name;

    @Positive
	@Column(name = "DIAMETER")
    private int diameterInInches;

	@NotNull
	@Convert(converter = MonetaryAmountAttributeConverter.class)
	private MonetaryAmount price;

    @Positive
    @Column(nullable = false)
	private double ingredientCostFactor;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public MonetaryAmount getPrice() {
		return price;
	}

	public void setPrice(MonetaryAmount price) {
		this.price = price;
	}

	public int getDiameterInInches() {
		return diameterInInches;
	}

	public void setDiameterInInches(int diameterInInches) {
		this.diameterInInches = diameterInInches;
	}

	@Override
	public boolean equals(Object o) {
		if (!(o instanceof PizzaSize)) return false;
		PizzaSize pizzaSize = (PizzaSize) o;
		return Objects.equals(getName(), pizzaSize.getName()) &&
				Objects.equals(getPrice(), pizzaSize.getPrice());
	}

	@Override
	public int hashCode() {
		return Objects.hash(getName(), getPrice());
	}

	public double getIngredientCostFactor() {
		return ingredientCostFactor;
	}

	public void setIngredientCostFactor(double ingredientCostFactor) {
		this.ingredientCostFactor = ingredientCostFactor;
	}
}
