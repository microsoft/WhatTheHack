package pzinsta.pizzeria.service;

import pzinsta.pizzeria.model.File;

import java.io.IOException;
import java.io.InputStream;
import java.util.Optional;

public interface FileStorageService {
    File saveFile(InputStream inputStream, String contentType) throws IOException;

    File saveFile(InputStream inputStream, String name, String contentType) throws IOException;

    InputStream getFileAsInputStream(String name) throws IOException;

    Optional<String> getContentTypeByName(String name);
}
