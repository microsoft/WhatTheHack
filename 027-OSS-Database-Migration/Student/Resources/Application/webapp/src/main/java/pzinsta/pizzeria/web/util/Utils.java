package pzinsta.pizzeria.web.util;

import com.google.common.collect.Sets;
import pzinsta.pizzeria.model.pizza.Ingredient;
import pzinsta.pizzeria.model.pizza.IngredientType;
import pzinsta.pizzeria.service.dto.PizzaOrderDTO;
import pzinsta.pizzeria.web.form.PizzaBuilderForm;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static pzinsta.pizzeria.web.form.PizzaBuilderForm.IngredientSide.LEFT;
import static pzinsta.pizzeria.web.form.PizzaBuilderForm.IngredientSide.RIGHT;
import static pzinsta.pizzeria.web.form.PizzaBuilderForm.IngredientSide.WHOLE;

public class Utils {
    private static final int DOUBLE = 2;

    private Utils() {}

    public static PizzaOrderDTO createPizzaOrderDTO(PizzaBuilderForm pizzaBuilderForm) {
        PizzaOrderDTO pizzaOrderDTO = new PizzaOrderDTO();
        pizzaOrderDTO.setBakeStyleId(pizzaBuilderForm.getBakeStyleId());
        pizzaOrderDTO.setCrustId(pizzaBuilderForm.getCrustId());
        pizzaOrderDTO.setCutStyleId(pizzaBuilderForm.getCutStyleId());
        pizzaOrderDTO.setPizzaSizeId(pizzaBuilderForm.getPizzaSizeId());
        pizzaOrderDTO.setQuantity(pizzaBuilderForm.getQuantity());
        pizzaOrderDTO.setLeftSideIngredientIdByQuantity(getIngredientsByQuantity(pizzaBuilderForm, LEFT));
        pizzaOrderDTO.setRightSideIngredientIdByQuantity(getIngredientsByQuantity(pizzaBuilderForm, RIGHT));
        return pizzaOrderDTO;
    }

    public static PizzaBuilderForm createPizzaBuilderForm(PizzaOrderDTO pizzaOrderDTO, Collection<Ingredient> ingredients) {
        PizzaBuilderForm pizzaBuilderForm = new PizzaBuilderForm();

        pizzaBuilderForm.setBakeStyleId(pizzaOrderDTO.getBakeStyleId());
        pizzaBuilderForm.setCrustId(pizzaOrderDTO.getCrustId());
        pizzaBuilderForm.setCutStyleId(pizzaOrderDTO.getCutStyleId());
        pizzaBuilderForm.setPizzaSizeId(pizzaOrderDTO.getPizzaSizeId());
        pizzaBuilderForm.setQuantity(pizzaOrderDTO.getQuantity());
        pizzaBuilderForm.setIngredientGroups(getIngredientGroups(pizzaOrderDTO, ingredients));

        return pizzaBuilderForm;
    }

