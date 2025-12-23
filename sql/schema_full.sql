CREATE DATABASE IF NOT EXISTS quiz_platform;
USE quiz_platform;

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS answers;
DROP TABLE IF EXISTS attempts;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS quizzes;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS settings;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('CREATOR','PARTICIPANT') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE quizzes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  duration_minutes INT NOT NULL,
  creator_id INT,
  approved BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (creator_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE questions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  quiz_id INT NOT NULL,
  question_text TEXT NOT NULL,
  option_a VARCHAR(255),
  option_b VARCHAR(255),
  option_c VARCHAR(255),
  option_d VARCHAR(255),
  correct_option CHAR(1) NOT NULL,
  marks INT DEFAULT 1,
  FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
);

CREATE TABLE attempts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  quiz_id INT NOT NULL,
  user_id INT NOT NULL,
  start_time DATETIME,
  end_time DATETIME,
  total_score INT DEFAULT 0,
  submitted BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE answers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  attempt_id INT NOT NULL,
  question_id INT NOT NULL,
  selected_option CHAR(1),
  is_correct BOOLEAN,
  marks_awarded INT DEFAULT 0,
  FOREIGN KEY (attempt_id) REFERENCES attempts(id) ON DELETE CASCADE,
  FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

CREATE TABLE settings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) UNIQUE,
  value VARCHAR(255)
);

-- seed users (passwords hashed via bcrypt compatible strings)
-- Password for all users: password123
INSERT INTO users (name,email,password_hash,role) VALUES
('Creator','creator@example.com','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','CREATOR'),
('Alice','alice@example.com','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','PARTICIPANT'),
('Bob','bob@example.com','$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','PARTICIPANT');

-- Note: All passwords are: password123 (replace with actual bcrypt hashes for production)

-- Quizzes are automatically approved when created
INSERT INTO quizzes (title,description,duration_minutes,creator_id,approved) VALUES
('Java Basics','A short multiple-choice quiz on Java basics',20,1,TRUE),
('OOP Concepts','Object-oriented programming concepts',15,1,TRUE);

INSERT INTO questions (quiz_id,question_text,option_a,option_b,option_c,option_d,correct_option,marks) VALUES
(1,'What does JVM stand for?','Java Virtual Machine','Java Variable Manager','Just Virtual Machine','None of the above','A',1),
(1,'Which keyword is used to inherit a class in Java?','implements','extends','inherits','super','B',1),
(1,'Which collection allows duplicate elements?','Set','List','Map','None','B',1);
