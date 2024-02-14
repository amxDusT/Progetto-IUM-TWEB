package dao;

import java.util.HashMap;
import java.util.Map;

/**
 * id @Int
 * insegnamento @Insegnamento
 * utente @Utente
 * corso @Corso
 * docente @Docente
 */
public class Prenotazione extends Tabella {
    public enum Orario {
        O_15_16(1),
        O_16_17(2),
        O_17_18(3),
        O_18_19(4);

        int num;

        Orario(int num) {
            this.num = num;
        }

        private static final Map<Integer, Orario> check = new HashMap<Integer, Orario>();

        static {
            for (Orario o : Orario.values())
                check.put(o.getKey(), o);
        }

        int getKey() {
            return num;
        }

        public static Orario get(int key) {
            return check.get(key);
        }

        @Override
        public String toString() {
            return "" + (14 + num) + "-" + (15 + num);
        }
    }

    public enum Errors {
        UTENTE_ORARIO,
        UTENTE_CORSO,
        DOCENTE_ORARIO;
    }

    public enum Giorno {
        LUN(1),
        MAR(2),
        MER(3),
        GIO(4),
        VEN(5);

        private int num;
        private static final Map<Integer, Giorno> check = new HashMap<Integer, Giorno>();

        static {
            for (Giorno g : Giorno.values())
                check.put(g.getWeekDay(), g);
        }

        @Override
        public String toString() {
            return this.name().substring(0, 1).toUpperCase() +
                    this.name().substring(1).toLowerCase();
        }

        Giorno(int num) {
            this.num = num;
        }

        int getWeekDay() {
            return num;
        }

        public static Giorno get(int weekDay) {
            return check.get(weekDay);
        }
    }

    private Integer id;
    private Docente docente;
    private Corso corso;
    private Utente utente;
    private int orario;
    private int giorno;
    private int stato;

    public int getGiorno() {
        return giorno;
    }

    public void setGiorno(int giorno) {
        this.giorno = giorno;
    }

    public int getOrario() {
        return orario;
    }

    public void setOrario(int orario) {
        this.orario = orario;
    }

    public Prenotazione(Utente utente, Corso corso, Docente docente, int orario, int giorno, int stato) {
        this.docente = docente;
        this.corso = corso;
        this.utente = utente;
        this.orario = orario;
        this.giorno = giorno;
        this.stato = stato;
    }

    public Prenotazione(Utente utente, Corso corso, Docente docente, int orario, int giorno) {
        this.docente = docente;
        this.corso = corso;
        this.utente = utente;
        this.orario = orario;
        this.giorno = giorno;
        this.stato = 1;
    }

    public Prenotazione(Corso corso, Docente docente, int orario, int giorno, int stato, int id) {
        this.docente = docente;
        this.corso = corso;
        this.orario = orario;
        this.giorno = giorno;
        this.stato = stato;
        this.id = id;
    }

    public Prenotazione(Utente utente, Corso corso, Docente docente, int orario, int giorno, int stato, int id) {
        this.docente = docente;
        this.corso = corso;
        this.utente = utente;
        this.orario = orario;
        this.giorno = giorno;
        this.stato = stato;
        this.id = id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public int getStato() {
        return stato;
    }

    public void setStato(int stato) {
        this.stato = stato;
    }

    public Integer getId() {
        return id;
    }

    public Docente getDocente() {
        return docente;
    }

    public void setDocente(Docente docente) {
        this.docente = docente;
    }

    public Corso getCorso() {
        return corso;
    }

    public void setCorso(Corso corso) {
        this.corso = corso;
    }

    public Utente getUtente() {
        return utente;
    }

    public void setUtente(Utente utente) {
        this.utente = utente;
    }

    public String[] getAttributes() {
        return new String[] { "id", "utente", "insegnamento" };
    }

    public static String getNomeTabella() {
        return "tb_prenotazioni";
    }

    public static String getNomeTabellaExpired() {
        return "tb_prenotazioni_expired";
    }

    public static Giorno stringToGiorno(String s) {
        try {
            return Giorno.valueOf(s.toUpperCase());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Giorno.LUN;
    }

    public static Orario stringToOrario(String s) {
        Orario o = null;
        switch (s.toLowerCase()) {
            case "15-16": {
                o = Orario.O_15_16;
                break;
            }
            case "16-17": {
                o = Orario.O_16_17;
                break;
            }
            case "17-18": {
                o = Orario.O_17_18;
                break;
            }
            case "18-19": {
                o = Orario.O_18_19;
                break;
            }
        }
        return o;
    }
}
