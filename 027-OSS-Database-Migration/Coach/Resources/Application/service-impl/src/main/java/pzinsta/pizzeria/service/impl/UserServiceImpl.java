package pzinsta.pizzeria.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pzinsta.pizzeria.dao.AccountDAO;
import pzinsta.pizzeria.dao.UserDAO;
import pzinsta.pizzeria.model.user.Account;
import pzinsta.pizzeria.model.user.User;
import pzinsta.pizzeria.service.UserService;
import pzinsta.pizzeria.service.dto.AccountDTO;
import pzinsta.pizzeria.service.dto.UserDTO;
import pzinsta.pizzeria.service.exception.UserNotFoundException;

import java.time.Instant;
import java.util.Collection;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UserServiceImpl implements UserService {

    private UserDAO userDAO;
    private AccountDAO accountDAO;

    @Autowired
    public UserServiceImpl(UserDAO userDAO, AccountDAO accountDAO) {
        this.userDAO = userDAO;
        this.accountDAO = accountDAO;
    }

    @Override
    @Transactional(readOnly = true)
    public Collection<UserDTO> getUsers() {
        return userDAO.findAll().stream()
                .map(UserServiceImpl::transformUserToUserDTO)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public UserDTO getUserById(Long id) {
        return userDAO.findById(id).map(UserServiceImpl::transformUserToUserDTO).orElseThrow(UserNotFoundException::new);
    }

    @Override
    @Transactional
    public UserDTO updateUser(UserDTO userDTO) {
        User user = userDAO.findById(userDTO.getId()).orElseThrow(UserNotFoundException::new);
        user.setEmail(userDTO.getEmail());
        user.setFirstName(userDTO.getFirstName());
        user.setLastName(userDTO.getLastName());
        user.setPhoneNumber(userDTO.getPhoneNumber());
        return transformUserToUserDTO(user);
    }

    @Override
    @Transactional
    public UserDTO addUser(UserDTO userDTO, AccountDTO accountDTO) {
        User user = userDAO.saveOrUpdate(transformUserToUserDTO(userDTO));

        Optional.ofNullable(accountDTO)
                .map(UserServiceImpl::transformAccountDTOToAccount)
                .ifPresent(account -> {
                    account.setUser(user);
                    user.setAccount(account);
                    accountDAO.saveOrUpdate(account);
                });

        return transformUserToUserDTO(user);
    }

    @Override
    public Collection<UserDTO> getUsers(int offset, int limit) {
        return userDAO.findWithinRange(offset, limit).stream()
                .map(UserServiceImpl::transformUserToUserDTO)
                .collect(Collectors.toList());
    }

    @Override
    public Long getTotalCount() {
        return userDAO.getCount();
    }

    private static UserDTO transformUserToUserDTO(User user) {
        UserDTO userDTO = new UserDTO();
        userDTO.setId(user.getId());
        userDTO.setFirstName(user.getFirstName());
        userDTO.setLastName(user.getLastName());
        userDTO.setEmail(user.getEmail());
        userDTO.setPhoneNumber(user.getPhoneNumber());
        userDTO.setAccountId(Optional.ofNullable(user.getAccount()).map(Account::getId).orElse(null));
        return userDTO;
    }

    private static Account transformAccountDTOToAccount(AccountDTO accountDTO) {
        Account account = new Account();
        account.setUsername(accountDTO.getUsername());
        account.setEnabled(accountDTO.isEnabled());
        account.setAccountExpired(accountDTO.isAccountExpired());
        account.setAccountLocked(accountDTO.isAccountLocked());
        account.setCredentialsExpired(accountDTO.isCredentialsExpired());
        account.setCreatedOn(Instant.now());
        account.setRoles(accountDTO.getRoles());
        return account;
    }

    private static User transformUserToUserDTO(UserDTO userDTO) {
        User user = new User();
        user.setFirstName(userDTO.getFirstName());
        user.setLastName(userDTO.getLastName());
        user.setEmail(userDTO.getEmail());
        user.setPhoneNumber(userDTO.getPhoneNumber());
        return user;
    }

    public UserDAO getUserDAO() {
        return userDAO;
    }

    public void setUserDAO(UserDAO userDAO) {
        this.userDAO = userDAO;
    }
}
