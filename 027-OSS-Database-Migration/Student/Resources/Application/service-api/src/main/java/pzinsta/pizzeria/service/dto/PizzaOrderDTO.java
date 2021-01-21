package pzinsta.pizzeria.service.dto;

import java.util.Map;

public class PizzaOrderDTO {
    private Long id;
    private Long crustId;
    private Long pizzaSizeId;
    private Long bakeStyleId;
    private Long cutStyleId;
    private Map<Long, Integer> leftSideIngredientIdByQuantity;
    private Map<Long, Integer> rightSideIngredientIdByQuantity;
    private int quantity;

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

    public Map<Long, Integer> getLeftSideIngredientIdByQuantity() {
        return leftSideIngredientIdByQuantity;
    }

    public void setLeftSideIngredientIdByQuantity(Map<Long, Integer> leftSideIngredientIdByQuantity) {
        this.leftSideIngredientIdByQuantity = leftSideIngredientIdByQuantity;
    }

    public Map<Long, Integer> getRightSideIngredientIdByQuantity() {
        return rightSideIngredientIdByQuantity;
    }

    public void setRightSideIngredientIdByQuantity(Map<Long, Integer> rightSideIngredientIdByQuantity) {
        this.rightSideIngredientIdByQuantity = rightSideIngredientIdByQuantity;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
}
