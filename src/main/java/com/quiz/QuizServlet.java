package com.quiz;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class QuizServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            if ("take".equals(action)) {
                int quizId = Integer.parseInt(request.getParameter("id"));
                loadQuiz(request, quizId);
                request.getRequestDispatcher("take-quiz.jsp").forward(request, response);
                return;
            } else if ("result".equals(action)) {
                showResults(request);
                request.getRequestDispatcher("result.jsp").forward(request, response);
                return;
            }

            response.sendRedirect("home.jsp");
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        int quizId = Integer.parseInt(request.getParameter("quizId"));
        
        try (Connection conn = DB.getConnection()) {
            // Get all questions for this quiz
            String sql = "SELECT id, correct_option FROM questions WHERE quiz_id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, quizId);
            ResultSet rs = stmt.executeQuery();
            
            int score = 0;
            int total = 0;
            
            while (rs.next()) {
                total++;
                int questionId = rs.getInt("id");
                String correctOption = rs.getString("correct_option");
                String userAnswer = request.getParameter("q" + questionId);
                
                if (correctOption.equals(userAnswer)) {
                    score++;
                }
            }
            
            // Save score
            String insertSql = "INSERT INTO scores (user_id, quiz_id, score, total_questions) VALUES (?, ?, ?, ?)";
            PreparedStatement insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setInt(1, userId);
            insertStmt.setInt(2, quizId);
            insertStmt.setInt(3, score);
            insertStmt.setInt(4, total);
            insertStmt.executeUpdate();
            
            response.sendRedirect("quiz?action=result&score=" + score + "&total=" + total);
            
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    private void loadQuiz(HttpServletRequest request, int quizId) throws SQLException {
        try (Connection conn = DB.getConnection()) {
            // Get quiz info
            String quizSql = "SELECT title, description FROM quizzes WHERE id=?";
            PreparedStatement quizStmt = conn.prepareStatement(quizSql);
            quizStmt.setInt(1, quizId);
            ResultSet quizRs = quizStmt.executeQuery();
            
            if (quizRs.next()) {
                request.setAttribute("quizId", quizId);
                request.setAttribute("quizTitle", quizRs.getString("title"));
                request.setAttribute("quizDescription", quizRs.getString("description"));
            }
            
            // Get questions
            String questionsSql = "SELECT * FROM questions WHERE quiz_id=?";
            PreparedStatement questionsStmt = conn.prepareStatement(questionsSql);
            questionsStmt.setInt(1, quizId);
            ResultSet questionsRs = questionsStmt.executeQuery();
            
            List<Map<String, String>> questions = new ArrayList<>();
            while (questionsRs.next()) {
                Map<String, String> q = new HashMap<>();
                q.put("id", String.valueOf(questionsRs.getInt("id")));
                q.put("text", questionsRs.getString("question_text"));
                q.put("optionA", questionsRs.getString("option_a"));
                q.put("optionB", questionsRs.getString("option_b"));
                q.put("optionC", questionsRs.getString("option_c"));
                q.put("optionD", questionsRs.getString("option_d"));
                questions.add(q);
            }
            
            request.setAttribute("questions", questions);
        }
    }
    
    private void showResults(HttpServletRequest request) {
        request.setAttribute("score", request.getParameter("score"));
        request.setAttribute("total", request.getParameter("total"));
    }
}
