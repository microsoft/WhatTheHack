package pzinsta.pizzeria.model;

import pzinsta.pizzeria.model.user.User;

import javax.persistence.Entity;
import javax.persistence.PrimaryKeyJoinColumn;

@Entity
@PrimaryKeyJoinColumn(name = "user_id")
public class Manager extends User {

}
