package pzinsta.pizzeria.service.impl;

import org.springframework.transaction.annotation.Transactional;
import pzinsta.pizzeria.dao.FileDAO;
import pzinsta.pizzeria.model.File;
import pzinsta.pizzeria.service.FileStorageService;

import java.io.IOException;
import java.io.InputStream;
import java.util.Optional;
import java.util.UUID;

public abstract class AbstractDaoFileStorageService implements FileStorageService {

    private FileDAO fileDAO;

    public AbstractDaoFileStorageService(FileDAO fileDAO) {
        this.fileDAO = fileDAO;
    }

    @Override
    @Transactional
    public File saveFile(InputStream inputStream, String contentType) throws IOException {
        return saveFile(inputStream, UUID.randomUUID().toString(), contentType);
    }

    @Override
    @Transactional
    public File saveFile(InputStream inputStream, String name, String contentType) throws IOException {
        saveFileContent(inputStream, name, contentType);
        File file = new File();
        file.setName(name);
        file.setContentType(contentType);
        return fileDAO.saveOrUpdate(file);
    }

    protected abstract void saveFileContent(InputStream inputStream, String name, String contentType) throws IOException;

    @Override
    public abstract InputStream getFileAsInputStream(String name) throws IOException;

    @Override
    @Transactional(readOnly = true)
    public Optional<String> getContentTypeByName(String name) {
        return fileDAO.getContentTypeByName(name);
    }

    public FileDAO getFileDAO() {
        return fileDAO;
    }

    public void setFileDAO(FileDAO fileDAO) {
        this.fileDAO = fileDAO;
    }
}
