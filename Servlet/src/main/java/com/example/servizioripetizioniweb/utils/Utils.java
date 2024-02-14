package com.example.servizioripetizioniweb.utils;

import dao.Utente;

import javax.servlet.http.HttpSession;

public class Utils {
    private static String userAttribute = "utente";

    public static boolean isLoggedIn(HttpSession session) {
        return session.getAttribute(userAttribute) != null;
    }

    public static boolean isAdmin(HttpSession session) {
        Utente u = (Utente) session.getAttribute(userAttribute);
        return u != null && u.getRuolo() == Utente.role.ADMIN;
    }

    public static Utente getUtente(HttpSession session) {
        return (Utente) session.getAttribute(userAttribute);
    }

    public static void setUtente(HttpSession session, Utente user) {
        session.setAttribute(userAttribute, user);
    }

    public static boolean isInteger(String strNum) {
        if (strNum == null || strNum.isEmpty()) {
            return false;
        }
        try {
            Integer.parseInt(strNum);
        } catch (NumberFormatException nfe) {
            return false;
        }
        return true;
    }
}
