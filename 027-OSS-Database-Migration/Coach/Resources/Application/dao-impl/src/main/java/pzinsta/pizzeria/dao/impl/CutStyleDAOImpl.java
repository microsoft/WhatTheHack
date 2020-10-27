package pzinsta.pizzeria.dao.impl;

import org.springframework.stereotype.Repository;
import pzinsta.pizzeria.dao.CutStyleDAO;
import pzinsta.pizzeria.model.pizza.CutStyle;

@Repository
public class CutStyleDAOImpl extends GenericDAOImpl<CutStyle, Long> implements CutStyleDAO{

    protected CutStyleDAOImpl() {
        super(CutStyle.class);
    }
}
