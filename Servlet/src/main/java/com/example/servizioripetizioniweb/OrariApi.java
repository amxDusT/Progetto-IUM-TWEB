package com.example.servizioripetizioniweb;

import com.example.servizioripetizioniweb.result.OrarioResult;
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

@WebServlet(name = "Orari API", value = "/orari/api")
public class OrariApi extends HttpServlet {
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
        OrarioResult result = new OrarioResult();

        if(!Utils.isLoggedIn(session)){
            response.setStatus(ErrorCodes.ERROR_LOGIN_NOT_LOGGED.getErrNum());
            result.setError("Not logged in");
            sendResponse(response, result);
            return;
        }

        String docenteParam = request.getParameter("docente");
        String giornoParam = request.getParameter("giorno");
        int weekDay = Utils.isInteger(giornoParam)? Integer.parseInt(giornoParam):0;
        if(weekDay<=0 || weekDay>5){
            response.setStatus(ErrorCodes.ERROR_DAY_ERROR.getErrNum());
            result.setError("Bad day provided");
            sendResponse(response, result);
            return;
        }else if(!Utils.isInteger(docenteParam)){
            response.setStatus(ErrorCodes.ERROR_DOCENTE_ERROR.getErrNum());
            result.setError("Bad docente provided");
            sendResponse(response, result);
            return;
        }

        result.setSuccess("OK", model.getPrenotazioniDocente(Integer.parseInt(docenteParam), Integer.parseInt(giornoParam)));
        sendResponse(response, result);
    }
    void sendResponse(HttpServletResponse response, OrarioResult result) throws IOException {
        PrintWriter out = response.getWriter();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String resJson = new Gson().toJson(result);

        out.print(resJson);
        out.flush();
    }
}
