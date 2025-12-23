<%@ page contentType="text/html;charset=UTF-8" import="com.quiz.DB, java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException, javax.servlet.http.HttpSession" %>
<%
    HttpSession currentSession = request.getSession(false);
    String role = currentSession != null ? (String) currentSession.getAttribute("userRole") : null;
    if (currentSession == null || currentSession.getAttribute("userId") == null || role == null || !"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect("home.jsp");
        return;
    }
    String userName = (String) currentSession.getAttribute("userName");
    String created = request.getParameter("created");
    String added = request.getParameter("added");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin | Quiz Manager</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background: linear-gradient(135deg, #0f172a, #1f2937);
            color: #e5e7eb;
            min-height: 100vh;
        }
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 36px;
            background: rgba(15, 23, 42, 0.85);
            border-bottom: 1px solid rgba(255,255,255,0.08);
            position: sticky;
            top: 0;
            z-index: 2;
        }
        header h1 { margin: 0; font-size: 22px; color: #f8fafc; }
        header .actions { display: flex; gap: 10px; align-items: center; }
        a.btn, button.btn { text-decoration: none; border: none; cursor: pointer; padding: 10px 16px; border-radius: 9px; font-weight: 600; font-size: 14px; }
        .btn.primary { background: linear-gradient(135deg, #22c55e, #16a34a); color: #0f172a; }
        .btn.secondary { background: rgba(255,255,255,0.08); color: #e5e7eb; border: 1px solid rgba(255,255,255,0.1); }
        main { padding: 36px; max-width: 1200px; margin: 0 auto; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 18px; }
        .card { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.07); padding: 20px; border-radius: 14px; box-shadow: 0 18px 40px rgba(0,0,0,0.35); }
        .card h2 { margin-top: 0; color: #f8fafc; font-size: 18px; }
        label { display: block; margin: 10px 0 6px; font-size: 13px; color: #cbd5e1; }
        input[type="text"], textarea, select { width: 100%; padding: 10px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.1); background: rgba(255,255,255,0.05); color: #f8fafc; }
        textarea { min-height: 80px; resize: vertical; }
        .inline { display: flex; gap: 10px; }
        .message { margin-bottom: 14px; padding: 10px 12px; border-radius: 10px; }
        .message.success { background: rgba(34, 197, 94, 0.15); border: 1px solid rgba(34,197,94,0.4); color: #bbf7d0; }
        .message.error { background: rgba(248, 113, 113, 0.15); border: 1px solid rgba(248,113,113,0.4); color: #fecdd3; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 10px; border-bottom: 1px solid rgba(255,255,255,0.08); text-align: left; }
        th { color: #cbd5e1; font-weight: 600; }
    </style>
</head>
<body>
<header>
    <h1>Admin Dashboard · Welcome, <%= userName %></h1>
    <div class="actions">
        <a class="btn secondary" href="home.jsp">User View</a>
        <a class="btn secondary" href="logout">Logout</a>
    </div>
</header>
<main>
    <% if ("1".equals(created)) { %>
        <div class="message success">Quiz created successfully.</div>
    <% } %>
    <% if ("1".equals(added)) { %>
        <div class="message success">Question added successfully.</div>
    <% } %>
    <% if (error != null) { %>
        <div class="message error">Action failed: <%= error %></div>
    <% } %>
    <div class="grid">
        <div class="card">
            <h2>Create Quiz</h2>
            <form action="manage-quiz" method="post">
                <input type="hidden" name="action" value="createQuiz">
                <label for="title">Title</label>
                <input type="text" id="title" name="title" required>
                <label for="description">Description</label>
                <textarea id="description" name="description" placeholder="Short description"></textarea>
                <button class="btn primary" type="submit">Create Quiz</button>
            </form>
        </div>
        <div class="card">
            <h2>Add Question</h2>
            <form action="manage-quiz" method="post">
                <input type="hidden" name="action" value="addQuestion">
                <label for="quizId">Select Quiz</label>
                <select id="quizId" name="quizId" required>
                    <option value="">-- choose quiz --</option>
                    <%
                        try (Connection conn = DB.getConnection();
                             PreparedStatement stmt = conn.prepareStatement("SELECT id, title FROM quizzes ORDER BY id DESC");
                             ResultSet rs = stmt.executeQuery()) {
                            while (rs.next()) {
                    %>
                        <option value="<%= rs.getInt("id") %>"><%= rs.getString("title") %></option>
                    <%
                            }
                        } catch (SQLException ex) {
                    %>
                        <option disabled>Error loading quizzes</option>
                    <%
                        }
                    %>
                </select>
                <label for="questionText">Question</label>
                <textarea id="questionText" name="questionText" required></textarea>
                <div class="inline">
                    <div style="flex:1">
                        <label for="optionA">Option A</label>
                        <input type="text" id="optionA" name="optionA" required>
                    </div>
                    <div style="flex:1">
                        <label for="optionB">Option B</label>
                        <input type="text" id="optionB" name="optionB" required>
                    </div>
                </div>
                <div class="inline">
                    <div style="flex:1">
                        <label for="optionC">Option C</label>
                        <input type="text" id="optionC" name="optionC" required>
                    </div>
                    <div style="flex:1">
                        <label for="optionD">Option D</label>
                        <input type="text" id="optionD" name="optionD" required>
                    </div>
                </div>
                <label for="correctOption">Correct Option</label>
                <select id="correctOption" name="correctOption" required>
                    <option value="A">A</option>
                    <option value="B">B</option>
                    <option value="C">C</option>
                    <option value="D">D</option>
                </select>
                <button class="btn primary" type="submit">Add Question</button>
            </form>
        </div>
    </div>
    <div class="card" style="margin-top:18px;">
        <h2>Quizzes</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
            <%
                try (Connection conn = DB.getConnection();
                     PreparedStatement stmt = conn.prepareStatement("SELECT id, title, description FROM quizzes ORDER BY id DESC");
                     ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        String description = rs.getString("description");
                        if (description == null || description.trim().isEmpty()) {
                            description = "No description";
                        }
            %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("title") %></td>
                    <td><%= description %></td>
                </tr>
            <%
                    }
                } catch (SQLException e) {
            %>
                <tr><td colspan="3">Unable to load quizzes.</td></tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</main>
</body>
</html>
