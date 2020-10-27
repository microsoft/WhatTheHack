package pzinsta.pizzeria.dao;

import pzinsta.pizzeria.model.File;

import java.util.Optional;

public interface FileDAO extends GenericDAO<File, Long> {
    Optional<String> getContentTypeByName(String name);
}
