package pzinsta.pizzeria.dao.impl;

import org.springframework.stereotype.Repository;
import pzinsta.pizzeria.dao.IngredientDAO;
import pzinsta.pizzeria.model.pizza.Ingredient;

@Repository
public class IngredientDAOImpl extends GenericDAOImpl<Ingredient, Long> implements IngredientDAO {

    public IngredientDAOImpl() {
        super(Ingredient.class);
    }
}
