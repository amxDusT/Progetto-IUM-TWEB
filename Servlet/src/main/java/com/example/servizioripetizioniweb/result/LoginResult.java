package com.example.servizioripetizioniweb.result;

import dao.Utente;

public class LoginResult extends Result {
    private Utente utente;

    public LoginResult() {
    }

    public void setSuccess(String token, Utente u) {
        super.setSuccess(token);
        this.utente = u;
    }
}
