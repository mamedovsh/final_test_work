package controller;

import Animals;
import Repository;

import java.util.List;

public class Controller {
    private final Repository repository;

    public Controller(Repository repository) {
        this.repository = repository;
    }

    public void validateAnimalData(Animal animal) {
        if (animal.getName().isEmpty()) {
            throw new IllegalStateException("Fields are empty!");
        }
    }

    public Iterable<String> readAnimals() {
        return null;
    }