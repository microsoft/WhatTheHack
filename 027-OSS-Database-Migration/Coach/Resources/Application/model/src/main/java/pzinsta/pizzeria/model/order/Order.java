package pzinsta.pizzeria.model.order;

import com.google.common.collect.Range;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;
import org.hibernate.validator.constraints.Length;
import pzinsta.pizzeria.model.Constants;
import pzinsta.pizzeria.model.delivery.Delivery;
import pzinsta.pizzeria.model.user.Customer;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

@Entity
@Table(name = "orders")
public class Order implements Serializable {
    @Id
    @GeneratedValue(generator = Constants.ID_GENERATOR)
	private Long id;
    
    @ManyToOne(optional = false, cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinColumn (name = "customer_id")
	private Customer customer;

    @OneToOne(mappedBy = "order", cascade = {CascadeType.MERGE, CascadeType.PERSIST})
    private Review review;

	@Fetch(value = FetchMode.SUBSELECT)
	@OneToMany(fetch = FetchType.EAGER, mappedBy = "order", cascade = CascadeType.ALL)
	private List<OrderItem> orderItems = new ArrayList<>();

    @OneToOne(mappedBy = "order", cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REFRESH})
	private Delivery delivery;

    @Length(max = 1000)
    private String comment;

    @Column(unique = true)
    private String trackingNumber;

    @Column(unique = true)
    private String paymentTransactionId;

	@Fetch(value = FetchMode.SUBSELECT)
    @OneToMany(fetch = FetchType.EAGER, cascade = CascadeType.ALL)
	private Collection<OrderEvent> orderEvents = new ArrayList<>();

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	public List<OrderItem> getOrderItems() {
		return orderItems;
	}

	public void setOrderItems(List<OrderItem> orderItems) {
		this.orderItems = orderItems;
	}

	public void addOrderItem(OrderItem orderItem) {
		orderItems.add(orderItem);
		orderItem.setOrder(this);
	}

	public void removeOrderItemById(int orderItemIndex) {
		Range<Integer> validIndexes = Range.closedOpen(0, orderItems.size());
		if (validIndexes.contains(orderItemIndex)) {
			orderItems.remove(orderItemIndex);
		}
	}

	public Optional<OrderItem> getOrderItemByIndex(int orderItemIndex) {
        return isIndexPresent(orderItemIndex) ? Optional.of(orderItems.get(orderItemIndex)) : Optional.empty();
	}

    private boolean isIndexPresent(int orderItemIndex) {
        return Range.closedOpen(0, orderItems.size()).contains(orderItemIndex);
    }

	public void removeAllOrderItems() {
		orderItems.clear();
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public Delivery getDelivery() {
		return delivery;
	}

	public void setDelivery(Delivery delivery) {
		this.delivery = delivery;
	}

	public String getTrackingNumber() {
		return trackingNumber;
	}

	public void setTrackingNumber(String trackingNumber) {
		this.trackingNumber = trackingNumber;
	}

	public Review getReview() {
		return review;
	}

	public void setReview(Review review) {
		this.review = review;
	}

    public String getPaymentTransactionId() {
        return paymentTransactionId;
    }

    public void setPaymentTransactionId(String paymentTransactionId) {
        this.paymentTransactionId = paymentTransactionId;
    }

	public Collection<OrderEvent> getOrderEvents() {
		return orderEvents;
	}

	public void setOrderEvents(Collection<OrderEvent> orderEvents) {
		this.orderEvents = orderEvents;
	}
}
