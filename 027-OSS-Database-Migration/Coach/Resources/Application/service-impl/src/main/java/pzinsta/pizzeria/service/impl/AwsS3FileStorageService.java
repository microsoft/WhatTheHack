package pzinsta.pizzeria.service.impl;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSCredentialsProvider;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.util.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;
import pzinsta.pizzeria.dao.FileDAO;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Optional;

@Service
@Profile("aws")
public class AwsS3FileStorageService extends AbstractDaoFileStorageService {
    @Value("${aws.s3.bucket.name}")
    private String bucketName;

    @Value("${aws.s3.region}")
    private String region;

    @Value("${aws.access.key}")
    private String accessKey;

    @Value("${aws.secret.key}")
    private String secretKey;

    @Autowired
    public AwsS3FileStorageService(FileDAO fileDAO) {
        super(fileDAO);
    }

    @Override
    protected void saveFileContent(InputStream inputStream, String name, String contentType) throws IOException {
        byte[] bytes = IOUtils.toByteArray(inputStream);
        ObjectMetadata objectMetadata = new ObjectMetadata();
        objectMetadata.setContentType(contentType);
        objectMetadata.setContentLength(bytes.length);
        getAmazonS3().putObject(bucketName, name, new ByteArrayInputStream(bytes), objectMetadata);
    }

    @Override
    public InputStream getFileAsInputStream(String name) throws IOException {
        return getAmazonS3().getObject(bucketName, name).getObjectContent();
    }

    @Override
    public Optional<String> getContentTypeByName(String name) {
        return Optional.ofNullable(getAmazonS3().getObject(bucketName, name).getObjectMetadata().getContentType());
    }

    private AmazonS3 getAmazonS3() {
        AWSCredentials awsCredentials = new BasicAWSCredentials(accessKey, secretKey);
        AWSCredentialsProvider awsCredentialsProvider = new AWSStaticCredentialsProvider(awsCredentials);
        return AmazonS3ClientBuilder.standard()
                .withCredentials(awsCredentialsProvider)
                .withRegion(region)
                .build();
    }
}
