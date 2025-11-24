Java Web-Based Quiz Platform

  A full-featured Java web application built using Servlets, JSP, JDBC (MySQL), and MVC architecture.
  
  The system supports Admin, Creator, and Participant roles with complete quiz lifecycle management.

  Features
  
👤 User Management

Secure login using BCrypt-hashed passwords

Roles: ADMIN, CREATOR, PARTICIPANT

Admin can create, update, delete users

Session-based authentication + /admin/* protected by filter

Quiz Creation (CREATOR)

Create quiz metadata (title, description, duration)

Add unlimited questions with:

Question text

Options A/B/C/D

Correct option

Marks per question

Quizzes remain pending for admin approval

✔️ Quiz Approval (ADMIN)

View all pending quizzes

Approve / Reject quizzes

Manage users

View admin dashboard with Chart.js visual reports

🎮 Quiz Taking (Participant)

View all approved quizzes

Start quiz → attempt is recorded

Ticking timer (client-side) + server-side time enforcement

Submit answers → stored securely in DB

Auto-calculated total score

Results page displayed

📊 Reports

Attempt history for participants

Simple leaderboard view (demo)

Admin performance chart using Chart.js

🏗️ Project Architecture

quiz-platform/

├─ pom.xml

├─ src/

│  ├─ main/

│  │  ├─ java/com/quizapp/

│  │  │  ├─ dao/ (DBConnection, UserDAO, QuizDAO, QuestionDAO, AttemptDAO, AnswerDAO)

│  │  │  ├─ model/ (User, Quiz, Question, Attempt, Answer)

│  │  │  ├─ servlet/ (AuthServlet, AdminServlet, QuizServlet, CreatorServlet, ReportServlet)

│  │  │  ├─ filter/ (AuthFilter, optional RoleFilter/CSRF)

│  │  │  └─ util/ (PasswordUtil, other helpers)

│  │  ├─ webapp/

│  │  │  ├─ WEB-INF/

│  │  │  │  ├─ web.xml

│  │  │  │  └─ jsp/

│  │  │  │     ├─ admin/dashboard.jsp

│  │  │  │     ├─ admin/pending.jsp

│  │  │  │     └─ admin/users.jsp

│  │  │  ├─ index.jsp

│  │  │  ├─ login.jsp

│  │  │  ├─ quizzes.jsp

│  │  │  ├─ take_quiz_timed.jsp

│  │  │  └─ quiz_result.jsp

│  └─ test/ (unit / integration tests)

└─ README.md

🛠️ Technologies Used

Backend

Java 8+ (or 23 since your pom specifies 23)

Servlet API 4.0.1

JSP 2.3

BCrypt (jbcrypt) for password hashing

JDBC + PreparedStatement

MySQL

HikariCP (Connection Pooling, recommended)

Frontend

HTML, CSS, JSP

JSTL

Chart.js (Admin dashboard chart)

Build Tool

Maven

WAR Packaging


⚙️ How to Run the Project

1️⃣ Clone the repository: https://github.com/CodeConstructors1/Java-Online-Quiz-Platform.git

2️⃣ Configure database: Update DBConnection.java or connection pool (if improved version is used):

jdbc:mysql://localhost:3306/quiz_platform
user=root
password=

3️⃣ Build project:   mvn clean package

4️⃣ Deploy WAR file:

Deploy quiz-platform-full.war to:

Apache Tomcat 9/10

Jetty

Any Java EE servlet container

5️⃣ Access application: http://localhost:8080/quiz-platform-full/



