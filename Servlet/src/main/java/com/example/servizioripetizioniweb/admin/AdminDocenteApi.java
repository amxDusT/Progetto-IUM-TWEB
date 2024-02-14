package com.example.servizioripetizioniweb.admin;

import com.example.servizioripetizioniweb.result.DocenteResult;
import com.example.servizioripetizioniweb.utils.ErrorCodes;
import com.example.servizioripetizioniweb.utils.Utils;
import com.google.gson.Gson;
import dao.Docente;
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
import java.util.Collections;

@WebServlet(name = "Admin Docente API", value = "/admin/docente/api")
public class AdminDocenteApi extends HttpServlet {
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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        DocenteResult result = new DocenteResult();

        if (!Utils.isAdmin(session)) {
            resp.setStatus(ErrorCodes.ERROR_NOT_AUTHORIZED.getErrNum());
            sendResponse(resp, result);
            return;
        }
        // create, read, update, delete
        String action = req.getParameter("action");
        if (action == null) {
            resp.setStatus(ErrorCodes.ERROR_UNKNOWN.getErrNum());
            sendResponse(resp, result);
            return;
        }
        String activeParam = req.getParameter("active");
        boolean active = activeParam == null || !activeParam.equals("0");

        switch (action.toLowerCase()) {
            case "read": {
                String docenteParam = req.getParameter("docente");
                if (docenteParam != null && !Utils.isInteger(docenteParam)) {
                    resp.setStatus(ErrorCodes.ERROR_DOCENTE_ERROR.getErrNum());
                    sendResponse(resp, result);
                    return;
                }
                if (docenteParam != null) {
                    result.setSuccess("OK", Collections.singletonList(model.getDocenteById(Integer.parseInt(docenteParam))));
                } else {
                    result.setSuccess("OK", model.retrieveDocenti(active));
                }
                sendResponse(resp, result);
                return;
            }
            case "create": {
                String nome = req.getParameter("nome");
                String cognome = req.getParameter("cognome");
                if (nome == null || cognome == null || nome.isEmpty() || cognome.isEmpty()) {
                    resp.setStatus(ErrorCodes.ERROR_DOCENTE_ERROR.getErrNum());
                    sendResponse(resp, result);
                    return;
                }
                Docente d = new Docente(nome, cognome);
                boolean hasAdded = model.addDocente(d);
                if (!hasAdded) {
                    resp.setStatus(ErrorCodes.ERROR_UNKNOWN.getErrNum());
                    sendResponse(resp, result);
                    return;
                }
                result.setSuccess("OK", Collections.singletonList(d));
                sendResponse(resp, result);
                return;
            }
            case "update": {
                String docenteParam = req.getParameter("docente");
                if (!Utils.isInteger(docenteParam)) {
                    resp.setStatus(ErrorCodes.ERROR_DOCENTE_ERROR.getErrNum());
                    sendResponse(resp, result);
                    return;
                }
                Boolean isActive = null;
                if (activeParam != null) {
                    isActive = active;
                }
                boolean hasUpdated = model.updateDocente(
                        Integer.parseInt(docenteParam),
                        req.getParameter("nome"),
                        req.getParameter("cognome"),
                        isActive
                );
                if (!hasUpdated)
                    resp.setStatus(ErrorCodes.ERROR_UNKNOWN.getErrNum());
                else
                    result.setSuccess("OK");
                sendResponse(resp, result);
                return;
            }
            case "delete": {
                String docenteParam = req.getParameter("docente");
                if (!Utils.isInteger(docenteParam)) {
                    resp.setStatus(ErrorCodes.ERROR_DOCENTE_ERROR.getErrNum());
                    sendResponse(resp, result);
                    return;
                }
                boolean hasRemoved = model.updateDocente(Integer.parseInt(docenteParam), null, null, false);
                if (!hasRemoved)
                    resp.setStatus(ErrorCodes.ERROR_UNKNOWN.getErrNum());
                else
                    result.setSuccess("OK");
                sendResponse(resp, result);
                return;
            }
            default: {
                resp.setStatus(ErrorCodes.ERROR_UNKNOWN.getErrNum());
                sendResponse(resp, result);
            }
        }
    }

    void sendResponse(HttpServletResponse response, DocenteResult result) throws IOException {
        PrintWriter out = response.getWriter();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String resJson = new Gson().toJson(result);

        out.print(resJson);
        out.flush();
    }

}