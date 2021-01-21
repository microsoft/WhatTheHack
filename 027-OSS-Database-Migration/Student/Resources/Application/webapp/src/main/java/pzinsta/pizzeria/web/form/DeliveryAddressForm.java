package pzinsta.pizzeria.web.form;

import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotBlank;

public class DeliveryAddressForm {
    @NotBlank
    @Length(max = 100)
    private String city;

    @NotBlank
    @Length(max = 100)
    private String street;

    @NotBlank
    @Length(max = 5)
    private String houseNumber;

    @Length(max = 5)
    private String apartmentNumber;

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getHouseNumber() {
        return houseNumber;
    }

    public void setHouseNumber(String houseNumber) {
        this.houseNumber = houseNumber;
    }

    public String getApartmentNumber() {
        return apartmentNumber;
    }

    public void setApartmentNumber(String apartmentNumber) {
        this.apartmentNumber = apartmentNumber;
    }

}
