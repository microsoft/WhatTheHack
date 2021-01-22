package pzinsta.pizzeria.web.validator;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.springframework.web.multipart.MultipartFile;
import pzinsta.pizzeria.web.form.ReviewForm;

import javax.imageio.ImageIO;
import java.io.IOException;
import java.util.Optional;

@Component
public class ReviewFormValidator implements Validator {

    @Override
    public boolean supports(Class<?> clazz) {
        return ReviewForm.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        ReviewForm reviewForm = (ReviewForm) target;

        boolean validImages = reviewForm.getImages().stream().allMatch(ReviewFormValidator::isValidImage);
        if (!validImages) {
            errors.rejectValue("images", "image.format");
        }
    }

    private static boolean isValidImage(MultipartFile multipartFile) {
        try {
            return Optional.ofNullable(ImageIO.read(multipartFile.getInputStream())).isPresent();
        } catch (IOException e) {
            return false;
        }
    }
}
