package pzinsta.pizzeria.dao.impl;

import pzinsta.pizzeria.dao.GenericDAO;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import java.util.List;
import java.util.Optional;

public abstract class GenericDAOImpl<T, ID> implements GenericDAO<T, ID>{
    @PersistenceContext
    protected EntityManager entityManager;
    
    protected final Class<T> entityClass;
    
    protected GenericDAOImpl(Class<T> entityClass) {
        this.entityClass = entityClass;
    }
    
    public void setEntityManager(EntityManager entityManager) {
        this.entityManager = entityManager;
    }
    
    @Override
    public Optional<T> findById(ID id) {
        return Optional.ofNullable(entityManager.find(entityClass, id));
    }
    
    @Override
    public List<T> findAll() {
        CriteriaQuery<T> criteriaQuery = entityManager.getCriteriaBuilder().createQuery(entityClass);
        criteriaQuery.select(criteriaQuery.from(entityClass));
        return entityManager.createQuery(criteriaQuery).getResultList();
    }
    
    @Override
    public Long getCount() {
        CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
        CriteriaQuery<Long> criteriaQuery = criteriaBuilder.createQuery(Long.class);
        criteriaQuery.select(criteriaBuilder.count(criteriaQuery.from(entityClass)));
        return entityManager.createQuery(criteriaQuery).getSingleResult();
    }

    @Override
    public T saveOrUpdate(T entity) {
        return entityManager.merge(entity);
    }
   
    @Override
    public void delete(T entity) {
        entityManager.remove(entity);
    }
}
