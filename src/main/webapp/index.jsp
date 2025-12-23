<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial; background: linear-gradient(135deg, #667eea, #764ba2); 
               min-height: 100vh; display: flex; align-items: center; justify-content: center; }
        .box { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 10px 25px rgba(0,0,0,0.2); 
               width: 400px; }
        h1 { text-align: center; color: #333; margin-bottom: 30px; }
        input { width: 100%; padding: 12px; margin: 10px 0; border: 1px solid #ddd; border-radius: 5px; }
        button { width: 100%; padding: 12px; background: #667eea; color: white; border: none; border-radius: 5px; 
                 font-size: 16px; cursor: pointer; margin-top: 10px; }
        button:hover { background: #5568d3; }
        .error { color: red; text-align: center; margin: 10px 0; }
        .info { margin-top: 20px; padding: 15px; background: #f0f0f0; border-radius: 5px; font-size: 13px; }
    </style>
</head>
<body>
    <div class="box">
        <h1>Simple Quiz</h1>
        
        <% if (request.getParameter("error") != null) { %>
            <p class="error">Invalid credentials!</p>
        <% } %>
        
        <form action="login" method="post">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
        
        <div class="info">
            <strong>Demo Logins:</strong><br>
            Admin — Username: admin / Password: admin123<br>
            User — Username: john / Password: password123
        </div>
    </div>
</body>
</html>
