package pzinsta.pizzeria.dao.impl;

import org.springframework.stereotype.Repository;
import pzinsta.pizzeria.dao.FileDAO;
import pzinsta.pizzeria.model.File;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import java.util.Optional;

@Repository
public class FileDAOImpl extends GenericDAOImpl<File, Long> implements FileDAO {

    public FileDAOImpl() {
        super(File.class);
    }

    @Override
    public Optional<String> getContentTypeByName(String name) {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<String> criteriaQuery = criteriaBuilder.createQuery(String.class);
        Root<File> root = criteriaQuery.from(entityClass);
        criteriaQuery.select(root.get("contentType"));
        criteriaQuery.where(criteriaBuilder.equal(root.get("name"), name));
        TypedQuery<String> query = entityManager.createQuery(criteriaQuery);
        return query.getResultList().stream().findFirst();
    }
}
