package com.quiz;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ManageQuizServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) {
            response.sendRedirect("home.jsp");
            return;
        }
        response.sendRedirect("admin.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) {
            response.sendRedirect("home.jsp");
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("createQuiz".equals(action)) {
                createQuiz(request);
                response.sendRedirect("admin.jsp?created=1");
            } else if ("addQuestion".equals(action)) {
                addQuestion(request);
                int quizId = Integer.parseInt(request.getParameter("quizId"));
                response.sendRedirect("admin.jsp?quizId=" + quizId + "&added=1");
            } else {
                response.sendRedirect("admin.jsp?error=unknown_action");
            }
        } catch (SQLException e) {
            throw new ServletException("Unable to manage quiz", e);
        }
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) {
            return false;
        }
        Object roleObj = session.getAttribute("userRole");
        return roleObj != null && "ADMIN".equalsIgnoreCase(roleObj.toString());
    }

    private void createQuiz(HttpServletRequest request) throws SQLException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");

        try (Connection conn = DB.getConnection()) {
            String sql = "INSERT INTO quizzes (title, description) VALUES (?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, title);
            stmt.setString(2, description);
            stmt.executeUpdate();
        }
    }

    private void addQuestion(HttpServletRequest request) throws SQLException {
        int quizId = Integer.parseInt(request.getParameter("quizId"));
        String questionText = request.getParameter("questionText");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String correctOption = request.getParameter("correctOption");

        try (Connection conn = DB.getConnection()) {
            String sql = "INSERT INTO questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, quizId);
            stmt.setString(2, questionText);
            stmt.setString(3, optionA);
            stmt.setString(4, optionB);
            stmt.setString(5, optionC);
            stmt.setString(6, optionD);
            stmt.setString(7, correctOption);
            stmt.executeUpdate();
        }
    }
}
