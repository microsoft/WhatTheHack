package pzinsta.pizzeria.web.rest;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;
import java.util.LinkedHashMap;
import java.util.Map;

@RestController
@RequestMapping("/authentication")
public class AuthenticationRestController {

    @GetMapping
    public Map<String, Object> account(Principal principal) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("name", principal.getName());
        map.put("roles", AuthorityUtils.authorityListToSet(((Authentication) principal).getAuthorities()));
        return map;
    }
}
