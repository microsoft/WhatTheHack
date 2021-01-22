package pzinsta.pizzeria.service.impl.strategy.impl;

import pzinsta.pizzeria.model.delivery.Delivery;
import pzinsta.pizzeria.service.impl.strategy.DeliveryCostCalculationStrategy;

import javax.money.MonetaryAmount;

public class FixedDeliveryCostCalculationStrategy implements DeliveryCostCalculationStrategy {

    private MonetaryAmount cost;

    @Override
    public MonetaryAmount calculateCost(Delivery delivery) {
        return cost;
    }

    public MonetaryAmount getCost() {
        return cost;
    }

    public void setCost(MonetaryAmount cost) {
        this.cost = cost;
    }
}
