package com.example.servizioripetizioniweb.result;

import dao.Corso;

import java.util.ArrayList;
import java.util.List;

public class CorsoResult extends Result {
    private ArrayList<Corso> corsi;

    public CorsoResult() {
    }

    @Override
    public void setError(String error) {
        super.setError(error);
        corsi = new ArrayList<>();
    }

    public void setSuccess(String message, List<Corso> corsi) {
        super.setSuccess(message);
        this.corsi = new ArrayList<>(corsi);
    }
}
