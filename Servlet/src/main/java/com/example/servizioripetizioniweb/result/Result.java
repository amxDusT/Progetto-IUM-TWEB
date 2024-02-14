package com.example.servizioripetizioniweb.result;

import dao.Corso;
import dao.Docente;
import dao.Prenotazione;
import dao.Utente;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class Result{
    protected String error;
    protected String success;

    public Result(){}
    public void setError(String error){
        this.error = error;
    }
    public void setSuccess(String message){
        this.success = message;
    }
}

