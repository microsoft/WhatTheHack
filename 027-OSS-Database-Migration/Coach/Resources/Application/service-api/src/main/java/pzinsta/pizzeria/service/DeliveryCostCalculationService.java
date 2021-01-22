package pzinsta.pizzeria.service;

import pzinsta.pizzeria.model.delivery.Delivery;

import javax.money.MonetaryAmount;

public interface DeliveryCostCalculationService {

    MonetaryAmount calculateCost(Delivery delivery);
}
