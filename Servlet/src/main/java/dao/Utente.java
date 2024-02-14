package dao;

public class Utente {
    public static String getNomeTabella(){
        return "tb_utenti";
    }
    public enum role {
        GUEST,
        CLIENT,
        ADMIN;

        @Override
        public String toString() {
            return this.name().substring(0, 1).toUpperCase() + this.name().substring(1).toLowerCase();
        }
    }
    private Integer id = null;
    private String username;
    private String password;
    private role ruolo;

    public Utente(String username, String password){
        this.username = username;
        this.password = password;

        this.ruolo = role.GUEST;
    }
    public Utente(String username, String password, role ruolo){
        this.username = username;
        this.password = password;
        this.ruolo = ruolo;
    }
    public Utente(int id, String username, String password, role ruolo){
        this.username = username;
        this.password = password;
        this.id = id;
        this.ruolo = ruolo;
    }
    public Utente( int id, String username, String password ){
        this.username = username;
        this.password = password;
        this.ruolo = role.GUEST;
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public role getRuolo() {
        return ruolo;
    }

    public void setRuolo(role ruolo) {
        this.ruolo = ruolo;
    }
}
