package pzinsta.pizzeria.service.impl.strategy;

import pzinsta.pizzeria.model.order.Order;

public interface TrackingNumberGenerationStrategy {
    String generatetrackingNumber(Order order);
}
