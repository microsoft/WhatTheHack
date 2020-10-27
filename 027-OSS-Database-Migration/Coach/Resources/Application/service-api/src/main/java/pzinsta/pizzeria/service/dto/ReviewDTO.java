package pzinsta.pizzeria.service.dto;

import pzinsta.pizzeria.model.File;

import java.util.Collection;

public class ReviewDTO {
    private String message;
    private int rating;
    private Collection<File> files;

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public Collection<File> getFiles() {
        return files;
    }

    public void setFiles(Collection<File> files) {
        this.files = files;
    }
}
