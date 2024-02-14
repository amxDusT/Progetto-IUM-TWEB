// ignore_for_file: constant_identifier_names

enum ErrorCodes {
  // LOGIN
  ERROR_LOGIN_NOT_LOGGED(450, 'error_not_logged'),
  ERROR_LOGIN_WRONG_CREDENTIALS(451, 'error_wrong_cred'),
  ERROR_LOGIN_USER_VALIDATION(452, 'error_user_validation'),
  ERROR_LOGIN_PASSWORD_VALIDATION(453, 'error_pw_validation'),

  // booking
  ERROR_DOCENTE_ACTIVE(
      459, 'error_docente_active'), 
  ERROR_CORSO_ACTIVE(
      460, 'error_corso_active'), // corso is already active, cannot book twice.
  ERROR_ORARIO_ACTIVE(461,
      'error_orario_active'), // user has already that hour occupied in another course.

  ERROR_DAY_ERROR(462, 'error_bad_day'),
  ERROR_HOUR_ERROR(463, 'error_bad_hour'),
  ERROR_DOCENTE_ERROR(464, 'error_bad_docente'),
  ERROR_CORSO_ERROR(465, 'error_bad_corso'),
  ERROR_PRENOTAZIONE_ERROR(466, 'error_bad_prenotazione'),
  ERROR_STATO_ERROR(467, 'error_bad_stato'),

  //generic
  ERROR_UNKNOWN(470, 'error_unknown'), // generic error. show "try again".
  ERROR_CONNECTION(499, 'error_connection'),
  ERROR_SERVER(500, 'error_server');

  final int errNum;
  final String message;

  const ErrorCodes(this.errNum, this.message);

  int get errorCode => errNum;
}

final errorMessages = {
  ErrorCodes.ERROR_LOGIN_NOT_LOGGED.errorCode:
      ErrorCodes.ERROR_LOGIN_NOT_LOGGED,
  ErrorCodes.ERROR_LOGIN_WRONG_CREDENTIALS.errorCode:
      ErrorCodes.ERROR_LOGIN_WRONG_CREDENTIALS,
  ErrorCodes.ERROR_LOGIN_USER_VALIDATION.errorCode:
      ErrorCodes.ERROR_LOGIN_USER_VALIDATION,
  ErrorCodes.ERROR_LOGIN_PASSWORD_VALIDATION.errorCode:
      ErrorCodes.ERROR_LOGIN_PASSWORD_VALIDATION,
  ErrorCodes.ERROR_DOCENTE_ACTIVE.errorCode: ErrorCodes.ERROR_DOCENTE_ACTIVE,
  ErrorCodes.ERROR_CORSO_ACTIVE.errorCode: ErrorCodes.ERROR_CORSO_ACTIVE,
  ErrorCodes.ERROR_ORARIO_ACTIVE.errorCode: ErrorCodes.ERROR_ORARIO_ACTIVE,
  ErrorCodes.ERROR_DAY_ERROR.errorCode: ErrorCodes.ERROR_DAY_ERROR,
  ErrorCodes.ERROR_HOUR_ERROR.errorCode: ErrorCodes.ERROR_HOUR_ERROR,
  ErrorCodes.ERROR_DOCENTE_ERROR.errorCode: ErrorCodes.ERROR_DOCENTE_ERROR,
  ErrorCodes.ERROR_CORSO_ERROR.errorCode: ErrorCodes.ERROR_CORSO_ERROR,
  ErrorCodes.ERROR_PRENOTAZIONE_ERROR.errorCode:
      ErrorCodes.ERROR_PRENOTAZIONE_ERROR,
  ErrorCodes.ERROR_STATO_ERROR.errorCode: ErrorCodes.ERROR_STATO_ERROR,
  ErrorCodes.ERROR_UNKNOWN.errorCode: ErrorCodes.ERROR_UNKNOWN,
  ErrorCodes.ERROR_CONNECTION.errorCode: ErrorCodes.ERROR_CONNECTION,
  ErrorCodes.ERROR_SERVER.errorCode: ErrorCodes.ERROR_SERVER,
};
