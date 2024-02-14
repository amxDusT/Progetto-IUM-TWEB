package com.example.servizioripetizioniweb.result;

import dao.Docente;

import java.util.ArrayList;
import java.util.List;

public class DocenteResult extends Result {
    private ArrayList<Docente> docenti;

    public DocenteResult() {
    }

    @Override
    public void setError(String error) {
        super.setError(error);
        docenti = new ArrayList<>();
    }

    public void setSuccess(String message, List<Docente> docenti) {
        super.setSuccess(message);
        this.docenti = new ArrayList<>(docenti);
    }
}
