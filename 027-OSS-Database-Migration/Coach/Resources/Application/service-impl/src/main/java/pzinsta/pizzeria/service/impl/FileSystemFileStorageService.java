package pzinsta.pizzeria.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;
import pzinsta.pizzeria.dao.FileDAO;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;

@Service
@Profile("default")
public class FileSystemFileStorageService extends AbstractDaoFileStorageService {

    @Value("${file.storage.directory}")
    private String directory;

    @Autowired
    public FileSystemFileStorageService(FileDAO fileDAO) {
        super(fileDAO);
    }

    @Override
    protected void saveFileContent(InputStream inputStream, String name, String contentType) throws IOException {
        Files.copy(inputStream, Paths.get(directory, name));
    }

    @Override
    public InputStream getFileAsInputStream(String name) throws IOException {
        return Files.newInputStream(Paths.get(directory, name));
    }

    public String getDirectory() {
        return directory;
    }

    public void setDirectory(String directory) {
        this.directory = directory;
    }

}
