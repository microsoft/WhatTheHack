package pzinsta.pizzeria.dao.impl;

import org.springframework.stereotype.Repository;
import pzinsta.pizzeria.dao.BakeStyleDAO;
import pzinsta.pizzeria.model.pizza.BakeStyle;

@Repository
public class BakeStyleDAOImpl extends GenericDAOImpl<BakeStyle, Long> implements BakeStyleDAO {

    public BakeStyleDAOImpl() {
        super(BakeStyle.class);
    }
}
