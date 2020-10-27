package pzinsta.pizzeria.service.impl;

import org.hibernate.engine.jdbc.ReaderInputStream;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.mockito.ArgumentMatchers;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;
import pzinsta.pizzeria.dao.FileDAO;
import pzinsta.pizzeria.model.File;

import java.io.InputStream;
import java.io.StringReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

public class FileSystemFileStorageServiceTest {

    @Rule
    public MockitoRule mockitoRule = MockitoJUnit.rule();
    
    @Rule
    public TemporaryFolder temporaryFolder = new TemporaryFolder();
    
    @Mock
    private FileDAO fileDAO;
    
    @InjectMocks
    private FileSystemFileStorageService fileSystemFileStorageService;
    public static final String CONTENT = "abcdef";
    public static final String CONTENT_TYPE = "text/plain";
    public static final String FILE_NAME = "text.txt";

    @Before
    public void setUp() throws Exception {
        fileSystemFileStorageService.setDirectory(temporaryFolder.newFolder().getAbsolutePath());
    }

    @Test
    public void shouldSaveFileWithoutNameProvided() throws Exception {
        // given
        InputStream inputStream = new ReaderInputStream(new StringReader(CONTENT));
        when(fileDAO.saveOrUpdate(ArgumentMatchers.any(File.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // when
        File result = fileSystemFileStorageService.saveFile(inputStream, CONTENT_TYPE);

        // then
        verify(fileDAO).saveOrUpdate(ArgumentMatchers.any(File.class));

        assertThat(result.getName()).isNotBlank();
        assertThat(result.getContentType()).isEqualTo(CONTENT_TYPE);

        Path savedFilePath = Paths.get(fileSystemFileStorageService.getDirectory(), result.getName());
        assertThat(savedFilePath).hasContent(CONTENT);
    }

    @Test
    public void shouldSaveFileWithNameProvided() throws Exception {
        // given
        InputStream inputStream = new ReaderInputStream(new StringReader(CONTENT));
        when(fileDAO.saveOrUpdate(ArgumentMatchers.any(File.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // when
        File result = fileSystemFileStorageService.saveFile(inputStream, FILE_NAME, CONTENT_TYPE);

        // then
        verify(fileDAO).saveOrUpdate(ArgumentMatchers.any(File.class));

        assertThat(result.getName()).isEqualTo(FILE_NAME);
        assertThat(result.getContentType()).isEqualTo(CONTENT_TYPE);

        Path savedFilePath = Paths.get(fileSystemFileStorageService.getDirectory(), FILE_NAME);
        assertThat(savedFilePath).hasContent(CONTENT);
    }

    @Test
    public void shouldGetFileAsInputStream() throws Exception {
        // given
        InputStream inputStream = new ReaderInputStream(new StringReader(CONTENT));
        Path path = Paths.get(fileSystemFileStorageService.getDirectory(), FILE_NAME);
        Files.copy(inputStream, path);

        // when
        InputStream result = fileSystemFileStorageService.getFileAsInputStream(FILE_NAME);

        // then
        ReaderInputStream expected = new ReaderInputStream(new StringReader(CONTENT));
        assertThat(result).hasSameContentAs(expected);
    }

    @Test
    public void shouldGetContentTypeByName() throws Exception {
        // given
        when(fileDAO.getContentTypeByName(FILE_NAME)).thenReturn(Optional.of(CONTENT_TYPE));

        // when
        Optional<String> result = fileSystemFileStorageService.getContentTypeByName(FILE_NAME);

        // then
        assertThat(result).contains(CONTENT_TYPE);
    }
}