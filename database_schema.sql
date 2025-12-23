-- Create database
CREATE DATABASE IF NOT EXISTS quiz_platform CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE quiz_platform;

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS results;
DROP TABLE IF EXISTS answers;
DROP TABLE IF EXISTS options;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS quizzes;
DROP TABLE IF EXISTS users;

-- Create users table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('CREATOR', 'PARTICIPANT') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create quizzes table
CREATE TABLE quizzes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    creator_id INT NOT NULL,
    duration INT NOT NULL COMMENT 'Duration in minutes',
    passing_score INT NOT NULL COMMENT 'Passing score percentage',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (creator_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create questions table
CREATE TABLE questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    quiz_id INT NOT NULL,
    question_text TEXT NOT NULL,
    question_type ENUM('MULTIPLE_CHOICE', 'TRUE_FALSE') NOT NULL,
    points INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
);

-- Create options table
CREATE TABLE options (
    id INT PRIMARY KEY AUTO_INCREMENT,
    question_id INT NOT NULL,
    option_text VARCHAR(500) NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

-- Create answers table
CREATE TABLE answers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    question_id INT NOT NULL,
    selected_option_id INT NOT NULL,
    is_correct BOOLEAN NOT NULL,
    answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,
    FOREIGN KEY (selected_option_id) REFERENCES options(id) ON DELETE CASCADE
);

-- Create results table
CREATE TABLE results (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    quiz_id INT NOT NULL,
    score INT NOT NULL,
    total_questions INT NOT NULL,
    percentage DECIMAL(5,2) NOT NULL,
    passed BOOLEAN NOT NULL,
    time_taken INT COMMENT 'Time taken in seconds',
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
);

-- Insert sample users
-- Password for all users: password123
INSERT INTO users (name, email, password_hash, role) VALUES
('Quiz Creator', 'creator@example.com', '$2a$10$rZ7q0JQ5H5Zq5Z5Z5Z5Z5uH5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5a', 'CREATOR'),
('Alice Johnson', 'alice@example.com', '$2a$10$rZ7q0JQ5H5Zq5Z5Z5Z5Z5uH5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5a', 'PARTICIPANT'),
('Bob Smith', 'bob@example.com', '$2a$10$rZ7q0JQ5H5Zq5Z5Z5Z5Z5uH5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5a', 'PARTICIPANT');

-- Insert sample quiz
INSERT INTO quizzes (title, description, creator_id, duration, passing_score) VALUES
('Java Basics Quiz', 'Test your knowledge of Java fundamentals', 1, 30, 70);

-- Insert sample questions
INSERT INTO questions (quiz_id, question_text, question_type, points) VALUES
(1, 'What is the size of int in Java?', 'MULTIPLE_CHOICE', 1),
(1, 'Is Java a compiled language?', 'TRUE_FALSE', 1);

-- Insert options for question 1
INSERT INTO options (question_id, option_text, is_correct) VALUES
(1, '16 bits', false),
(1, '32 bits', true),
(1, '64 bits', false),
(1, '8 bits', false);

-- Insert options for question 2
INSERT INTO options (question_id, option_text, is_correct) VALUES
(2, 'True', true),
(2, 'False', false);

-- Create indexes for better performance
CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_quiz_creator ON quizzes(creator_id);
CREATE INDEX idx_question_quiz ON questions(quiz_id);
CREATE INDEX idx_option_question ON options(question_id);
CREATE INDEX idx_answer_user ON answers(user_id);
CREATE INDEX idx_result_user ON results(user_id);
CREATE INDEX idx_result_quiz ON results(quiz_id);

-- Display success message
SELECT 'Database setup completed successfully!' AS message;