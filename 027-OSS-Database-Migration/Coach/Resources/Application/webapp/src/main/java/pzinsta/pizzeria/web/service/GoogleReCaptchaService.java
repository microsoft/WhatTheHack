package pzinsta.pizzeria.web.service;

import de.triology.recaptchav2java.ReCaptcha;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class GoogleReCaptchaService {

    private ReCaptcha reCaptcha;

    public GoogleReCaptchaService(@Value("${recaptcha.private.key}")String recaptchaPrivateKey) {
        this.reCaptcha = new ReCaptcha(recaptchaPrivateKey);
    }

    public boolean isValid(String recaptchaResponse) {
        return reCaptcha.isValid(recaptchaResponse);
    }

}
