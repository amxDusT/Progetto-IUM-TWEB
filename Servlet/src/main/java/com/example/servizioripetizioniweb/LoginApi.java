package com.example.servizioripetizioniweb;

import java.io.*;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

import com.example.servizioripetizioniweb.result.LoginResult;
import com.example.servizioripetizioniweb.utils.ErrorCodes;
import com.example.servizioripetizioniweb.utils.Utils;
import com.google.gson.Gson;
import dao.*;

@WebServlet(name = "Login API", value = "/login/api")
public class LoginApi extends HttpServlet {
    enum LoginActions {
        LOGIN,
        LOGOUT,
        LOGIN_GUEST,
        UNKNOWN
    }

    enum FieldValidationType {
        EMAIL_ADDRESS,
        USERNAME,
        PASSWORD,
    }

    private Model model;

    @Override
    public void init(ServletConfig config) throws ServletException {
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

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberParam = request.getParameter("remember");
        HttpSession session = request.getSession();
        String jsessionID = session.getId();
        System.out.println("sessionID: " + jsessionID);

        LoginResult result = new LoginResult();
        LoginActions action = getAction(session, request);
        if (Utils.isLoggedIn(session)) {

            if (action == LoginActions.LOGOUT) {
                logOut(session);
            } else if (action == LoginActions.LOGIN)
                result.setSuccess(jsessionID, Utils.getUtente(session));
            else{
                response.setStatus(ErrorCodes.ERROR_UNKNOWN.getErrNum());
            }
        } else if (action == LoginActions.LOGIN) {
            if (!validateField("username", username, FieldValidationType.USERNAME).equals("OK"))
                response.setStatus(ErrorCodes.ERROR_LOGIN_USER_VALIDATION.getErrNum());
            else if (!validateField("password", password, FieldValidationType.PASSWORD).equals("OK"))
                response.setStatus(ErrorCodes.ERROR_LOGIN_PASSWORD_VALIDATION.getErrNum());
            else {
                Utente u = model.getUtenteByLogin(username, password);
                if (u == null)
                    response.setStatus(ErrorCodes.ERROR_LOGIN_WRONG_CREDENTIALS.getErrNum());
                else {
                    u.setPassword(null);
                    result.setSuccess(jsessionID, u);
                    Utils.setUtente(session, u);
                    if (rememberParam != null && rememberParam.equals("1")) {
                        // remember for 2 weeks
                        session.setMaxInactiveInterval(14 * 60 * 60 * 24);
                    }
                }
            }
        } else if(action == LoginActions.LOGIN_GUEST){
            Utente u = new Utente(0, "Guest", null, Utente.role.GUEST);
            result.setSuccess(jsessionID, u);
            Utils.setUtente(session, u);
        }
        PrintWriter out = response.getWriter();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String resJson = new Gson().toJson(result);

        out.print(resJson);
        out.flush();
    }

    void logOut(HttpSession session) {
        session.invalidate();
    }

    LoginActions getAction(HttpSession session, HttpServletRequest request) {
        String action = request.getParameter("action");
        if (action == null || action.equalsIgnoreCase("login")) {
            return LoginActions.LOGIN;
        } else if (action.equalsIgnoreCase("logout")) {
            return LoginActions.LOGOUT;
        } else if(action.equalsIgnoreCase("login-guest")){
            return LoginActions.LOGIN_GUEST;
        }
        return LoginActions.UNKNOWN;
    }

    private String validateField(String field, String value, FieldValidationType type) {
        if (value == null)
            return field + " cannot be empty.";
        switch (type) {
            case PASSWORD: {
                if (value.length() < 4)
                    return field + " must have at least 4 characters.";
                return "OK";
            }
            case USERNAME: {
                if (value.length() < 4) {
                    return field + " must have at least 4 characters.";
                } else if (value.contains("@")) {
                    return field + " cannot have special characters.";
                }
                return "OK";
            }
            case EMAIL_ADDRESS: {
                if (!value.contains("@")) {
                    return field + " must be an email.";
                }
                return "OK";
            }
            default: {
                return "OK";
            }
        }
    }
}
