<%@ page contentType="text/html;charset=UTF-8" import="java.util.List, java.util.Map, javax.servlet.http.HttpSession" %>
<%
    HttpSession currentSession = request.getSession(false);
    if (currentSession == null || currentSession.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    List<Map<String, String>> questions = (List<Map<String, String>>) request.getAttribute("questions");
    Integer quizId = (Integer) request.getAttribute("quizId");
    String quizTitle = (String) request.getAttribute("quizTitle");
    String quizDescription = (String) request.getAttribute("quizDescription");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= quizTitle != null ? quizTitle : "Quiz" %></title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background: #0f172a;
            color: #f8fafc;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 40px 20px 60px;
        }
        .panel {
            width: min(1000px, 100%);
            background: rgba(15, 23, 42, 0.95);
            padding: 32px;
            border-radius: 18px;
            box-shadow: 0 20px 45px rgba(15, 23, 42, 0.4);
        }
        h1 {
            margin-top: 0;
            font-size: 32px;
            color: #f1f5f9;
        }
        .description {
            color: #94a3b8;
            margin-bottom: 20px;
            font-size: 16px;
        }
        .question-block {
            margin-bottom: 24px;
            padding: 18px;
            border-radius: 12px;
            background: rgba(148, 163, 184, 0.08);
            border: 1px solid rgba(148, 163, 184, 0.2);
        }
        .question-number {
            font-size: 14px;
            color: #94a3b8;
            margin-bottom: 6px;
        }
        .question-text {
            margin: 0 0 14px;
            font-size: 19px;
        }
        .options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 10px;
        }
        .options label {
            display: flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.04);
            padding: 10px 14px;
            border-radius: 8px;
            border: 1px solid transparent;
            cursor: pointer;
        }
        .options input {
            accent-color: #6366f1;
        }
        .options label:hover {
            border-color: rgba(99, 102, 241, 0.4);
        }
        .actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 20px;
        }
        .btn {
            border: none;
            cursor: pointer;
            padding: 12px 22px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 15px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .btn.primary {
            background: linear-gradient(135deg, #34d399, #10b981);
            color: #0f172a;
        }
        .btn.ghost {
            background: rgba(148, 163, 184, 0.15);
            color: #e2e8f0;
        }
        .error {
            color: #f87171;
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="panel">
        <h1><%= quizTitle != null ? quizTitle : "Quiz" %></h1>
        <p class="description"><%= quizDescription != null ? quizDescription : "Answer the questions to see how you score." %></p>
        <form action="quiz" method="post">
            <input type="hidden" name="quizId" value="<%= quizId != null ? quizId : 0 %>">
                <%
                    if (questions != null && !questions.isEmpty()) {
                        int index = 1;
                        for (Map<String, String> question : questions) {
                            String id = question.get("id");
                            String requiredAttr = "required";
            %>
                <div class="question-block">
                    <p class="question-number">Question <%= index %></p>
                    <p class="question-text"><%= question.get("text") %></p>
                    <div class="options">
                        <label>
                                <input type="radio" name="q<%= id %>" value="A" <%= requiredAttr %>>
                            <span>A. <%= question.get("optionA") %></span>
                        </label>
                        <label>
                            <input type="radio" name="q<%= id %>" value="B">
                            <span>B. <%= question.get("optionB") %></span>
                        </label>
                        <label>
                            <input type="radio" name="q<%= id %>" value="C">
                            <span>C. <%= question.get("optionC") %></span>
                        </label>
                        <label>
                            <input type="radio" name="q<%= id %>" value="D">
                            <span>D. <%= question.get("optionD") %></span>
                        </label>
                    </div>
                </div>
            <%
                        index++;
                    }
                } else {
            %>
                <p class="error">This quiz does not have any questions yet.</p>
            <%
                }
            %>
            <div class="actions">
                <a class="btn ghost" href="home.jsp">Back to Dashboard</a>
                <button type="submit" class="btn primary">Submit Answers</button>
            </div>
        </form>
    </div>
</body>
</html>
