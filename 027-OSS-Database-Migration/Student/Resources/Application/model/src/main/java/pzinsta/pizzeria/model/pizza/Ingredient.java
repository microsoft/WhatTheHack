package pzinsta.pizzeria.model.pizza;

import pzinsta.pizzeria.model.Constants;
import pzinsta.pizzeria.model.MonetaryAmountAttributeConverter;

import javax.money.MonetaryAmount;
import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.io.Serializable;
import java.util.Objects;

@Entity
public class Ingredient  implements Serializable {
    @Id
    @GeneratedValue(generator = Constants.ID_GENERATOR)
	@NotNull
	private Long id;
    
    @NotNull
    @Size(max = 100)
    @Column(unique = true)
	private String name;
    
	@Convert(converter = MonetaryAmountAttributeConverter.class)
	private MonetaryAmount price;
	
	@NotNull
	@ManyToOne
	private IngredientType ingredientType;

	private String imageFileName;

	public long getId() {
		return id;
	}

	public void setId(long id) {
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

	public IngredientType getIngredientType() {
		return ingredientType;
	}

	public void setIngredientType(IngredientType type) {
		this.ingredientType = type;
	}
	
	@Override
	public boolean equals(Object obj) {
		if (!(obj instanceof Ingredient)) {
			return false;
		}
		Ingredient that = (Ingredient) obj;
		return this.getId() == that.getId();
	}
	
	@Override
	public int hashCode() {
		return Objects.hash(id);
	}

	public String getImageFileName() {
		return imageFileName;
	}

	public void setImageFileName(String imageFileName) {
		this.imageFileName = imageFileName;
	}
}
