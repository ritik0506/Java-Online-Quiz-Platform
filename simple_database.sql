-- Simple Quiz Platform Database
DROP DATABASE IF EXISTS simple_quiz;
CREATE DATABASE simple_quiz;
USE simple_quiz;

-- Users table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role ENUM('ADMIN','USER') NOT NULL DEFAULT 'USER'
);

-- Quizzes table
CREATE TABLE quizzes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT
);

-- Questions table
CREATE TABLE questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    quiz_id INT NOT NULL,
    question_text TEXT NOT NULL,
    option_a VARCHAR(200) NOT NULL,
    option_b VARCHAR(200) NOT NULL,
    option_c VARCHAR(200) NOT NULL,
    option_d VARCHAR(200) NOT NULL,
    correct_option CHAR(1) NOT NULL,
    FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
);

-- Scores table  
CREATE TABLE scores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    quiz_id INT NOT NULL,
    score INT NOT NULL,
    total_questions INT NOT NULL,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
);

-- Insert sample data (passwords are plain-text for demo only)
INSERT INTO users (username, password, name, role) VALUES 
('admin', 'admin123', 'Site Admin', 'ADMIN'),
('john', 'password123', 'John Doe', 'USER'),
('jane', 'password123', 'Jane Smith', 'USER');

INSERT INTO quizzes (title, description) VALUES 
('Java Basics', 'Test your Java knowledge'),
('Math Quiz', 'Simple math questions');

INSERT INTO questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option) VALUES
(1, 'What is Java?', 'A programming language', 'A coffee brand', 'An island', 'A game', 'A'),
(1, 'Who created Java?', 'James Gosling', 'Dennis Ritchie', 'Bjarne Stroustrup', 'Guido van Rossum', 'A'),
(2, 'What is 2 + 2?', '3', '4', '5', '6', 'B'),
(2, 'What is 5 x 5?', '20', '25', '30', '35', 'B');
