package pzinsta.pizzeria.web.validator;

import com.google.common.collect.Range;
import org.apache.commons.lang3.ArrayUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import pzinsta.pizzeria.model.pizza.BakeStyle;
import pzinsta.pizzeria.model.pizza.Crust;
import pzinsta.pizzeria.model.pizza.CutStyle;
import pzinsta.pizzeria.model.pizza.Ingredient;
import pzinsta.pizzeria.model.pizza.PizzaSize;
import pzinsta.pizzeria.service.OrderService;
import pzinsta.pizzeria.web.form.PizzaBuilderForm;
import pzinsta.pizzeria.web.form.PizzaBuilderForm.IngredientQuantity;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Component
public class PizzaBuilderFormValidator implements Validator {

    private OrderService orderService;

    @Value("${pizza.ingredients.quantity.min}")
    private int selectedIngredientsQuantityMin;

    @Value("${pizza.ingredients.quantity.max}")
    private int selectedIngredientsQuantityMax;

    @Value("${pizza.quantity.min}")
    private int pizzaQuantityMin;

    @Value("${pizza.quantity.max}")
    private int pizzaQuantityMax;

    @Override
    public boolean supports(Class<?> clazz) {
        return PizzaBuilderForm.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        PizzaBuilderForm pizzaBuilderForm = (PizzaBuilderForm) target;

        validateCrustId(pizzaBuilderForm, errors);

        validateBakeStyleId(pizzaBuilderForm, errors);

        validateCutStyleId(pizzaBuilderForm, errors);

        validatePizzaSizeId(pizzaBuilderForm, errors);

        validateQuantity(pizzaBuilderForm, errors);

        validateIngredients(pizzaBuilderForm, errors);
    }

    private void validateCrustId(PizzaBuilderForm pizzaBuilderForm, Errors errors) {
        boolean validCrustId = orderService.getCrusts().stream().map(Crust::getId).anyMatch(pizzaBuilderForm.getCrustId()::equals);
        if (!validCrustId) {
            errors.rejectValue("crustId", "crustId.invalid", ArrayUtils.toArray(pizzaBuilderForm.getCrustId()), "crustId.invalid");
        }
    }

    private void validateBakeStyleId(PizzaBuilderForm pizzaBuilderForm, Errors errors) {
        boolean validBakeStyleId = orderService.getBakeStyles().stream().map(BakeStyle::getId).anyMatch(pizzaBuilderForm.getBakeStyleId()::equals);
        if (!validBakeStyleId) {
            errors.rejectValue("bakeStyleId", "bakeStyleId.invalid", ArrayUtils.toArray(pizzaBuilderForm.getBakeStyleId()), "bakeStyleId.invalid");
        }
    }

    private void validateCutStyleId(PizzaBuilderForm pizzaBuilderForm, Errors errors) {
        boolean validCutStyleId = orderService.getCutStyles().stream().map(CutStyle::getId).anyMatch(pizzaBuilderForm.getCutStyleId()::equals);
        if (!validCutStyleId) {
            errors.rejectValue("cutStyleId", "cutStyleId.invalid", ArrayUtils.toArray(pizzaBuilderForm.getCutStyleId()), "cutStyleId.invalid");
        }
    }

    private void validatePizzaSizeId(PizzaBuilderForm pizzaBuilderForm, Errors errors) {
        boolean validPizzaSizeId = orderService.getPizzaSizes().stream().map(PizzaSize::getId).anyMatch(pizzaBuilderForm.getPizzaSizeId()::equals);
        if (!validPizzaSizeId) {
            errors.rejectValue("pizzaSizeId", "pizzaSizeId.invalid", ArrayUtils.toArray(pizzaBuilderForm.getPizzaSizeId()), "pizzaSizeId.invalid");
        }
    }

    private void validateQuantity(PizzaBuilderForm pizzaBuilderForm, Errors errors) {
        if (!Range.closed(pizzaQuantityMin,pizzaQuantityMax).contains(pizzaBuilderForm.getQuantity())) {
            errors.rejectValue("quantity", "pizza.quantity.out.of.range", ArrayUtils.toArray(pizzaQuantityMin, pizzaQuantityMax), "pizza.quantity.out.of.range");
        }
    }

    private void validateIngredients(PizzaBuilderForm pizzaBuilderForm, Errors errors) {
        List<IngredientQuantity> ingredientQuantities = getSelectedIngredients(pizzaBuilderForm);

        validateIngredientQuantity(ingredientQuantities, errors);

        validateIngredientIds(errors, ingredientQuantities);
    }

    private List<IngredientQuantity> getSelectedIngredients(PizzaBuilderForm pizzaBuilderForm) {
        return pizzaBuilderForm.getIngredientGroups().stream().map(PizzaBuilderForm.IngredientGroup::getIngredientQuantities).flatMap(List::stream)
                .filter(ingredientQuantity -> ingredientQuantity.getIngredientSide() != PizzaBuilderForm.IngredientSide.NONE)
                .collect(Collectors.toList());
    }

    private void validateIngredientQuantity(List<IngredientQuantity> ingredientQuantities, Errors errors) {
        if (!Range.closed(selectedIngredientsQuantityMin, selectedIngredientsQuantityMax).contains(ingredientQuantities.size())) {
            errors.reject("ingredient.quantity.out.of.range", ArrayUtils.toArray(selectedIngredientsQuantityMin, selectedIngredientsQuantityMax), "ingredient.quantity.out.of.range");
        }
    }

    private void validateIngredientIds(Errors errors, List<IngredientQuantity> ingredientQuantities) {
        Set<Long> ingredientIds = orderService.getIngredients().stream().map(Ingredient::getId).collect(Collectors.toSet());

        ingredientQuantities.forEach(ingredientQuantity -> {
            if (!ingredientIds.contains(ingredientQuantity.getIngredient().getId())) {
                errors.reject("ingredientId.invalid", ArrayUtils.toArray(ingredientQuantity.getIngredient().getId()), "ingredientId.invalid");
            }
        });
    }

    public OrderService getOrderService() {
        return orderService;
    }

    @Autowired
    public void setOrderService(OrderService orderService) {
        this.orderService = orderService;
    }

    public int getSelectedIngredientsQuantityMin() {
        return selectedIngredientsQuantityMin;
    }

    public void setSelectedIngredientsQuantityMin(int selectedIngredientsQuantityMin) {
        this.selectedIngredientsQuantityMin = selectedIngredientsQuantityMin;
    }

    public int getSelectedIngredientsQuantityMax() {
        return selectedIngredientsQuantityMax;
    }

    public void setSelectedIngredientsQuantityMax(int selectedIngredientsQuantityMax) {
        this.selectedIngredientsQuantityMax = selectedIngredientsQuantityMax;
    }

    public int getPizzaQuantityMin() {
        return pizzaQuantityMin;
    }

    public void setPizzaQuantityMin(int pizzaQuantityMin) {
        this.pizzaQuantityMin = pizzaQuantityMin;
    }

    public int getPizzaQuantityMax() {
        return pizzaQuantityMax;
    }

    public void setPizzaQuantityMax(int pizzaQuantityMax) {
        this.pizzaQuantityMax = pizzaQuantityMax;
    }
}
