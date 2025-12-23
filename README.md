# Java Online Quiz Platform

Role-based quiz webapp (Admin/User) built with Java Servlets/JSP, MySQL, and Jetty.

## Features
- Role-based auth: `ADMIN` manages quizzes/questions; `USER` takes quizzes and views scores.
- Admin UI to create quizzes and add questions.
- User dashboard with quiz catalog and recent scores.
- Sample credentials for quick start.

## Prerequisites
- JDK 17+
- MySQL (XAMPP MariaDB works). Defaults: host `localhost`, user `root`, no password.
- Maven (using IntelliJ-bundled Maven: `C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2023.1.2\plugins\maven\lib\maven3\bin\mvn.cmd`).

## Setup: Database
1) Ensure MySQL is running (XAMPP: start MySQL).
2) Apply schema and seed data:
   - Open PowerShell in project root and run:
     ```powershell
     & "C:\xampp\mysql\bin\mysql.exe" -u root < simple_database.sql
     ```
   - Confirms `simple_quiz` DB with users (admin/john/jane) and quizzes/questions.

## Build
From project root:
```powershell
"C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2023.1.2\plugins\maven\lib\maven3\bin\mvn.cmd" clean package
```
Resulting WAR: `target/quiz.war` (exploded at `target/quiz/`).

## Run (Jetty via Maven)
In project root:
```powershell
"C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2023.1.2\plugins\maven\lib\maven3\bin\mvn.cmd" jetty:run
```
- App: http://localhost:8080/quiz/
- Stop: Ctrl+C in the Jetty terminal.
- If port 8080 is busy, free it or change Jetty port in `pom.xml` plugin config.

## Run from IntelliJ IDEA
1) Open the project as a Maven project.
2) Ensure Project SDK = 17.
3) Maven tool window → Lifecycle: run `clean`, then `package` (optional for dev).
4) To run: Maven tool window → Plugins → `jetty` → `jetty:run` (or add a Maven Run Configuration with goal `jetty:run`).
5) Open http://localhost:8080/quiz/.

## Login
- Admin: `admin` / `admin123` → manage quizzes/questions.
- User: `john` / `password123` (or `jane` / `password123`) → take quizzes and see scores.

## Notes
- DB config is in `src/main/java/com/quiz/DB.java` (update URL/user/password if your MySQL differs).
- Sample data is for demo; replace with secure creds and hashed passwords for production.
- If you see odd replacement characters, search and remove them (none found in current sources).

## Troubleshooting
- MySQL not reachable: ensure service is running and creds match `DB.java`.
- Port 8080 in use: stop the conflicting process or change Jetty port in `pom.xml`.
- Build failures about `mvn`: use the bundled Maven path shown above or install Maven globally.
