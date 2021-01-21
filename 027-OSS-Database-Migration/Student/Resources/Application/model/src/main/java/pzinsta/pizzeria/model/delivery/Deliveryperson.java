package pzinsta.pizzeria.model.delivery;

import pzinsta.pizzeria.model.user.User;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.OneToMany;
import javax.persistence.PrimaryKeyJoinColumn;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;

@Entity
@PrimaryKeyJoinColumn(name = "user_id")
public class Deliveryperson extends User implements Serializable {

    @OneToMany(mappedBy = "deliveryperson", fetch = FetchType.LAZY)
	private Collection<Delivery> deliveries = new ArrayList<>();
    
	private double latitude;
	private double longitude;

	public Collection<Delivery> getDeliveries() {
		return deliveries;
	}

	public void setDeliveries(Collection<Delivery> deliveries) {
		this.deliveries = deliveries;
	}

	public double getLatitude() {
		return latitude;
	}

	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}

	public double getLongitude() {
		return longitude;
	}

	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}
}
