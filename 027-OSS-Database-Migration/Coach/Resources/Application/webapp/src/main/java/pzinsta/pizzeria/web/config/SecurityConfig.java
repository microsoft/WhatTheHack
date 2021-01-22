package pzinsta.pizzeria.web.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.security.web.authentication.logout.DelegatingLogoutSuccessHandler;
import org.springframework.security.web.authentication.logout.HttpStatusReturningLogoutSuccessHandler;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.security.web.util.matcher.MediaTypeRequestMatcher;
import org.springframework.security.web.util.matcher.RequestMatcher;
import org.springframework.web.accept.ContentNegotiationStrategy;
import org.springframework.web.accept.HeaderContentNegotiationStrategy;
import pzinsta.pizzeria.web.security.handler.RedirectAuthenticationFailureHandler;

import java.util.LinkedHashMap;

@Configuration
@EnableWebSecurity
@ComponentScan("pzinsta.pizzeria.web.security")
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private UserDetailsService userDetailsService;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                .authorizeRequests()
                    .antMatchers("/customer/**").hasRole("REGISTERED_CUSTOMER")
                    .antMatchers("/authentication/**").authenticated()
                    .antMatchers("/users/**").hasRole("ADMIN")
                    .antMatchers("/accounts/**").hasRole("ADMIN")
                    .antMatchers("/orders/**").hasRole("MANAGER")
                    .anyRequest().permitAll()
                    .and()
                .formLogin()
                    .loginPage("/login")
                    .permitAll()
                    .successHandler(authenticationSuccessHandler())
                    .failureHandler(authenticationFailureHandler())
                    .and()
                .httpBasic()
                    .and()
                .csrf()
                    .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
                    .and()
                .rememberMe()
                    .userDetailsService(userDetailsService)
                    .and()
                .logout()
                    .logoutSuccessHandler(logoutSuccessHandler())
                    .permitAll();

    }

    @Bean
    public AuthenticationSuccessHandler authenticationSuccessHandler() {
        SavedRequestAwareAuthenticationSuccessHandler savedRequestAwareAuthenticationSuccessHandler = new SavedRequestAwareAuthenticationSuccessHandler();
        savedRequestAwareAuthenticationSuccessHandler.setTargetUrlParameter("returnUrl");
        return  savedRequestAwareAuthenticationSuccessHandler;
    }

    @Bean
    public LogoutSuccessHandler logoutSuccessHandler() {
        ContentNegotiationStrategy contentNegotiationStrategy = new HeaderContentNegotiationStrategy();

        MediaTypeRequestMatcher jsonMediaTypeRequestMatcher = new MediaTypeRequestMatcher(contentNegotiationStrategy, MediaType.APPLICATION_JSON);
        jsonMediaTypeRequestMatcher.setUseEquals(true);

        LinkedHashMap<RequestMatcher, LogoutSuccessHandler> matcherToHandler = new LinkedHashMap<>();
        matcherToHandler.put(jsonMediaTypeRequestMatcher, new HttpStatusReturningLogoutSuccessHandler());

        DelegatingLogoutSuccessHandler delegatingLogoutSuccessHandler = new DelegatingLogoutSuccessHandler(matcherToHandler);

        SimpleUrlLogoutSuccessHandler simpleUrlLogoutSuccessHandler = new SimpleUrlLogoutSuccessHandler();
        simpleUrlLogoutSuccessHandler.setUseReferer(true);
        simpleUrlLogoutSuccessHandler.setDefaultTargetUrl("/");

        delegatingLogoutSuccessHandler.setDefaultLogoutSuccessHandler(simpleUrlLogoutSuccessHandler);

        return delegatingLogoutSuccessHandler;
    }

    @Bean
    public AuthenticationFailureHandler authenticationFailureHandler() {
        RedirectAuthenticationFailureHandler redirectAuthenticationFailureHandler = new RedirectAuthenticationFailureHandler();
        redirectAuthenticationFailureHandler.setDefaultReturnUrl("/");
        redirectAuthenticationFailureHandler.setQueryParam("loginError");
        return redirectAuthenticationFailureHandler;
    }
}
