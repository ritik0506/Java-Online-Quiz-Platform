<%@ page contentType="text/html;charset=UTF-8" import="com.quiz.DB, java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException, javax.servlet.http.HttpSession" %>
<%
    HttpSession currentSession = request.getSession(false);
    if (currentSession == null || currentSession.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String userName = (String) currentSession.getAttribute("userName");
    String userRole = (String) currentSession.getAttribute("userRole");
    boolean isAdmin = "ADMIN".equalsIgnoreCase(userRole);
    boolean hasQuizzes = false;
    String errorMessage = null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz Dashboard</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background: linear-gradient(145deg, #eef2ff, #f5f7fa);
            color: #1f1f1f;
        }
        header {
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(255, 255, 255, 0.9);
            border-bottom: 1px solid #dfe4ff;
            position: sticky;
            top: 0;
            z-index: 2;
        }
        header h1 {
            font-size: 24px;
            font-weight: 600;
            color: #32325d;
        }
        header .actions { display: flex; gap: 10px; align-items: center; }
        header .btn {
            text-decoration: none;
            color: #ffffff;
            background: #5e72e4;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
        }
        .container {
            padding: 60px 40px;
            max-width: 1100px;
            margin: 0 auto;
        }
        .intro {
            font-size: 18px;
            margin-bottom: 30px;
            color: #494f74;
        }
        .quiz-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
        }
        .quiz-card {
            background: #ffffff;
            padding: 24px;
            border-radius: 14px;
            box-shadow: 0 12px 30px rgba(32, 39, 79, 0.12);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 220px;
        }
        .quiz-card h3 {
            margin-top: 0;
            margin-bottom: 10px;
            font-size: 20px;
            color: #1f1f1f;
        }
        .quiz-card p {
            margin: 0 0 16px;
            color: #5c6288;
            line-height: 1.5;
            flex: 1;
        }
        .quiz-card .btn {
            text-decoration: none;
            display: inline-block;
            background: #5e72e4;
            color: #fff;
            padding: 10px 16px;
            border-radius: 8px;
            font-weight: 600;
            text-align: center;
        }
        .status {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }
        .tagline {
            font-size: 20px;
            color: #252945;
            font-weight: 500;
        }
        .neutral { color: #6c6f91; }
        .status button {
            margin-left: auto;
        }
        .empty,
        .error {
            margin-top: 20px;
            text-align: center;
            font-size: 16px;
            color: #5e72e4;
        }
        .scores {
            margin-top: 40px;
            background: #ffffff;
            padding: 24px;
            border-radius: 12px;
            box-shadow: 0 12px 30px rgba(32, 39, 79, 0.12);
        }
        .scores h2 { margin-top: 0; color: #1f1f1f; }
        table { width: 100%; border-collapse: collapse; }
        th, td { text-align: left; padding: 10px; border-bottom: 1px solid #eef1ff; }
        th { color: #6b7280; font-weight: 600; }
        .role-badge { background: #e0e7ff; color: #4338ca; padding: 6px 10px; border-radius: 999px; font-size: 12px; font-weight: 700; }
        @media (max-width: 600px) {
            header {
                flex-direction: column;
                gap: 10px;
            }
            .container {
                padding: 40px 20px 80px;
            }
        }
    </style>
</head>
<body>
    <header>
        <h1>Welcome back, <%= userName %>!</h1>
        <div class="actions">
            <span class="role-badge"><%= isAdmin ? "ADMIN" : "USER" %></span>
            <% if (isAdmin) { %>
                <a class="btn" href="admin.jsp">Admin</a>
            <% } %>
            <a class="btn" href="logout">Logout</a>
        </div>
    </header>
    <main class="container">
        <div class="status">
            <p class="tagline">Choose a quiz to challenge yourself.</p>
        </div>
        <div class="quiz-grid">
            <%
                try (Connection conn = DB.getConnection();
                     PreparedStatement stmt = conn.prepareStatement("SELECT id, title, description FROM quizzes");
                     ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        hasQuizzes = true;
                        String description = rs.getString("description");
                        if (description == null || description.trim().isEmpty()) {
                            description = "No description yet.";
                        }
            %>
                <div class="quiz-card">
                    <h3><%= rs.getString("title") %></h3>
                    <p><%= description %></p>
                    <a class="btn" href="quiz?action=take&id=<%= rs.getInt("id") %>">Start Quiz</a>
                </div>
            <%
                    }
                } catch (SQLException e) {
                    errorMessage = "Unable to load quizzes right now.";
                }
            %>
        </div>
        <% if (!hasQuizzes && errorMessage == null) { %>
            <p class="empty">No quizzes are available yet. Check back soon.</p>
        <% } %>
        <% if (errorMessage != null) { %>
            <p class="error"><%= errorMessage %></p>
        <% } %>

        <div class="scores">
            <h2>Your recent scores</h2>
            <table>
                <thead>
                    <tr>
                        <th>Quiz</th>
                        <th>Score</th>
                        <th>Total</th>
                        <th>When</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    try (Connection conn = DB.getConnection();
                         PreparedStatement stmt = conn.prepareStatement("SELECT s.score, s.total_questions, s.submitted_at, q.title FROM scores s JOIN quizzes q ON s.quiz_id = q.id WHERE s.user_id = ? ORDER BY s.submitted_at DESC LIMIT 10")) {
                        stmt.setInt(1, (Integer) currentSession.getAttribute("userId"));
                        try (ResultSet rs = stmt.executeQuery()) {
                            boolean hasScores = false;
                            while (rs.next()) {
                                hasScores = true;
                %>
                    <tr>
                        <td><%= rs.getString("title") %></td>
                        <td><%= rs.getInt("score") %></td>
                        <td><%= rs.getInt("total_questions") %></td>
                        <td><%= rs.getTimestamp("submitted_at") %></td>
                    </tr>
                <%
                            }
                            if (!hasScores) {
                %>
                    <tr><td colspan="4">No attempts yet. Start a quiz to see your results here.</td></tr>
                <%
                            }
                        }
                    } catch (SQLException e) {
                %>
                    <tr><td colspan="4">Unable to load scores right now.</td></tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>
