package pzinsta.pizzeria.service.impl.strategy;

import pzinsta.pizzeria.model.delivery.Delivery;

import javax.money.MonetaryAmount;

public interface DeliveryCostCalculationStrategy {

    MonetaryAmount calculateCost(Delivery delivery);

}
