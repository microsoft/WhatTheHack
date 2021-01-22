package pzinsta.pizzeria.dao;

import pzinsta.pizzeria.model.order.Order;

import java.util.Optional;

public interface OrderDAO extends GenericDAO<Order, Long> {
    Optional<Order> findByTrackingNumber(String trackingNumber);
}
