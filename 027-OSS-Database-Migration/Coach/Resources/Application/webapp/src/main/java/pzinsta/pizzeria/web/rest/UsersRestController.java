package pzinsta.pizzeria.web.rest;

import com.google.common.collect.ImmutableMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import pzinsta.pizzeria.service.UserService;
import pzinsta.pizzeria.service.dto.UserDTO;
import pzinsta.pizzeria.service.exception.UserNotFoundException;
import pzinsta.pizzeria.web.rest.dto.UserAndAccountDTO;

import java.util.Collection;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/users")
public class UsersRestController {

    private UserService userService;
    private PasswordEncoder passwordEncoder;

    @Autowired
    public UsersRestController(UserService userService, PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping
    public Collection<UserDTO> getUsers() {
        return userService.getUsers();
    }

    @GetMapping(params = {"offset", "limit"})
    public Map<String, Object> getUsers(@RequestParam("offset") int offset, @RequestParam("limit") int limit) {
        return ImmutableMap.of(
                "totalCount", userService.getTotalCount(),
                "users", userService.getUsers(offset, limit));
    }

    @GetMapping("/{userId}")
    public UserDTO getUserById(@PathVariable("userId") Long userId) {
        return userService.getUserById(userId);
    }

    @PutMapping
    public UserDTO updateUser(@RequestBody UserDTO userDTO) {
        return userService.updateUser(userDTO);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public UserDTO addUser(@RequestBody UserAndAccountDTO userAndAccountDTO) {
        Optional.ofNullable(userAndAccountDTO.getAccountDTO())
                .ifPresent(accountDTO -> accountDTO.setPassword(passwordEncoder.encode(accountDTO.getPassword())));
        return userService.addUser(userAndAccountDTO.getUserDTO(), userAndAccountDTO.getAccountDTO());
    }

    @ExceptionHandler(UserNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handleUserNotFoundException(Exception e) {
        return e.getMessage();
    }

    public UserService getUserService() {
        return userService;
    }

    public void setUserService(UserService userService) {
        this.userService = userService;
    }
}
