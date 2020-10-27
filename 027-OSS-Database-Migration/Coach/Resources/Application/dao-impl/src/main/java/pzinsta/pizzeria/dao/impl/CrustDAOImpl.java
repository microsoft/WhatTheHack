package pzinsta.pizzeria.dao.impl;

import org.springframework.stereotype.Repository;
import pzinsta.pizzeria.dao.CrustDAO;
import pzinsta.pizzeria.model.pizza.Crust;

@Repository
public class CrustDAOImpl extends GenericDAOImpl<Crust, Long> implements CrustDAO {

    public CrustDAOImpl() {
        super(Crust.class);
    }
}
