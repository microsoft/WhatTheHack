package pzinsta.pizzeria.web.rest.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import pzinsta.pizzeria.service.dto.AccountDTO;
import pzinsta.pizzeria.service.dto.UserDTO;

public class UserAndAccountDTO {
    @JsonProperty("user")
    private UserDTO userDTO;

    @JsonProperty("account")
    private AccountDTO accountDTO;

    public UserDTO getUserDTO() {
        return userDTO;
    }

    public void setUserDTO(UserDTO userDTO) {
        this.userDTO = userDTO;
    }

    public AccountDTO getAccountDTO() {
        return accountDTO;
    }

    public void setAccountDTO(AccountDTO accountDTO) {
        this.accountDTO = accountDTO;
    }
}
