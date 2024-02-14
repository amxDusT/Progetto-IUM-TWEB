package com.example.servizioripetizioniweb;

import com.example.servizioripetizioniweb.result.PrenotazioneResult;
import com.example.servizioripetizioniweb.utils.ErrorCodes;
import com.example.servizioripetizioniweb.utils.PrenotazioneException;
import com.example.servizioripetizioniweb.utils.Utils;
import com.google.gson.Gson;
import dao.Model;
import dao.Prenotazione;
import dao.Utente;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;

@WebServlet(name = "Prenotazione API", value = "/prenotazione/api")
public class PrenotazioneApi extends HttpServlet {
    private Model model;

    @Override
    public void init(ServletConfig config) throws ServletException {
        //TODO: read database info from web.xml and user Model
        super.init(config);
        ServletContext ctx = config.getServletContext();
        String url = ctx.getInitParameter("url");
        String user = ctx.getInitParameter("user");
        String password = ctx.getInitParameter("password");
        if (Model.getInstance() == null)
            model = new Model(url, user, password);
        else
            model = Model.getInstance();
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        PrenotazioneResult result = new PrenotazioneResult();

        if (!Utils.isLoggedIn(session)) {
            result.setError("Not logged in");
            sendResponse(response, result);
            return;
        }
        if(Utils.getUtente(session).getRuolo() == Utente.role.GUEST) {
            result.setError("Not authorized");
            response.setStatus(ErrorCodes.ERROR_NOT_AUTHORIZED.getErrNum());
            sendResponse(response, result);
            return;
        }
        String corsoParam = request.getParameter("corso");
        String docenteParam = request.getParameter("docente");
        String orarioParam = request.getParameter("orario");
        String giornoParam = request.getParameter("giorno");
        String statoParam = request.getParameter("stato");
        String actionParam = request.getParameter("action");
        String idParam = request.getParameter("id");
        if (actionParam == null || actionParam.equals("add")) {
            int orario = Utils.isInteger(orarioParam) ? Integer.parseInt(orarioParam) : 0;
            int giorno = Utils.isInteger(giornoParam) ? Integer.parseInt(giornoParam) : 0;

            if (giorno <= 0 || giorno > 5) {
                response.setStatus(ErrorCodes.ERROR_DAY_ERROR.getErrNum());
                result.setError("Bad day provided");
                sendResponse(response, result);
                return;
            } else if (orario <= 0 || orario > 4) {
                response.setStatus(ErrorCodes.ERROR_HOUR_ERROR.getErrNum());
                result.setError("Bad hour provided");
                sendResponse(response, result);
                return;
            } else if (!Utils.isInteger(docenteParam)) {
                response.setStatus(ErrorCodes.ERROR_DOCENTE_ERROR.getErrNum());
                result.setError("Bad docente provided");
                sendResponse(response, result);
                return;
            } else if (!Utils.isInteger(corsoParam)) {
                response.setStatus(ErrorCodes.ERROR_CORSO_ERROR.getErrNum());
                result.setError("Bad corso provided");
                sendResponse(response, result);
                return;
            }
            Prenotazione p = null;
            try {
                p = model.addPrenotazione(
                        Utils.getUtente(session).getId(),
                        Integer.parseInt(corsoParam),
                        Integer.parseInt(docenteParam),
                        giorno,
                        orario);
            } catch (PrenotazioneException e) {
                switch(e.getErrCode()){
                    case UTENTE_CORSO:
                        response.setStatus(ErrorCodes.ERROR_CORSO_ACTIVE.getErrNum());
                        break;
                    case UTENTE_ORARIO:
                        response.setStatus(ErrorCodes.ERROR_ORARIO_ACTIVE.getErrNum());
                        break;
                    case DOCENTE_ORARIO:
                        response.setStatus(ErrorCodes.ERROR_DOCENTE_ACTIVE.getErrNum());
                }
                return;
            }
            if (p!=null) {
                result.setSuccess("OK", Collections.singletonList(p));
            } else {
                response.setStatus(ErrorCodes.ERROR_UNKNOWN.getErrNum());
                result.setError("Error. Try Again later.");
            }
        } else if (actionParam.equals("get")) {
            Utente u = Utils.getUtente(session);
            ArrayList<Prenotazione> listPrenotazioni = model.getPrenotazioniUtente(u);
            listPrenotazioni.forEach(prenotazione -> prenotazione.setUtente(null));
            result.setSuccess("OK", listPrenotazioni);
        } else if (actionParam.equals("update")) {
            int id = Utils.isInteger(idParam) ? Integer.parseInt(idParam) : 0;
            int stato = Utils.isInteger(statoParam) ? Integer.parseInt(statoParam) : 0;

            if (id <= 0) {
                response.setStatus(ErrorCodes.ERROR_PRENOTAZIONE_ERROR.getErrNum());
                result.setError("Bad ID provided " + id);
                sendResponse(response, result);
                return;
            }else if (stato <= 1 || stato > 3) {
                response.setStatus(ErrorCodes.ERROR_STATO_ERROR.getErrNum());
                result.setError("Bad stato provided");
                sendResponse(response, result);
                return;
            }
            if(model.updatePrenotazione(id, stato)){
                result.setSuccess("OK");
            }else{
                response.setStatus(ErrorCodes.ERROR_UNKNOWN.getErrNum());
                result.setError("Server Error. Try again.");
            }
        }
        sendResponse(response, result);
    }

    void sendResponse(HttpServletResponse response, PrenotazioneResult result) throws IOException {
        PrintWriter out = response.getWriter();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String resJson = new Gson().toJson(result);

        out.print(resJson);
        out.flush();
    }
}
