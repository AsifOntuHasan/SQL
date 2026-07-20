-- ============================================================
-- 067: School Queries - grades, attendance, course statistics
-- ============================================================

CREATE TABLE IF NOT EXISTS students (
    student_id  INT PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    status      VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS courses (
    course_id   INT PRIMARY KEY,
    course_code VARCHAR(20),
    title       VARCHAR(200),
    credits     INT,
    teacher_id  INT
);

CREATE TABLE IF NOT EXISTS teachers (
    teacher_id  INT PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    department  VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id    INT,
    course_id     INT,
    semester      VARCHAR(20),
    year          INT,
    grade         VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS attendance (
    attendance_id INT PRIMARY KEY,
    student_id    INT,
    course_id     INT,
    date          DATE,
    status        VARCHAR(10)
);

INSERT INTO students VALUES (1, 'Alice', 'Smith', 'active'), (2, 'Bob', 'Jones', 'active'), (3, 'Charlie', 'Brown', 'active');
INSERT INTO teachers VALUES (1, 'Sarah', 'Brown', 'CS'), (2, 'David', 'Wilson', 'Math');
INSERT INTO courses VALUES (101, 'CS101', 'Intro Programming', 4, 1), (102, 'MATH101', 'Calculus I', 3, 2);
INSERT INTO enrollments VALUES (1, 1, 101, 'Fall', 2025, 'A'), (2, 2, 101, 'Fall', 2025, 'B+'), (3, 1, 102, 'Fall', 2025, 'A-'), (4, 3, 101, 'Fall', 2025, 'C');
INSERT INTO attendance VALUES (1, 1, 101, '2025-09-01', 'present'), (2, 2, 101, '2025-09-01', 'absent'), (3, 1, 101, '2025-09-02', 'present');

-- Student course rosters
SELECT c.course_code, c.title,
       s.first_name || ' ' || s.last_name AS student,
       e.grade
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
ORDER BY c.course_code, s.last_name;

-- Grade distribution
SELECT c.course_code, e.grade, COUNT(*) AS student_count
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
WHERE e.grade IS NOT NULL
GROUP BY c.course_code, e.grade
ORDER BY c.course_code, e.grade;

-- Student GPA calculation
SELECT s.first_name || ' ' || s.last_name AS student,
       COUNT(e.enrollment_id) AS courses_taken,
       ROUND(AVG(CASE e.grade
           WHEN 'A'  THEN 4.0 WHEN 'A-' THEN 3.7
           WHEN 'B+' THEN 3.3 WHEN 'B'  THEN 3.0 WHEN 'B-' THEN 2.7
           WHEN 'C+' THEN 2.3 WHEN 'C'  THEN 2.0 WHEN 'C-' THEN 1.7
           WHEN 'D'  THEN 1.0 WHEN 'F'  THEN 0.0
           ELSE NULL END), 2) AS gpa
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.grade IS NOT NULL
GROUP BY s.student_id
ORDER BY gpa DESC;

-- Attendance summary
SELECT s.first_name || ' ' || s.last_name AS student,
       COUNT(a.attendance_id) AS total_classes,
       SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) AS present,
       SUM(CASE WHEN a.status = 'absent' THEN 1 ELSE 0 END) AS absent,
       ROUND(100.0 * SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attendance_pct
FROM students s
JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id
ORDER BY attendance_pct DESC;

-- Course enrollment counts
SELECT c.course_code, c.title, c.max_students,
       COUNT(e.enrollment_id) AS enrolled,
       c.max_students - COUNT(e.enrollment_id) AS available_seats
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id AND e.semester = 'Fall' AND e.year = 2025
GROUP BY c.course_id
ORDER BY available_seats;

-- Teacher course load
SELECT t.first_name || ' ' || t.last_name AS teacher,
       COUNT(c.course_id) AS courses_taught,
       GROUP_CONCAT(c.course_code, ', ') AS course_codes
FROM teachers t
JOIN courses c ON t.teacher_id = c.teacher_id
GROUP BY t.teacher_id;

-- Cleanup
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS students;
