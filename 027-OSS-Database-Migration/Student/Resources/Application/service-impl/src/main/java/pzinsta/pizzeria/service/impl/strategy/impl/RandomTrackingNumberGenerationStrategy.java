package pzinsta.pizzeria.service.impl.strategy.impl;

import org.apache.commons.rng.UniformRandomProvider;
import org.apache.commons.rng.simple.RandomSource;
import org.apache.commons.text.RandomStringGenerator;
import org.springframework.beans.factory.annotation.Value;
import pzinsta.pizzeria.model.order.Order;
import pzinsta.pizzeria.service.impl.strategy.TrackingNumberGenerationStrategy;

public class RandomTrackingNumberGenerationStrategy implements TrackingNumberGenerationStrategy {

    @Value("${trackingNumber.characters}")
    private String trackingNumberCharacters;

    @Value("${trackingNumber.length}")
    private int trackingNumberLength;

    @Override
    public String generatetrackingNumber(Order order) {
        UniformRandomProvider rng = RandomSource.create(RandomSource.SPLIT_MIX_64, order.getId());
        RandomStringGenerator randomStringGenerator = new RandomStringGenerator.Builder().usingRandom(rng::nextInt)
                .selectFrom(trackingNumberCharacters.toCharArray()).build();
        return randomStringGenerator.generate(trackingNumberLength);
    }

    public String getTrackingNumberCharacters() {
        return trackingNumberCharacters;
    }

    public void setTrackingNumberCharacters(String trackingNumberCharacters) {
        this.trackingNumberCharacters = trackingNumberCharacters;
    }

    public int getTrackingNumberLength() {
        return trackingNumberLength;
    }

    public void setTrackingNumberLength(int trackingNumberLength) {
        this.trackingNumberLength = trackingNumberLength;
    }
}
