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

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

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

        // Get username entered on login page
        String username = request.getParameter("username");

        // Check empty username
        if (username == null || username.trim().isEmpty()) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Remove unnecessary spaces
        username = username.trim();

        // Maximum username length
        if (username.length() > 100) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {

            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to MySQL database
            Connection con = DriverManager.getConnection(
                    URL,
                    USER,
                    PASSWORD
            );

            // Automatically add new user
            // If username already exists, do nothing
            String sql =
                    "INSERT IGNORE INTO users (username) VALUES (?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, username);

            ps.executeUpdate();

            ps.close();
            con.close();

            // Create login session
            HttpSession session = request.getSession(true);

            session.setAttribute("username", username);

            // Open chat page
            response.sendRedirect("chat.jsp");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "login.jsp?error=Database+connection+error"
            );
        }
    }
}