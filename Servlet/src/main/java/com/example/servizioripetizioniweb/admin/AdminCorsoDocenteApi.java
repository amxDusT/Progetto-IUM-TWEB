package com.example.servizioripetizioniweb.admin;

import com.example.servizioripetizioniweb.result.DocenteResult;
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

@WebServlet(name = "Admin Corso Docente API", value = "/admin/corsodocente/api")
public class AdminCorsoDocenteApi extends HttpServlet {
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
        String corsoParam = req.getParameter("corso");
        if (!Utils.isInteger(corsoParam)) {
            resp.setStatus(ErrorCodes.ERROR_CORSO_ERROR.getErrNum());
            sendResponse(resp, result);
            return;
        }
        String actionParam = req.getParameter("action");
        if(actionParam == null || actionParam.isEmpty()){
            actionParam = "get";
        }

        if(actionParam.equalsIgnoreCase("get")){
            result.setSuccess("OK",  model.getDocentiByCorsoId(Integer.parseInt(corsoParam)));
            sendResponse(resp, result);
            return;
        }

        String docenteParam = req.getParameter("docente");
        if (!Utils.isInteger(docenteParam)) {
            resp.setStatus(ErrorCodes.ERROR_DOCENTE_ERROR.getErrNum());
            sendResponse(resp, result);
            return;
        }
        boolean hasAdded;
        if(actionParam.equalsIgnoreCase("set"))
            hasAdded = model.addInsegnamento(Integer.parseInt(docenteParam), Integer.parseInt(corsoParam));
        else
            hasAdded = model.removeInsegnamento(Integer.parseInt(docenteParam), Integer.parseInt(corsoParam));
        if(hasAdded)
            result.setSuccess("OK");
        else
            resp.setStatus(ErrorCodes.ERROR_UNKNOWN.getErrNum());
        sendResponse(resp, result);
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