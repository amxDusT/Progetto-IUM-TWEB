package com.example.servizioripetizioniweb.utils;

import dao.Prenotazione;

public class PrenotazioneException extends Exception {
    private final Prenotazione.Errors errCode;
    public PrenotazioneException(Prenotazione.Errors errCode, String errorMessage){
        super(errorMessage);
        this.errCode = errCode;
    }
    public PrenotazioneException(Prenotazione.Errors errCode, String errorMessage, Throwable e ){
        super(errorMessage, e);
        this.errCode = errCode;
    }

    public Prenotazione.Errors getErrCode() {
        return this.errCode;
    }

}
