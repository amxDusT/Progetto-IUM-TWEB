package dao;


/**
 * id @Int
 * corso @Int
 * docente @Int
 */
public class Insegnamento extends Tabella{
    private Corso corso;
    private Docente docente;
    private Integer id;
  


    //protected static HashMap<Corso, Docente> map = new HashMap<>();
    public static String getNomeTabella(){
        return "tb_insegnamenti";
    }
    @Override
    public String toString() {
        return "Insegnamento{" +
                "corso='" + corso.toString() + '\'' +
                ", docente=" + docente.toString() +
                '}';
    }

    public Corso getCorso() {
        return corso;
    }

    public void setCorso(Corso corso) {
        this.corso = corso;
    }

    public Docente getDocente() {
        return docente;
    }

    public void setDocente(Docente docente) {
        this.docente = docente;
    }
    public void setId(int id){
        this.id = id;
    }
    public int getId(){
        return this.id;
    }
    public Insegnamento(Corso c, Docente d) {
        this.corso = c;
        this.docente = d;
    }
    public Insegnamento(int id, Corso c, Docente d) {
        this.id = id;
        this.corso = c;
        this.docente = d;
    }

    public String[] getAttributes(){
        return new String[]{"nome","docente"};
    }
}
