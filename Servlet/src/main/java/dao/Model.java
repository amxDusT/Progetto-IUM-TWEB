package dao;

import com.example.servizioripetizioniweb.utils.PrenotazioneException;
import org.apache.commons.codec.digest.DigestUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
//import org.apache.commons.codec.digest.DigestUtils;

public class Model {
    private String url1;
    private String user;
    private String password;
    private static Model model = null;

    static {
        registerDriver();
    }

    public Model(String url, String user, String password) {
        this.url1 = url;
        this.user = user;
        this.password = password;
        model = this;
    }

    public static Model getInstance() {
        return model;
    }

    public static void registerDriver() {
        try {
            DriverManager.registerDriver(new com.mysql.jdbc.Driver());
            System.out.println("Driver correttamente registrato");
        } catch (SQLException e) {
            System.out.println("Errore: " + e.getMessage());
        }
    }

    public synchronized Connection setConnection() throws SQLException {
        return DriverManager.getConnection(url1, user, password);
    }

    public void closeConnection(Connection conn) {
        try {
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public void closeStatement(Statement st) {
        try {
            if (st != null) {
                st.close();
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public void closeResultSet(ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    /**
     * Add a new prenotazione in the active prenotazioni.
     *
     * @param utente  ID utente
     * @param corso   ID corso
     * @param docente ID docente
     * @param g       giorno num
     * @param o       orario num
     * @return new prenotazione with ID if inserted. error otherwise
     * @throws PrenotazioneException if utente and corso are already in an active
     *                               prenotazione.
     *                               or if utente has already an active prenotazione
     *                               on the same day and hour.
     *                               or if docente has already an active
     *                               prenotazione on the same day and hour.
     */
    public Prenotazione addPrenotazione(int utente, int corso, int docente, int g, int o) throws PrenotazioneException {
        final String add = "INSERT INTO " + Prenotazione.getNomeTabella()
                + "(`utente`,`corso`,`docente`,`giorno`,`orario`) VALUES (?,?,?,?,?);";
        PreparedStatement ps = null;
        ResultSet rs = null;
        int prenotazioneId = 0;
        Connection conn = null;
        try {
            conn = setConnection();
            ps = conn.prepareStatement(add, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, utente);
            ps.setInt(2, corso);
            ps.setInt(3, docente);
            ps.setInt(4, g);
            ps.setInt(5, o);

            if (ps.executeUpdate() == 1) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    prenotazioneId = rs.getInt(1);
                }
            }
            if (prenotazioneId != 0) {
                return getPrenotazioneById(prenotazioneId, true, conn);
            }

            return null;
        } catch (SQLException e) {
            /*
             * utente_orario
             * docente_orario
             * utente_corso
             */
            if (e.getMessage().contains("utente_orario")) {
                throw new PrenotazioneException(Prenotazione.Errors.UTENTE_ORARIO, e.getMessage(), e.getCause());
            } else if (e.getMessage().contains("docente_orario")) {
                throw new PrenotazioneException(Prenotazione.Errors.DOCENTE_ORARIO, e.getMessage(), e.getCause());
            } else if (e.getMessage().contains("utente_corso")) {
                throw new PrenotazioneException(Prenotazione.Errors.UTENTE_CORSO, "utente_corso", e.getCause());
            } else
                throw new RuntimeException(e);
        } finally {
            closeResultSet(rs);
            closeStatement(ps);
            closeConnection(conn);
        }
    }

    private synchronized Prenotazione getPrenotazioneById(int id, boolean isActive, Connection conn) {
        ResultSet rs = null;
        PreparedStatement ps = null;
        final String sql = "SELECT `p`.`id` as `prenotazione_id`, `p`.`giorno`, `p`.`orario`, " +
                "`c`.`id` as `corso_id`, `d`.`id` as `docente_id`, `c`.`nome` AS corso_nome, `d`.`nome` as " +
                "docente_nome, `c`.*, `d`.* " + (isActive ? "" : ",`p`.`stato`") + " FROM `"
                + (isActive ? Prenotazione.getNomeTabella() : Prenotazione.getNomeTabellaExpired()) +
                "` `p` INNER JOIN `tb_corsi` `c` ON `p`.`corso" +
                "` = `c`.`id` INNER JOIN `tb_docenti` `d` ON `p`.`docente` = `d`.`id` WHERE `p`.`id` = ?;";

        try {
            // supposing we already have a connection
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            rs = ps.executeQuery();
            if (rs.next()) {
                int orario = rs.getInt("orario");
                int giorno = rs.getInt("giorno");
                int stato = 1;
                if (!isActive)
                    stato = rs.getInt("stato");

                int p_id = rs.getInt("prenotazione_id");
                String corsoNome = rs.getString("corso_nome");
                String descrizione = rs.getString("descrizione");
                int corsoId = rs.getInt("corso_id");
                String docenteNome = rs.getString("docente_nome");
                String cognome = rs.getString("cognome");
                int docenteId = rs.getInt("docente_id");
                return new Prenotazione(
                        new Corso(
                                corsoNome,
                                descrizione,
                                corsoId),
                        new Docente(
                                docenteNome,
                                cognome,
                                docenteId),
                        orario,
                        giorno,
                        isActive ? 1 : stato,
                        p_id);
            }
            return null;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            closeResultSet(rs);
            closeStatement(ps);
        }
    }

    /**
     * Gives a list of all the prenotazioni (active and finished) for a certain
     * user.
     *
     * @param u user who has the prenotazioni
     * @return list of the prenotazini
     */
    public synchronized ArrayList<Prenotazione> getPrenotazioniUtente(Utente u) {
        ArrayList<Prenotazione> prenotazioni = new ArrayList<>();
        ResultSet rs = null;
        PreparedStatement ps = null;
        final String sql = "SELECT `p`.`id` as `prenotazione_id`, `p`.`giorno`, `p`.`orario`, 1 as `stato`, " +
                "    `c`.`id` as `corso_id`, `d`.`id` as `docente_id`, `c`.`nome` AS corso_nome, `d`.`nome` as docente_nome,"
                +
                "    `d`.*, `c`.*" +
                "FROM `" + Prenotazione.getNomeTabella() + "` `p`" +
                "INNER JOIN `tb_corsi` `c` ON `p`.`corso` = `c`.`id`" +
                "INNER JOIN `tb_docenti` `d` ON `p`.`docente` = `d`.`id`" +
                "WHERE `p`.`utente` = ?\n" +
                "UNION \n" +
                "SELECT `p`.`id`, `p`.`giorno`, `p`.`orario`, `p`.`stato`, " +
                "    `c`.`id`, `d`.`id`, `c`.`nome`, `d`.`nome`, `d`.*, `c`.*" +
                "FROM `" + Prenotazione.getNomeTabellaExpired() + "` `p`" +
                "INNER JOIN `tb_corsi` `c` ON `p`.`corso` = `c`.`id`" +
                "INNER JOIN `tb_docenti` `d` ON `p`.`docente` = `d`.`id`" +
                "WHERE `p`.`utente` = ?;";
        /*
         * final String sql =
         * "SELECT `p`.`id` as `prenotazione_id`, `p`.`giorno`, `p`.`orario`, `p`.`stato`, "
         * +
         * "`c`.`id` as `corso_id`, `d`.`id` as `docente_id`, `c`.`nome` AS corso_nome, `d`.`nome` as "
         * +
         * "docente_nome, `c`.*, `d`.* FROM `tb_prenotazioni` `p` INNER JOIN `tb_corsi` `c` ON `p`.`corso"
         * +
         * "` = `c`.`id` INNER JOIN `tb_docenti` `d` ON `p`.`docente` = `d`.`id` WHERE `p`.`utente` = ?;"
         * ;
         */
        Connection conn = null;
        try {

            conn = setConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, u.getId());
            ps.setInt(2, u.getId());

            rs = ps.executeQuery();
            while (rs.next()) {
                int orario = rs.getInt("orario");
                int giorno = rs.getInt("giorno");
                int stato = rs.getInt("stato");
                int p_id = rs.getInt("prenotazione_id");
                String corsoNome = rs.getString("corso_nome");
                String descrizione = rs.getString("descrizione");
                int corsoId = rs.getInt("corso_id");
                String docenteNome = rs.getString("docente_nome");
                String cognome = rs.getString("cognome");
                int docenteId = rs.getInt("docente_id");
                Corso c = new Corso(
                        corsoNome,
                        descrizione,
                        corsoId);
                Docente d = new Docente(
                        docenteNome,
                        cognome,
                        docenteId);
                Prenotazione p = new Prenotazione(
                        c,
                        d,
                        orario,
                        giorno,
                        stato,
                        p_id);
                prenotazioni.add(p);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Utente: " + u.getId() + "\n" + e);
        } finally {
            closeResultSet(rs);
            closeStatement(ps);
            closeConnection(conn);
        }
        // final String sql = "SELECT p.id, p.giorno, p.orario, p.stato, c.* as corso,
        // d.* as docente" +
        return prenotazioni;
    }

    /**
     * adds a new corso in the list of corsi.
     *
     * @param c corso do add
     * @return if corso was added or not.
     */
    public boolean addCorso(Corso c) {
        try {
            final String add = "INSERT INTO " + Corso.getNomeTabella() + "(`nome`,`descrizione`) VALUES(?,?);";

            // final String add = "INSERT INTO "+ Corso.getNomeTabella() +"(`nome`)
            // VALUES(?,?);";
            corsoSql(c, add, 0);
        } catch (SQLException e) {
            System.out.println("Errore: " + e.getMessage());
            return false;
        }
        return true;
    }

    public boolean updateCorso(int corsoId, String nome, String descrizione, Boolean isActive) {
        String sql = "UPDATE " + Corso.getNomeTabella() + " SET ";
        boolean hasAdded = false;
        boolean result = false;
        if (nome != null) {
            hasAdded = true;
            sql = sql.concat("`nome` = ?, ");
        }
        if (descrizione != null) {
            hasAdded = true;
            sql = sql.concat("`descrizione` = ?, ");
        }
        if (isActive != null) {
            hasAdded = true;
            sql = sql.concat("`active` = ?, ");
        }

        if (!hasAdded)
            return false;
        sql = sql.substring(0, sql.length() - 2);
        sql = sql.concat(" WHERE `id` = ?;");
        System.out.println(sql);
        PreparedStatement ps = null;
        Connection conn = null;
        try {
            conn = setConnection();
            ps = conn.prepareStatement(sql);
            int index = 1;
            if (nome != null) {
                ps.setString(index, nome);
                index++;
            }
            if (descrizione != null) {
                ps.setString(index, descrizione);
                index++;
            }
            if (isActive != null) {
                ps.setInt(index, isActive ? 1 : 0);
                index++;
                if (!isActive) {
                    removeAllFromCorso(corsoId);
                }

            }
            ps.setInt(index, corsoId);
            if (ps.executeUpdate() == 1) {
                result = true;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            closeStatement(ps);
            closeConnection(conn);
        }
        return result;
    }

    private void removeAllFromDocente(int docenteId) {
        final int DELETED = 3;
        ArrayList<Corso> corsi = getCorsiByDocenteId(docenteId);
        corsi.forEach(corso -> removeInsegnamento(docenteId, corso.getId()));
        ArrayList<Prenotazione> prenotazioni = retrievePrenotazioni(true);
        for (Prenotazione prenotazione : prenotazioni) {
            if( prenotazione.getDocente().getId() == docenteId){
                updatePrenotazione(prenotazione.getId(), DELETED);
            }
        }
    }

    private void removeAllFromCorso(int corsoId) {
        final int DELETED = 3;
        ArrayList<Docente> docenti = getDocentiByCorsoId(corsoId);

        docenti.forEach(docente -> removeInsegnamento(docente.getId(), corsoId));

        // move all bookings with that corso to cancelled
        ArrayList<Prenotazione> prenotazioni = retrievePrenotazioni(true);
        for (Prenotazione prenotazione : prenotazioni) {
            if (prenotazione.getCorso().getId() == corsoId) {
                updatePrenotazione(prenotazione.getId(), DELETED);
            }
        }
    }

    private void corsoSql(Corso c, String add, int type) throws SQLException {
        Connection conn = setConnection();
        // c.getClass().getDeclaredMethod()
        assert c != null;
        PreparedStatement st = conn.prepareStatement(add, Statement.RETURN_GENERATED_KEYS);
        // ResultSet s = st.executeQuery();
        if (type == 0) {
            // st.setInt(1, c.getId());
            st.setString(1, c.getNome());
            st.setString(2, c.getDescrizione());
        } else
            st.setInt(1, c.getId());
        if (st.executeUpdate() == 1 && type == 0) {
            ResultSet gk = st.getGeneratedKeys();
            if (gk.next())
                c.setId(gk.getInt(1));
            gk.close();
        }
        closeStatement(st);
        closeConnection(conn);
    }

    public boolean updateDocente(int docenteId, String nome, String cognome, Boolean active) {
        String sql = "UPDATE " + Docente.getNomeTabella() + " SET ";
        boolean hasAdded = false;
        boolean result = false;
        if (nome != null) {
            hasAdded = true;
            sql = sql.concat("`nome` = ?, ");
        }
        if (cognome != null) {
            hasAdded = true;
            sql = sql.concat("`cognome` = ?, ");
        }
        if (active != null) {
            hasAdded = true;
            sql = sql.concat("`active` = ?, ");
        }

        if (!hasAdded)
            return false;
        sql = sql.substring(0, sql.length() - 2);
        sql = sql.concat(" WHERE `id` = ?;");
        System.out.println(sql);
        PreparedStatement ps = null;
        Connection conn = null;
        try {
            conn = setConnection();
            ps = conn.prepareStatement(sql);
            int index = 1;
            if (nome != null) {
                ps.setString(index, nome);
                index++;
            }
            if (cognome != null) {
                ps.setString(index, cognome);
                index++;
            }
            if (active != null) {
                ps.setInt(index, active ? 1 : 0);
                index++;
                if(!active){
                    removeAllFromDocente(docenteId);
                }
            }
            ps.setInt(index, docenteId);
            if (ps.executeUpdate() == 1) {
                result = true;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            closeStatement(ps);
            closeConnection(conn);
        }
        return result;
    }

    public boolean addDocente(Docente d) {
        final String add = "INSERT INTO " + Docente.getNomeTabella() + "(`nome`,`cognome`) VALUES(?,?);";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet generatedKeys = null;
        boolean result = false;
        try {
            conn = setConnection();
            ps = conn.prepareStatement(add, Statement.RETURN_GENERATED_KEYS);

            ps.setString(1, d.getNome());
            ps.setString(2, d.getCognome());

            if (ps.executeUpdate() == 1) {
                generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    d.setId(generatedKeys.getInt(1));
                    result = true;
                }
            }
        } catch (SQLException e) {
            System.out.println("Errore: " + e.getMessage());
            return false;
        } finally {
            closeResultSet(generatedKeys);
            closeStatement(ps);
            closeConnection(conn);
        }
        return result;
    }

    /**
     * Prenotazione attiva is moved to expired, keeping same ID and changing stato.
     *
     * @param id    ID prenotazione
     * @param stato stato num. (1 = active, 2 = done, 3 deleted)
     * @return true if success, false otherwise.
     */
    // add the prenotazione to expired table and remove it from active prenotazione
    // table.
    public boolean updatePrenotazione(int id, int stato) {

        if (stato == 1)
            return false;
        final String sql = "INSERT INTO `" + Prenotazione.getNomeTabellaExpired() + "` SELECT *, ? as `stato`" +
                "FROM " + Prenotazione.getNomeTabella() + " WHERE `id` = ?; ";
        final String sql2 = "DELETE FROM `" + Prenotazione.getNomeTabella() + "` WHERE `id`=?;";
        PreparedStatement ps = null;
        PreparedStatement ps2 = null;
        Connection conn = null;
        try {
            conn = setConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, stato);
            ps.setInt(2, id);
            // ps.setInt(3, id);
            int updates = ps.executeUpdate();
            System.out.println(updates);
            if (updates == 1) {
                ps2 = conn.prepareStatement(sql2);
                ps2.setInt(1, id);
                ps2.executeUpdate();
            }

            boolean result = updates == 1;
            return result;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            closeStatement(ps);
            closeStatement(ps2);
            closeConnection(conn);
        }
    }

    public boolean removeInsegnamento(int docenteId, int corsoId) {
        final String sql = "DELETE FROM `" + Insegnamento.getNomeTabella() + "` WHERE corso = ? AND docente = ?;";
        boolean result = false;
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = setConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, corsoId);
            ps.setInt(2, docenteId);
            result = ps.executeUpdate() == 1;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        } finally {
            closeStatement(ps);
            closeConnection(conn);
        }
        return result;
    }

    public boolean addInsegnamento(int docenteId, int corsoId) {
        final String s = "INSERT INTO `" + Insegnamento.getNomeTabella() + "`(`corso`,`docente`) VALUES(?,?);";
        boolean result = false;
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = setConnection();
            ps = conn.prepareStatement(s);

            ps.setInt(1, corsoId);
            ps.setInt(2, docenteId);

            if (ps.executeUpdate() == 1) {
                result = true;
            }
            ps.close();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        } finally {
            closeStatement(ps);
            closeConnection(conn);
        }
        return result;
    }

    /**
     * @param orderColumn  column to orderBy
     * @param asc          true if ascending. false descending.
     * @param searchColumn column that is being looked for
     * @param startOrEnd   String to confront
     * @param start        true if to check from the start of the string. false
     *                     otherwise
     * @return
     */
    public synchronized ArrayList<Corso> retrieveCorsi(String orderColumn, boolean asc, String searchColumn,
                                                       String startOrEnd, boolean start, boolean active) {
        ArrayList<Corso> listaCorsi = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;

        if (orderColumn != null && !orderColumn.isEmpty()
                && Arrays.stream(Corso.getAttributes()).noneMatch((str) -> str.equals(orderColumn.toLowerCase()))) {
            throw new IllegalArgumentException("order column does not exist");
        }
        boolean hasSearch = searchColumn != null && !searchColumn.isEmpty() && startOrEnd != null
                && !startOrEnd.isEmpty();
        if (hasSearch
                && Arrays.stream(Corso.getAttributes()).noneMatch((str) -> str.equals(searchColumn.toLowerCase()))) {
            throw new IllegalArgumentException("search column does not exist");
        }
        // by default, orderColumn by ID desc ;
        String orderBy = orderColumn == null || orderColumn.isEmpty() ? "id" : orderColumn;
        String ascDesc = asc ? "ASC" : "DESC";

        String sql = "SELECT * FROM `" + Corso.getNomeTabella() + "` WHERE `active`=? ";
        if (hasSearch) {
            sql = sql.concat("AND `" + searchColumn + "` LIKE ? ");
        }
        sql = sql.concat("ORDER BY `" + orderBy + "` " + ascDesc);
        // System.out.println(sql);
        Connection conn = null;
        try {
            conn = setConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, active ? 1 : 0);
            if (hasSearch) {
                // System.out.println("here");
                ps.setString(2, (start ? startOrEnd + "%" : "%" + startOrEnd));
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                listaCorsi.add(getCorsoFromQuery(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            closeResultSet(rs);
            closeStatement(ps);
            closeConnection(conn);
        }
        return listaCorsi;
    }

    private synchronized Corso getCorsoFromQuery(ResultSet rs) throws SQLException {
        return new Corso(
                rs.getString("nome"),
                rs.getString("descrizione"),
                rs.getInt("id"));
    }

    public ArrayList<Corso> retrieveCorsi(boolean active) {
        return retrieveCorsi("id", false, null, null, false, active);
    }

    public ArrayList<Prenotazione> retrievePrenotazioni(boolean active) {
        ArrayList<Prenotazione> listaPrenotazioni = new ArrayList<>();
        final String sql;
        final String statoSelect;
        final String tabella;
        if (active) {
            statoSelect = "1 as `stato`";
            tabella = Prenotazione.getNomeTabella();
        } else {
            statoSelect = "`p`.`stato`";
            tabella = Prenotazione.getNomeTabellaExpired();
        }
        /*
         * SELECT `p`.`id` as `prenotazione_id`, `p`.`giorno`, `p`.`orario`, 1 as stato,
         * `u`.`id` as `utente_id`, `u`.`username`,
         * `c`.`id` as `corso_id`, `d`.`id` as `docente_id`, `c`.`nome` AS corso_nome,
         * `d`.`nome` as docente_nome,
         * `d`.*, `c`.*
         * FROM `tb_prenotazioni` `p`
         * INNER JOIN `tb_corsi` `c` ON `p`.`corso` = `c`.`id`
         * INNER JOIN `tb_docenti` `d` ON `p`.`docente` = `d`.`id`
         * INNER JOIN `tb_utenti` `u` ON `p`.`utente` = `u`.`id`
         *
         */
        sql = "SELECT `p`.`id` as `prenotazione_id`, `p`.`giorno`, `p`.`orario`," + statoSelect + ", " +
                "    `u`.`id` as `utente_id`, `u`.`username`, " +
                "    `c`.`id` as `corso_id`, `d`.`id` as `docente_id`, `c`.`nome` AS corso_nome, `d`.`nome` as docente_nome,"
                +
                "    `d`.*, `c`.*" +
                "FROM `" + tabella + "` `p`" +
                "INNER JOIN `tb_utenti` `u` ON `p`.`utente` = `u`.`id`" +
                "INNER JOIN `tb_corsi` `c` ON `p`.`corso` = `c`.`id`" +
                "INNER JOIN `tb_docenti` `d` ON `p`.`docente` = `d`.`id`;";
        Statement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        try {
            conn = setConnection();
            ps = conn.createStatement();
            rs = ps.executeQuery(sql);
            while (rs.next()) {
                int utente_id = rs.getInt("utente_id");
                String utente_username = rs.getString("username");
                int orario = rs.getInt("orario");
                int giorno = rs.getInt("giorno");
                int stato = rs.getInt("stato");
                int p_id = rs.getInt("prenotazione_id");
                String corsoNome = rs.getString("corso_nome");
                String descrizione = rs.getString("descrizione");
                int corsoId = rs.getInt("corso_id");
                String docenteNome = rs.getString("docente_nome");
                String cognome = rs.getString("cognome");
                int docenteId = rs.getInt("docente_id");
                Utente u = new Utente(utente_id, utente_username, null);
                u.setRuolo(null);
                Corso c = new Corso(
                        corsoNome,
                        descrizione,
                        corsoId);
                Docente d = new Docente(
                        docenteNome,
                        cognome,
                        docenteId);
                Prenotazione p = new Prenotazione(
                        u,
                        c,
                        d,
                        orario,
                        giorno,
                        stato,
                        p_id);
                listaPrenotazioni.add(p);
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResultSet(rs);
            closeStatement(ps);
            closeConnection(conn);
        }
        return listaPrenotazioni;
    }

    private synchronized Docente getDocenteFromQuery(ResultSet rs) throws SQLException {
        return new Docente(
                rs.getString("nome"),
                rs.getString("cognome"),
                rs.getInt("id"));
    }

    public ArrayList<Docente> retrieveDocenti(boolean active) {
        ArrayList<Docente> listaDocenti = new ArrayList<>();
        final String sql = "SELECT * FROM `" + Docente.getNomeTabella() + "` WHERE `active` = ?;";
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        try {
            conn = setConnection();

            ps = conn.prepareStatement(sql);
            ps.setInt(1, active ? 1 : 0);
            rs = ps.executeQuery();
            while (rs.next()) {
                listaDocenti.add(getDocenteFromQuery(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            closeResultSet(rs);
            closeStatement(ps);
            closeConnection(conn);
        }
        return listaDocenti;
    }

    public Docente getDocenteById(int id) {
        Docente d = null;
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = setConnection();
            ps = conn.prepareStatement("SELECT * FROM " + Docente.getNomeTabella() + " WHERE id=?;");
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();
            if (rs.next())
                d = new Docente(rs.getString("nome"), rs.getString("cognome"), rs.getInt("id"));
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            closeStatement(ps);
            closeConnection(conn);
        }
        return d;
    }

    public Corso getCorsoById(int id) {
        Corso c = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = setConnection();
            ps = conn.prepareStatement("SELECT * FROM " + Corso.getNomeTabella() + " WHERE id=?;");
            ps.setInt(1, id);

            rs = ps.executeQuery();
            if (rs.next())
                c = new Corso(rs.getString("nome"), rs.getString("descrizione"), rs.getInt("id"));

        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            closeResultSet(rs);
            closeStatement(ps);
            closeConnection(conn);
        }
        return c;
    }

    /**
     * get the hours of the docente when he's busy with prenotazioni active.
     *
     * @param docenteId ID docente
     * @param weekDay   Giorno num
     * @return list of hours when it's free, for that day.
     */
    public ArrayList<Integer> getPrenotazioniDocente(Integer docenteId, int weekDay) {
        ArrayList<Integer> listaOrari = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        try {
            conn = setConnection();
            ps = conn.prepareStatement(
                    "SELECT `orario` FROM " + Prenotazione.getNomeTabella() + " WHERE docente=? AND giorno=?;");
            ps.setInt(1, docenteId);
            ps.setInt(2, weekDay);
            rs = ps.executeQuery();
            while (rs.next()) {
                listaOrari.add(rs.getInt("orario"));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            closeResultSet(rs);
            closeStatement(ps);
            closeConnection(conn);
        }
        return listaOrari;
    }

    /**
     * returns Utente if username and pw match a user
     *
     * @param username username
     * @param pw       password
     * @return
     */
    public Utente getUtenteByLogin(String username, String pw) {
        Utente u = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        try {
            conn = setConnection();
            ps = conn.prepareStatement("SELECT * FROM `" + Utente.getNomeTabella() + "`" +
                    "WHERE username=? AND password=?");
            ps.setString(1, username);
            ps.setString(2, saltPassword(pw));
            rs = ps.executeQuery();
            if (rs.next()) {
                u = getUtenteFromQuery(rs);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return null;
        } finally {
            closeResultSet(rs);
            closeStatement(ps);
            closeConnection(conn);
        }
        return u;
    }

    private Utente getUtenteFromQuery(ResultSet rs) throws SQLException {
        return new Utente(rs.getInt("id"), rs.getString("username"),
                rs.getString("password"), Utente.role.valueOf(rs.getString("ruolo").toUpperCase()));
    }

    // password hash => TODO: change to sha
    private static String saltPassword(String text) {
        /// return text;
        return DigestUtils.sha256Hex(text);
        // return DigestUtils.md5Hex(text);
    }

    public ArrayList<Corso> getCorsiByDocenteId(int id) {
        final String sql = "SELECT `c`.* FROM `" + Corso.getNomeTabella() + "` as `c`, `"
                + Insegnamento.getNomeTabella() + "`" +
                "as `i` WHERE `c`.id = `i`.corso AND `i`.docente = ?;";

        ArrayList<Corso> corsi = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet result = null;
        Connection conn = null;
        try {
            conn = setConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            result = ps.executeQuery();
            while (result.next()) {
                corsi.add(getCorsoFromQuery(result));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            closeResultSet(result);
            closeStatement(ps);
            closeConnection(conn);
        }
        return corsi;
    }

    /**
     * get docenti that teach the wanted corso
     *
     * @param id ID corso
     * @return list of docenti that teach on that corso
     */
    public ArrayList<Docente> getDocentiByCorsoId(int id) {
        final String sql = "SELECT `d`.* FROM `" + Docente.getNomeTabella() + "` as `d`, `"
                + Insegnamento.getNomeTabella() + "`" +
                "as `i` WHERE `d`.id = `i`.docente AND `i`.corso = ? AND `d`.`active` = 1;";
        // System.out.println(sql);
        ArrayList<Docente> docenti = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet result = null;
        Connection conn = null;
        try {
            conn = setConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            result = ps.executeQuery();
            while (result.next()) {
                docenti.add(getDocenteFromQuery(result));
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            closeResultSet(result);
            closeStatement(ps);
            closeConnection(conn);
        }
        return docenti;
    }
}
