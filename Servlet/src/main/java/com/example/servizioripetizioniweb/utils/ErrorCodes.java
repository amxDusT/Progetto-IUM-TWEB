package com.example.servizioripetizioniweb.utils;

public enum ErrorCodes {
    ERROR_NOT_AUTHORIZED(403),
    // LOGIN
    ERROR_LOGIN_NOT_LOGGED(450),
    ERROR_LOGIN_WRONG_CREDENTIALS(451),
    ERROR_LOGIN_USER_VALIDATION(452),
    ERROR_LOGIN_PASSWORD_VALIDATION(453),

    // booking
    ERROR_DOCENTE_ACTIVE(459),
    ERROR_CORSO_ACTIVE(460),    // corso is already active, cannot book twice.
    ERROR_ORARIO_ACTIVE(461),   // user has already that hour occupied in another course.

    ERROR_DAY_ERROR(462),
    ERROR_HOUR_ERROR(463),
    ERROR_DOCENTE_ERROR(464),
    ERROR_CORSO_ERROR(465),
    ERROR_PRENOTAZIONE_ERROR(466),
    ERROR_STATO_ERROR(467),
    //generic
    ERROR_UNKNOWN(470);         // generic error. show "try again".



    private int errNum;
    ErrorCodes(int errNum){
        this.errNum = errNum;
    }

    public int getErrNum(){
        return errNum;
    }
}
