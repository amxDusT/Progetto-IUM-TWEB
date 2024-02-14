package com.example.servizioripetizioniweb.admin;

import com.example.servizioripetizioniweb.result.PrenotazioneResult;
import com.example.servizioripetizioniweb.utils.ErrorCodes;
import com.example.servizioripetizioniweb.utils.Utils;
import com.google.gson.Gson;

import dao.Model;

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


@WebServlet(name = "Admin Prenotazione API", value = "/admin/prenotazione/api")
public class AdminPrenotazioneApi extends HttpServlet {
    private Model model;

    @Override
    public void init(ServletConfig config) throws ServletException {
        // TODO: read database info from web.xml and user Model
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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        PrenotazioneResult result = new PrenotazioneResult();
        final int DELETED = 3;
        if (!Utils.isAdmin(session)) {
            resp.setStatus(ErrorCodes.ERROR_NOT_AUTHORIZED.getErrNum());
            sendResponse(resp, result);
            return;
        }
        String cancel = req.getParameter("cancel");
        String active = req.getParameter("active");
        String prenotazione = req.getParameter("prenotazione");

        // trying to delete a booking
        if (cancel != null && !cancel.isEmpty() && !cancel.equals("0")) {
            if (!Utils.isInteger(prenotazione)) {
                resp.setStatus(ErrorCodes.ERROR_PRENOTAZIONE_ERROR.getErrNum());
                sendResponse(resp, result);
                return;
            }
            boolean hasRemoved = model.updatePrenotazione(Integer.parseInt(prenotazione), DELETED);
            if (hasRemoved)
                result.setSuccess("OK");
            else
                resp.setStatus(ErrorCodes.ERROR_UNKNOWN.getErrNum());
            sendResponse(resp, result);
            return;
        }
        result.setSuccess("OK", model.retrievePrenotazioni(active == null || !active.equals("0")));
        sendResponse(resp, result);
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