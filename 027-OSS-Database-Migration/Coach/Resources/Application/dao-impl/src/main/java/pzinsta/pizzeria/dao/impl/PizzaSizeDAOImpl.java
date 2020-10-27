package pzinsta.pizzeria.dao.impl;

import org.springframework.stereotype.Repository;
import pzinsta.pizzeria.dao.PizzaSizeDAO;
import pzinsta.pizzeria.model.pizza.PizzaSize;

@Repository
public class PizzaSizeDAOImpl extends GenericDAOImpl<PizzaSize, Long> implements PizzaSizeDAO {

    public PizzaSizeDAOImpl() {
        super(PizzaSize.class);
    }
}
