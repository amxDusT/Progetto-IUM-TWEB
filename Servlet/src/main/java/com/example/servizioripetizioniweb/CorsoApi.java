package com.example.servizioripetizioniweb;

import com.example.servizioripetizioniweb.result.CorsoResult;
import com.example.servizioripetizioniweb.utils.ErrorCodes;
import com.example.servizioripetizioniweb.utils.Utils;
import com.google.gson.Gson;
import dao.Corso;
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
import java.util.List;

@WebServlet(name = "Corso API", value = "/corso/api")
public class CorsoApi extends HttpServlet {
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
     * param corso = 0-X, all
     *
     * @param request
     * @param response
     */
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        CorsoResult result = new CorsoResult();
        try {
            if (!Utils.isLoggedIn(session)) {
                // return to login page or deny access
                response.setStatus(ErrorCodes.ERROR_LOGIN_NOT_LOGGED.getErrNum());
                result.setError("Not logged in");
            } else {
                String corsoParam = request.getParameter("corso");
                String orderByParam = request.getParameter("order-by");
                String ascParam = request.getParameter("order-type");
                String searchColumnParam = request.getParameter("search-column");
                String startAtParam = request.getParameter("start-at");
                String endAtParam = request.getParameter("end-at");
                if (corsoParam != null) {
                    if (corsoParam.equalsIgnoreCase("all")) {
                        if (searchColumnParam != null && startAtParam == null && endAtParam == null)
                            searchColumnParam = null;
                        List<Corso> corsi = model.retrieveCorsi(
                                orderByParam, ascParam != null && ascParam.equalsIgnoreCase("ASC"), searchColumnParam, startAtParam == null ? endAtParam : startAtParam,
                                startAtParam != null, true);
                        corsi.forEach(corso -> corso.setDocentiNum(model.getDocentiByCorsoId(
                                corso.getId()
                        ).size()));

                        result.setSuccess("OK", corsi);
                    }
                    else if(Utils.isInteger(corsoParam)){
                        Corso c = model.getCorsoById(Integer.parseInt(corsoParam));
                        if( c == null )
                            throw new Exception("Corso not found");
                        c.setDocentiNum(model.getDocentiByCorsoId(c.getId()).size());
                        result.setSuccess("OK", Collections.singletonList(c));
                    }
                }
            }
        } catch (IllegalArgumentException e) {
            response.setStatus(ErrorCodes.ERROR_CORSO_ERROR.getErrNum());
            result.setError(e.getMessage());
        } catch (Exception e){
            response.setStatus(ErrorCodes.ERROR_UNKNOWN.getErrNum());
            result.setError(e.getMessage());
        }
        PrintWriter out = response.getWriter();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String resJson = new Gson().toJson(result);
        out.print(resJson);
        out.flush();
    }
}