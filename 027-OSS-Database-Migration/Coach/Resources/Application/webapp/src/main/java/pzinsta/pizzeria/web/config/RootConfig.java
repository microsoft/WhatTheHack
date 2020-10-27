package pzinsta.pizzeria.web.config;

import com.braintreegateway.BraintreeGateway;
import com.braintreegateway.Environment;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.annotation.Scope;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import pzinsta.pizzeria.model.order.Cart;
import pzinsta.pizzeria.service.impl.strategy.DeliveryCostCalculationStrategy;
import pzinsta.pizzeria.service.impl.strategy.TrackingNumberGenerationStrategy;
import pzinsta.pizzeria.service.impl.strategy.impl.FixedDeliveryCostCalculationStrategy;
import pzinsta.pizzeria.service.impl.strategy.impl.RandomTrackingNumberGenerationStrategy;

import javax.money.Monetary;
import javax.money.MonetaryAmount;
import java.math.BigDecimal;

import static org.springframework.context.annotation.ScopedProxyMode.TARGET_CLASS;
import static org.springframework.web.context.WebApplicationContext.SCOPE_SESSION;

@Configuration
@Import({DataConfig.class, SecurityConfig.class})
@ComponentScan("pzinsta.pizzeria.service")
@PropertySource("classpath:application.properties")
public class RootConfig {

    @Bean
    public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
        return new PropertySourcesPlaceholderConfigurer();
    }

    @Bean
    @Scope(value = SCOPE_SESSION, proxyMode = TARGET_CLASS)
    public Cart cart() {
        return new Cart();
    }

    @Bean
    public TrackingNumberGenerationStrategy trackingNumberGenerationStrategy() {
        return new RandomTrackingNumberGenerationStrategy();
    }

    @Bean
    public BraintreeGateway braintreeGateway(@Value("${braintree.merchantId}") String merchantId,
                                             @Value("${braintree.publicKey}") String publicKey,
                                             @Value("${braintree.privateKey}") String privateKey) {

        return new BraintreeGateway(Environment.SANDBOX, merchantId, publicKey, privateKey);
    }

    @Bean
    public DeliveryCostCalculationStrategy deliveryCostCalculationStrategy(@Value("${delivery.cost}") BigDecimal deliveryCost) {
        FixedDeliveryCostCalculationStrategy fixedDeliveryCostCalculationStrategy = new FixedDeliveryCostCalculationStrategy();
        MonetaryAmount deliveryCostMonetaryAmount = Monetary.getDefaultAmountFactory().setCurrency("USD").setNumber(deliveryCost).create();
        fixedDeliveryCostCalculationStrategy.setCost(deliveryCostMonetaryAmount);
        return fixedDeliveryCostCalculationStrategy;
    }


}
