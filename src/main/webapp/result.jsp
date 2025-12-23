<%@ page contentType="text/html;charset=UTF-8" import="javax.servlet.http.HttpSession" %>
<%
    HttpSession currentSession = request.getSession(false);
    if (currentSession == null || currentSession.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String scoreParam = (String) request.getAttribute("score");
    String totalParam = (String) request.getAttribute("total");
    int scoreValue = 0;
    int totalValue = 0;
    try {
        if (scoreParam != null) {
            scoreValue = Integer.parseInt(scoreParam);
        }
        if (totalParam != null) {
            totalValue = Integer.parseInt(totalParam);
        }
    } catch (NumberFormatException ignored) {
    }
    int percent = totalValue > 0 ? (int) Math.round(scoreValue * 100.0 / totalValue) : 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz Result</title>
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background: linear-gradient(180deg, #0f172a, #1d1f3b);
            color: #fff;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }
        .card {
            background: rgba(15, 23, 42, 0.92);
            border-radius: 24px;
            padding: 40px;
            width: min(520px, 100%);
            box-shadow: 0 25px 55px rgba(15, 23, 42, 0.7);
            text-align: center;
        }
        .card h1 {
            margin: 8px 0;
            font-size: 64px;
            letter-spacing: 2px;
        }
        .tag {
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 5px;
            opacity: 0.6;
        }
        .score-line {
            margin-top: 10px;
            font-size: 18px;
            color: #93a3c1;
        }
        .percent {
            font-size: 22px;
            margin: 20px 0 30px;
            color: #34d399;
        }
        .actions {
            display: flex;
            justify-content: center;
            gap: 12px;
        }
        .btn {
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 12px;
            font-weight: 600;
        }
        .btn.primary {
            background: #34d399;
            color: #0f172a;
        }
        .btn.ghost {
            border: 1px solid rgba(255, 255, 255, 0.6);
            color: #fff;
        }
    </style>
</head>
<body>
    <div class="card">
        <p class="tag">Result</p>
        <h1><%= scoreValue %> / <%= totalValue %></h1>
        <p class="score-line">You answered <%= scoreValue %> questions correctly.</p>
        <p class="percent"><%= percent %>% accuracy</p>
        <div class="actions">
            <a class="btn ghost" href="home.jsp">Back to dashboard</a>
            <a class="btn primary" href="logout">Logout</a>
        </div>
    </div>
</body>
</html>
