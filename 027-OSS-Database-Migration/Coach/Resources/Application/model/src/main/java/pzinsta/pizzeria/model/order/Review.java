package pzinsta.pizzeria.model.order;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;
import org.hibernate.annotations.UpdateTimestamp;
import pzinsta.pizzeria.model.Constants;
import pzinsta.pizzeria.model.File;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinTable;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.io.Serializable;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Collection;

@Entity
public class Review implements Serializable {
    @Id
    @GeneratedValue(generator = Constants.ID_GENERATOR)
	private Long id;
    
    @OneToOne(optional = false)
	private Order order;
    
    @CreationTimestamp
	private Instant createdOn;

    @UpdateTimestamp
    private Instant lastUpdatedOn;
	
    @Size(max = 1000)
    @NotNull
	private String message;

    @Min(1)
    @Max(10)
	private int rating;

    @OneToMany(fetch = FetchType.EAGER)
	@Fetch(FetchMode.SUBSELECT)
	@JoinTable(name = "REVIEW_IMAGE")
	private Collection<File> images = new ArrayList<>();
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Order getOrder() {
		return order;
	}

	public void setOrder(Order order) {
		this.order = order;
	}

	public Instant getCreatedOn() {
		return createdOn;
	}

	public void setCreatedOn(Instant createdOn) {
		this.createdOn = createdOn;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public int getRating() {
		return rating;
	}

	public void setRating(int rating) {
		this.rating = rating;
	}

	public Instant getLastUpdatedOn() {
		return lastUpdatedOn;
	}

	public void setLastUpdatedOn(Instant lastUpdatedOn) {
		this.lastUpdatedOn = lastUpdatedOn;
	}

	public Collection<File> getImages() {
		return images;
	}

	public void setImages(Collection<File> images) {
		this.images = images;
	}
}
