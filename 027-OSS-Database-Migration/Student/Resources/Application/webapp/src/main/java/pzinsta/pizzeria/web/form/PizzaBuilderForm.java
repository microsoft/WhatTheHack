package pzinsta.pizzeria.web.form;

import pzinsta.pizzeria.model.pizza.Ingredient;
import pzinsta.pizzeria.model.pizza.IngredientType;

import javax.validation.constraints.NotNull;
import java.util.List;

public class PizzaBuilderForm {

    private String id;

    @NotNull
    private Long crustId;

    @NotNull
    private Long pizzaSizeId;

    @NotNull
    private Long bakeStyleId;

    @NotNull
    private Long cutStyleId;

    private List<IngredientGroup> ingredientGroups;

    private int quantity;

    public static class IngredientGroup {
        @NotNull
        private IngredientType ingredientType;
        private List<IngredientQuantity> ingredientQuantities;

        public List<IngredientQuantity> getIngredientQuantities() {
            return ingredientQuantities;
        }

        public void setIngredientQuantities(List<IngredientQuantity> ingredientQuantities) {
            this.ingredientQuantities = ingredientQuantities;
        }

        public IngredientType getIngredientType() {
            return ingredientType;
        }

        public void setIngredientType(IngredientType ingredientType) {
            this.ingredientType = ingredientType;
        }
    }

    public enum IngredientSide {
        NONE, WHOLE, LEFT, RIGHT
    }

    public static class IngredientQuantity {
        @NotNull
        private Ingredient ingredient;
        private IngredientSide ingredientSide = IngredientSide.NONE;
        private boolean x2;

        public IngredientSide getIngredientSide() {
            return ingredientSide;
        }

        public void setIngredientSide(IngredientSide ingredientSide) {
            this.ingredientSide = ingredientSide;
        }

        public boolean isX2() {
            return x2;
        }

        public void setX2(boolean x2) {
            this.x2 = x2;
        }

        public Ingredient getIngredient() {
            return ingredient;
        }

        public void setIngredient(Ingredient ingredient) {
            this.ingredient = ingredient;
        }
    }

    public Long getCrustId() {
        return crustId;
    }

    public void setCrustId(Long crustId) {
        this.crustId = crustId;
    }

    public Long getPizzaSizeId() {
        return pizzaSizeId;
    }

    public void setPizzaSizeId(Long pizzaSizeId) {
        this.pizzaSizeId = pizzaSizeId;
    }

    public Long getBakeStyleId() {
        return bakeStyleId;
    }

    public void setBakeStyleId(Long bakeStyleId) {
        this.bakeStyleId = bakeStyleId;
    }

    public Long getCutStyleId() {
        return cutStyleId;
    }

    public void setCutStyleId(Long cutStyleId) {
        this.cutStyleId = cutStyleId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public List<IngredientGroup> getIngredientGroups() {
        return ingredientGroups;
    }

    public void setIngredientGroups(List<IngredientGroup> ingredientGroups) {
        this.ingredientGroups = ingredientGroups;
    }
}
