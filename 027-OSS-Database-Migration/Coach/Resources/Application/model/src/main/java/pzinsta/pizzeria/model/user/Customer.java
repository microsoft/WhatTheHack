package pzinsta.pizzeria.model.user;

import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;
import pzinsta.pizzeria.model.order.Order;

import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.OneToMany;
import javax.persistence.PrimaryKeyJoinColumn;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Entity
@PrimaryKeyJoinColumn(name = "user_id")
public class Customer extends User implements Serializable {
    @OneToMany(mappedBy = "customer", fetch = FetchType.EAGER)
    private Collection<Order> orders = new ArrayList<>();

    @ElementCollection(fetch = FetchType.EAGER)
    @Fetch(FetchMode.SELECT)
    private List<DeliveryAddress> deliveryAddresses = new ArrayList<>();

    public Collection<Order> getOrders() {
        return orders;
    }

    public void setOrders(Collection<Order> orders) {
        this.orders = orders;
    }

    public List<DeliveryAddress> getDeliveryAddresses() {
        return deliveryAddresses;
    }

    public void setDeliveryAddresses(List<DeliveryAddress> deliveryAddresses) {
        this.deliveryAddresses = deliveryAddresses;
    }
}
