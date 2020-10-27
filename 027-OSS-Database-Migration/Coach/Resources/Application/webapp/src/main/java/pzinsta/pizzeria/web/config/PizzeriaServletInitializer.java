package pzinsta.pizzeria.web.config;

import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

import javax.servlet.MultipartConfigElement;
import javax.servlet.ServletRegistration;

public class PizzeriaServletInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    private static final String MULTIPART_LOCATION = System.getenv("java.io.tmpdir");
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024;
    private static final long MAX_REQUEST_SIZE = 10 * 1024 * 1024;
    private static final int FILE_SIZE_THRESHOLD = 0;

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class<?>[] { RootConfig.class };
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class<?>[] { WebConfig.class, WebFlowConfig.class };
    }

    @Override
    protected String[] getServletMappings() {
        return new String[] { "/" };
    }

    @Override
    protected void customizeRegistration(ServletRegistration.Dynamic registration) {
        registration.setMultipartConfig(new MultipartConfigElement(MULTIPART_LOCATION, MAX_FILE_SIZE, MAX_REQUEST_SIZE, FILE_SIZE_THRESHOLD));
    }
}
