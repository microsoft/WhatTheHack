package pzinsta.pizzeria.model.pizza;

import org.hibernate.annotations.ColumnDefault;
import pzinsta.pizzeria.model.Constants;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.validation.constraints.Size;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Objects;

@Entity
public class PizzaSide implements Serializable {
    @Id
    @GeneratedValue(generator = Constants.ID_GENERATOR)
	private Long id;
    
    @Size(max = 100)
    @ColumnDefault("'Custom'")
	private String name;
    
    @OneToMany(fetch = FetchType.EAGER, cascade = CascadeType.ALL)
	private Collection<PizzaItem> pizzaItems = new ArrayList<>();

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Collection<PizzaItem> getPizzaItems() {
		return pizzaItems;
	}

	public void setPizzaItems(Collection<PizzaItem> items) {
		this.pizzaItems = items;
	}
	
	@Override
	public boolean equals(Object o) {
		if (!(o instanceof PizzaSide)) return false;
		PizzaSide pizzaSide = (PizzaSide) o;
		return Objects.equals(getPizzaItems(), pizzaSide.getPizzaItems());
	}

	@Override
	public int hashCode() {
		return Objects.hash(getPizzaItems());
	}
}
