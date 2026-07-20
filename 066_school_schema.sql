-- ============================================================
-- 066: School Schema - students, teachers, courses, enrollments
-- Educational institution database design
-- ============================================================

CREATE TABLE IF NOT EXISTS students (
    student_id      INT PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    date_of_birth   DATE,
    email           VARCHAR(100) UNIQUE,
    phone           VARCHAR(20),
    enrollment_date DATE DEFAULT CURRENT_DATE,
    status          VARCHAR(20) DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS teachers (
    teacher_id      INT PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    email           VARCHAR(100) UNIQUE,
    department      VARCHAR(50),
    hire_date       DATE
);

CREATE TABLE IF NOT EXISTS courses (
    course_id       INT PRIMARY KEY,
    course_code     VARCHAR(20) UNIQUE NOT NULL,
    title           VARCHAR(200) NOT NULL,
    credits         INT NOT NULL CHECK (credits > 0),
    department      VARCHAR(50),
    teacher_id      INT,
    max_students    INT DEFAULT 30,
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id   INT PRIMARY KEY,
    student_id      INT NOT NULL,
    course_id       INT NOT NULL,
    semester        VARCHAR(20) NOT NULL,
    year            INT NOT NULL,
    grade           VARCHAR(2),
    enrollment_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    UNIQUE (student_id, course_id, semester, year)
);

CREATE TABLE IF NOT EXISTS attendance (
    attendance_id   INT PRIMARY KEY,
    student_id      INT NOT NULL,
    course_id       INT NOT NULL,
    date            DATE NOT NULL,
    status          VARCHAR(10) CHECK (status IN ('present', 'absent', 'late', 'excused')),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE IF NOT EXISTS assignments (
    assignment_id   INT PRIMARY KEY,
    course_id       INT NOT NULL,
    title           VARCHAR(200) NOT NULL,
    max_score       INT NOT NULL,
    due_date        DATE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE IF NOT EXISTS submissions (
    submission_id   INT PRIMARY KEY,
    assignment_id   INT NOT NULL,
    student_id      INT NOT NULL,
    score           INT,
    submitted_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Sample data
INSERT INTO students VALUES (1, 'Alice', 'Smith', '2000-05-15', 'alice@school.edu', '555-1001', '2022-09-01', 'active');
INSERT INTO students VALUES (2, 'Bob', 'Jones', '2001-03-22', 'bob@school.edu', '555-1002', '2022-09-01', 'active');
INSERT INTO teachers VALUES (1, 'Dr. Sarah', 'Brown', 'sbrown@school.edu', 'Computer Science', '2018-08-15');
INSERT INTO courses VALUES (101, 'CS101', 'Intro to Programming', 4, 'Computer Science', 1, 30);
INSERT INTO courses VALUES (102, 'CS201', 'Database Systems', 3, 'Computer Science', 1, 25);
INSERT INTO enrollments VALUES (1, 1, 101, 'Fall', 2025, NULL, '2025-08-20');
INSERT INTO enrollments VALUES (2, 2, 101, 'Fall', 2025, NULL, '2025-08-21');
INSERT INTO enrollments VALUES (3, 1, 102, 'Fall', 2025, NULL, '2025-08-20');
INSERT INTO assignments VALUES (1, 101, 'SQL Basics', 100, '2025-09-15');
INSERT INTO submissions VALUES (1, 1, 1, 95, '2025-09-14');

SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM enrollments;
