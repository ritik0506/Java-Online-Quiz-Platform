package com.quiz;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class LoginServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        try (Connection conn = DB.getConnection()) {
            String sql = "SELECT id, name, role FROM users WHERE username=? AND password=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("userName", rs.getString("name"));
                session.setAttribute("userRole", rs.getString("role"));

                String role = rs.getString("role");
                if ("ADMIN".equalsIgnoreCase(role)) {
                    response.sendRedirect("admin.jsp");
                } else {
                    response.sendRedirect("home.jsp");
                }
            } else {
                response.sendRedirect("index.jsp?error=1");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}
