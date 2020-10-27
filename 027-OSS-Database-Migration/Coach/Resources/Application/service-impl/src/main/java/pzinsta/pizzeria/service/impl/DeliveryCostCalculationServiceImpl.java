package pzinsta.pizzeria.service.impl;

import org.javamoney.moneta.Money;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import pzinsta.pizzeria.model.delivery.Delivery;
import pzinsta.pizzeria.service.DeliveryCostCalculationService;
import pzinsta.pizzeria.service.impl.strategy.DeliveryCostCalculationStrategy;

import javax.money.MonetaryAmount;
import java.util.Optional;

@Service("deliveryCostCalculationService")
public class DeliveryCostCalculationServiceImpl implements DeliveryCostCalculationService {

    private DeliveryCostCalculationStrategy deliveryCostCalculationStrategy;

    @Autowired
    public DeliveryCostCalculationServiceImpl(DeliveryCostCalculationStrategy deliveryCostCalculationStrategy) {
        this.deliveryCostCalculationStrategy = deliveryCostCalculationStrategy;
    }

    @Override
    public MonetaryAmount calculateCost(Delivery delivery) {
        return Optional.ofNullable(delivery).map(deliveryCostCalculationStrategy::calculateCost)
                .orElse(Money.of(0, "USD"));
    }
}
