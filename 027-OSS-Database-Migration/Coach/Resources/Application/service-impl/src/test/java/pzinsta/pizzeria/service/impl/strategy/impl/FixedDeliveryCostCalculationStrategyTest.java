package pzinsta.pizzeria.service.impl.strategy.impl;

import org.junit.Test;

import javax.money.Monetary;
import javax.money.MonetaryAmount;

import static org.assertj.core.api.Assertions.assertThat;

public class FixedDeliveryCostCalculationStrategyTest {

    @Test
    public void shouldCalculateDeliveryCost() throws Exception {
        // given
        double amount = 4.73;
        String currency = "USD";
        MonetaryAmount cost = Monetary.getDefaultAmountFactory().setNumber(amount).setCurrency(currency).create();

        FixedDeliveryCostCalculationStrategy fixedDeliveryCostCalculationStrategy = new FixedDeliveryCostCalculationStrategy();
        fixedDeliveryCostCalculationStrategy.setCost(cost);

        // when
        MonetaryAmount result = fixedDeliveryCostCalculationStrategy.getCost();

        // then
        assertThat(result).isEqualTo(cost);
    }
}