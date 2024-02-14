package dao;

/**
 * id @Int
 * nome @String
 */
public class Corso extends Tabella {
    /*
     * se si creano due corsi allo stesso tempo, avrebbero ID uguale.
     * attraverso questo index, no.
     * si riduce nell'add.
     */

    private String nome;
    private String descrizione;
    private Integer id;

    private Integer docentiNum;

    public String getNome() {
        return nome;
    }

    public Integer getId() {
        return id;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public Corso(String nome, String descrizione) {
        this.nome = nome;
        this.descrizione = descrizione;
    }

    public Corso(String nome, String descrizione, int id) {
        this.descrizione = descrizione;
        this.nome = nome;
        this.id = id;
    }

    public static String getNomeTabella() {
        return "tb_corsi";
    }

    public static String[] getAttributes() {
        return new String[] { "id", "nome", "descrizione" };
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public void setDocentiNum(Integer docentiNum) {
        this.docentiNum = docentiNum;
    }

    public int getDocentiNum() {
        return docentiNum;
    }

    public void setId(Integer id) {
        this.id = id;
    }
}
