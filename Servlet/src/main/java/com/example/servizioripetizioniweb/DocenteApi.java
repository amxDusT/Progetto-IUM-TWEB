package com.example.servizioripetizioniweb;

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

@WebServlet(name = "Docente API", value = "/docente/api")
public class DocenteApi extends HttpServlet {
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


    /**
     *
     * param corso = 0-X, all
     * @param request
     * @param response
     */
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        DocenteResult result = new DocenteResult();

        if(!Utils.isLoggedIn(session)){
            response.setStatus(ErrorCodes.ERROR_LOGIN_NOT_LOGGED.getErrNum());
            result.setError("Not logged in");
            sendResponse(response, result);
            return;
        }
        String corsoParam = request.getParameter("corso");
        if(Utils.isInteger(corsoParam)){
            result.setSuccess("OK", model.getDocentiByCorsoId(Integer.parseInt(corsoParam)));
            sendResponse(response, result);
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
