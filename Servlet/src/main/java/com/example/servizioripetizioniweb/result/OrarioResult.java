package com.example.servizioripetizioniweb.result;

import java.util.ArrayList;
import java.util.List;

public class OrarioResult extends Result {
    private ArrayList<Integer> orari;

    public OrarioResult() {
    }

    @Override
    public void setError(String error) {
        super.setError(error);
        orari = new ArrayList<>();
    }

    public void setSuccess(String message, List<Integer> orari) {
        super.setSuccess(message);
        this.orari = new ArrayList<>(orari);
    }
}
