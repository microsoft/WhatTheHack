package pzinsta.pizzeria.model.pizza;

import pzinsta.pizzeria.model.Constants;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.io.Serializable;
import java.util.Objects;

@Entity
public class BakeStyle implements Serializable {
    @Id
    @GeneratedValue(generator = Constants.ID_GENERATOR)
	private Long id;
    
    @Size(max = 100)
    @NotNull
    @Column(unique = true)
	private String name;

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

	@Override
	public boolean equals(Object o) {
		if (!(o instanceof BakeStyle)) return false;
		BakeStyle bakeStyle = (BakeStyle) o;
		return Objects.equals(getName(), bakeStyle.getName());
	}

	@Override
	public int hashCode() {
		return Objects.hash(getName());
	}
}
