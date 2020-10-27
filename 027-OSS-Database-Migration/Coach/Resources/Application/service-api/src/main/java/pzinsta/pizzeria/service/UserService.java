package pzinsta.pizzeria.service;

import pzinsta.pizzeria.service.dto.AccountDTO;
import pzinsta.pizzeria.service.dto.UserDTO;

import java.util.Collection;

public interface UserService {

    Collection<UserDTO> getUsers();

    UserDTO getUserById(Long id);

    UserDTO updateUser(UserDTO userDTO);

    UserDTO addUser(UserDTO userDTO, AccountDTO accountDTO);

    Collection<UserDTO> getUsers(int offset, int limit);

    Long getTotalCount();
}
