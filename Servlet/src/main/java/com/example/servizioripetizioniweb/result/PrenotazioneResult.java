package com.example.servizioripetizioniweb.result;

import dao.Prenotazione;

import java.util.ArrayList;
import java.util.List;

public class PrenotazioneResult extends Result {
    private ArrayList<Prenotazione> prenotazioni;

    public PrenotazioneResult() {
    }

    @Override
    public void setError(String error) {
        super.setError(error);
        prenotazioni = new ArrayList<>();
    }

    public void setSuccess(String message, List<Prenotazione> prenotazioni) {
        super.setSuccess(message);
        this.prenotazioni = new ArrayList<>(prenotazioni);
    }
}
