package pzinsta.pizzeria.service;

import pzinsta.pizzeria.model.order.Order;

import javax.money.MonetaryAmount;

public interface OrderCostCalculationService {

    MonetaryAmount calculateCost(Order order);
}
