package dao;

/**
 * id @Int
 * nome @String
 * cognome @String
 */
public class Docente extends Tabella{
    private String nome;
    private String cognome;
    private Integer id = null;

    public static String getNomeTabella(){
        return "tb_docenti";
    }
    public String[] getAttributes(){
        return new String[]{"nome","cognome"};
    }
    public Docente(String nome, String cognome) {
        this.nome = nome;
        this.cognome = cognome;
    }
    public Docente(String nome, String cognome, int id) {
        this.nome = nome;
        this.cognome = cognome;
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCognome() {
        return cognome;
    }

    public void setCognome(String cognome) {
        this.cognome = cognome;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
