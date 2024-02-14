import 'package:get/get.dart';

class LangMessages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'not_have_account': 'Don\'t have an account?',
          'register': 'Register',
          'search': 'Search...',
          'hello': 'Hello @name',
          'available': 'Available',
          'unavailable': 'Out',
          'password_length_error': 'Password must have at least 8 characters',
          'available_teachers': 'Available Teachers',
          'english': 'English',
          'italian': 'Italian',
          'language': 'Language: @lang',
          'theme': 'Theme: @theme',
          'dark': 'Dark',
          'light': 'Light',
          'choose_language': 'Choose the language',
          'course_info': 'Course Information',
          'no_teacher_available': 'There is no teacher available',
          'error': 'Error',
          'error_connection': 'Could not connect to server',
          'error_not_logged': 'You are not logged in',
          'error_wrong_cred': 'Username/Email or password wrong',
          'error_user_validation': 'Username not valid',
          'error_pw_validation': 'Password not valid',
          'error_docente_active':
              'The teacher has already a booking in this hour',
          'error_corso_active': 'You have already booked this course',
          'error_orario_active': 'You have already booked in this hour',
          'error_bad_day': 'Error trasmitting the day',
          'error_bad_hour': 'Error trasmitting the hour',
          'error_bad_docente': 'Error trasmitting the teacher',
          'error_bad_corso': 'Error trasmitting the course',
          'error_bad_prenotazione': 'Error trasmitting the booking',
          'error_bad_stato': 'Error trasmitting the state of the booking',
          'error_unknown': 'Unknown error',
          'error_server': 'Server error',
          'retry_later': 'Retry later',
          'select_valid_hour': 'Select a valid hour',
          'success': 'Done!',
          'booking_done': 'Successfully booked',
          'choose_available_hours': 'Choose between the available hours',
          'book': 'Book',
          'done': 'Done',
          'cancel': 'Cancel',
          'cancelled': 'Cancelled',
          'help': 'Help',
          'booking_manage':
              'Tap on the booking to manage it',
          'booking_handle_left':
              'Swipe left to mark the booking as done',
          'booking_handle_right':
              'Swipe right to cancel the booking',
          'confirm_cancel': 'Are you sure you want to cancel the booking?',
          'confirm_done': 'Do you want to mark your booking as done?',
          'yes': 'Yes',
          'do_booking' : 'Complete',
          'bookings': 'Bookings',

          'profile': 'Profile',
          'active': 'Active',
          'info_booking': 'Booking Info',
          'lesson_duration': 'Each lesson lasts 1 hour',
          'course_already_booked': 'You have already booked this course',
          'remember_me': 'Remember me',
          'forgot_password': 'Forgot password?',
          'courses': 'Courses',
          'active_bookings': 'Active bookings',
          'no_active_bookings': 'There are no active bookings',
          'ended_bookings': 'Closed bookings',
          'no_ended_bookings': 'There are no close bookings',
          'log_out': 'Log out',
          'not_found': 'Not found',
        },
        'it_IT': {
          'not_have_account': 'Non hai un account?',
          'register': 'Registrati',
          'search': 'Cerca...',
          'hello': 'Ciao @name',
          'available': 'Disponibile',
          'unavailable': 'Esaurito',
          'password_length_error': 'La password deve avere almeno 8 caratteri',
          'available_teachers': 'Prof Disponibili',
          'english': 'Inglese',
          'italian': 'Italiano',
          'language': 'Lingua: @lang',
          'theme': 'Tema: @theme',
          'dark': 'Scuro',
          'light': 'Chiaro',
          'choose_language': 'Scegli la lingua',
          'course_info': 'Informazioni Corso',
          'no_teacher_available': 'Non ci sono docenti disponibili',
          'error': 'Errore',
          'error_connection': 'Connessione al server fallita',
          'error_not_logged': 'Non sei loggato',
          'error_wrong_cred': 'Username/Email o password sbagliata',
          'error_user_validation': 'Username non valido',
          'error_pw_validation': 'Password non valida',
          'error_docente_active':
              'Il docente ha già una prenotazione in questo orario',
          'error_corso_active': 'Hai già prenotato questo corso',
          'error_orario_active': 'Hai già una prenotazione in questo orario',
          'error_bad_day': 'Errore nella trasmissione del giorno',
          'error_bad_hour': 'Errore nella trasmissione dell\'ora',
          'error_bad_docente': 'Errore nella trasmissione del docente',
          'error_bad_corso': 'Errore nella trasmissione del corso',
          'error_bad_prenotazione':
              'Errore nella trasmissione della prenotazione',
          'error_bad_stato':
              'Errore nella trasmissione dello stato della prenotazione',
          'error_unknown': 'Errore sconosciuto',
          'error_server': 'Errore da parte del server',
          'retry_later': 'Riprova più tardi',
          'select_valid_hour': 'Seleziona un orario valido',
          'success': 'Fatto!',
          'booking_done': 'Prenotazione effettuata',
          'choose_available_hours': 'Scegli tra gli orari disponibili',
          'book': 'Prenota',
          'done': 'Effettuata',
          'cancel': 'Cancella',
          'cancelled': 'Cancellata',
          'help': 'Aiuto',
          'booking_manage':
              'Clicca sulla prenotazione per gestire la prenotazione',
          'booking_handle_left':
              'Scorri a sinistra per segnare una prenotazione come effettuata',
          'booking_handle_right':
              'Scorri a destra per cancellare la prenotazione',
          'confirm_cancel': 'Sicuro di voler cancellare la prenotazione?',
          'confirm_done': 'Vuoi segnare la prenotazione come effettuata?',
          'yes': 'Si',
          'do_booking': 'Effettua',
          'bookings': 'Prenotazioni',

          'profile': 'Profilo',
          'active': 'Attiva',
          'info_booking': 'Informazioni Prenotazione',
          'lesson_duration': 'Ogni lezione dura 1 ora',
          'course_already_booked': 'Hai gia prenotato questo corso',
          'remember_me': 'Ricordami',
          'forgot_password': 'Password dimenticata?',
          'courses': 'Corsi',
          'active_bookings': 'Prenotazioni attive',
          'no_active_bookings': 'Non ci sono prenotazioni attive',
          'ended_bookings': 'Prenotazioni terminate',
          'no_ended_bookings': 'Non ci sono prenotazioni terminate',
          'log_out': 'Esci',
          'not_found': 'Non trovato',
        }
      };
}