    private static List<PizzaBuilderForm.IngredientGroup> getIngredientGroups(PizzaOrderDTO pizzaOrderDTO, Collection<Ingredient> ingredients) {
        Set<Long> leftSideIngredientIds = pizzaOrderDTO.getLeftSideIngredientIdByQuantity().keySet();
        Set<Long> rightSideIngredientIds = pizzaOrderDTO.getRightSideIngredientIdByQuantity().keySet();
        Set<Long> wholeIngredientIds = Sets.intersection(leftSideIngredientIds, rightSideIngredientIds);

        Stream<Map.Entry<Long, Integer>> leftSideIngredientsByQuantityStream = pizzaOrderDTO.getLeftSideIngredientIdByQuantity().entrySet().stream();
        Stream<Map.Entry<Long, Integer>> rightSideIngredientByQuantityStream = pizzaOrderDTO.getRightSideIngredientIdByQuantity().entrySet().stream();
        Set<Long> ingredientIdsWithDoubleQuantity = Stream.concat(leftSideIngredientsByQuantityStream, rightSideIngredientByQuantityStream)
                .filter(entry -> entry.getValue() == DOUBLE).map(Map.Entry::getKey).collect(Collectors.toSet());

        List<PizzaBuilderForm.IngredientGroup> ingredientGroups = generateIngredientGroups(ingredients);

        ingredientGroups.stream().flatMap(ingredientGroup -> ingredientGroup.getIngredientQuantities().stream())
                .filter(ingredientQuantity -> leftSideIngredientIds.contains(ingredientQuantity.getIngredient().getId()))
                .forEach(ingredientQuantity -> ingredientQuantity.setIngredientSide(LEFT));

        ingredientGroups.stream().flatMap(ingredientGroup -> ingredientGroup.getIngredientQuantities().stream())
                .filter(ingredientQuantity -> rightSideIngredientIds.contains(ingredientQuantity.getIngredient().getId()))
                .forEach(ingredientQuantity -> ingredientQuantity.setIngredientSide(RIGHT));

        ingredientGroups.stream().flatMap(ingredientGroup -> ingredientGroup.getIngredientQuantities().stream())
                .filter(ingredientQuantity -> wholeIngredientIds.contains(ingredientQuantity.getIngredient().getId()))
                .forEach(ingredientQuantity -> ingredientQuantity.setIngredientSide(WHOLE));

        ingredientGroups.stream().flatMap(ingredientGroup -> ingredientGroup.getIngredientQuantities().stream())
                .filter(ingredientQuantity -> ingredientIdsWithDoubleQuantity.contains(ingredientQuantity.getIngredient().getId()))
                .forEach(ingredientQuantity -> ingredientQuantity.setX2(true));

        return ingredientGroups;
    }

    private static Map<Long, Integer> getIngredientsByQuantity(PizzaBuilderForm pizzaBuilderForm, PizzaBuilderForm.IngredientSide ingredientSide) {
        return pizzaBuilderForm.getIngredientGroups().stream().flatMap(ingredientGroup -> ingredientGroup.getIngredientQuantities().stream())
                .filter(ingredientQuantity -> belongsToIngredientSide(ingredientSide, ingredientQuantity)).collect(Collectors.toMap(o -> o.getIngredient().getId(), Utils::getQuantity));
    }

    private static int getQuantity(PizzaBuilderForm.IngredientQuantity ingredientQuantity) {
        return ingredientQuantity.isX2() ? 2 : 1;
    }

    private static boolean belongsToIngredientSide(PizzaBuilderForm.IngredientSide ingredientSide, PizzaBuilderForm.IngredientQuantity ingredientQuantity) {
        return ingredientQuantity.getIngredientSide() == ingredientSide || ingredientQuantity.getIngredientSide() == PizzaBuilderForm.IngredientSide.WHOLE;
    }

    public static List<PizzaBuilderForm.IngredientGroup> generateIngredientGroups(Collection<Ingredient> ingredients) {
        Stream<PizzaBuilderForm.IngredientQuantity> ingredientQuantityStream = ingredients.stream().map(Utils::createIngredientQuantity);
        Map<IngredientType, List<PizzaBuilderForm.IngredientQuantity>> ingredientQuantityByIngredientType = ingredientQuantityStream.collect(Collectors.groupingBy(ingredientQuantity -> ingredientQuantity.getIngredient().getIngredientType()));
        return ingredientQuantityByIngredientType.entrySet().stream().collect(ArrayList::new, (objects, ingredientTypeListEntry) -> {
            PizzaBuilderForm.IngredientGroup ingredientGroup = new PizzaBuilderForm.IngredientGroup();
            ingredientGroup.setIngredientType(ingredientTypeListEntry.getKey());
            ingredientGroup.setIngredientQuantities(ingredientTypeListEntry.getValue());
            objects.add(ingredientGroup);
        }, ArrayList::addAll);
    }

    private static PizzaBuilderForm.IngredientQuantity createIngredientQuantity(Ingredient ingredient) {
        PizzaBuilderForm.IngredientQuantity ingredientQuantity = new PizzaBuilderForm.IngredientQuantity();
        ingredientQuantity.setIngredient(ingredient);
        return ingredientQuantity;
    }

}
