package com.chat;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/StartChat")
public class StartChatServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String URL =
        "jdbc:mysql://db01.dbhost.dev:5051/db_454q64y5r"
        + "?useSSL=false"
        + "&allowPublicKeyRetrieval=true"
        + "&serverTimezone=UTC";

    private static final String USER =
        "user_454q64y5r";

    private static final String PASSWORD =
        "p454q64y5r";

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String username =
            request.getParameter("username");

        if (username == null ||
            username.trim().isEmpty()) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );

            return;
        }

        username = username.trim();

        try {

            Class.forName(
                "com.mysql.cj.jdbc.Driver"
            );

            Connection con =
                DriverManager.getConnection(
                    URL,
                    USER,
                    PASSWORD
                );

            String sql =
                "INSERT IGNORE INTO users (username) VALUES (?)";

            PreparedStatement ps =
                con.prepareStatement(sql);

            ps.setString(1, username);

            ps.executeUpdate();

            ps.close();
            con.close();

            HttpSession session =
                request.getSession(true);

            session.setAttribute(
                "username",
                username
            );

            response.sendRedirect(
                request.getContextPath() + "/chat.jsp"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType(
                "text/html;charset=UTF-8"
            );

            response.getWriter().println(
                "<h2>Database Error</h2>"
            );

            response.getWriter().println(
                "<p>" + e.getMessage() + "</p>"
            );
        }
    }
}