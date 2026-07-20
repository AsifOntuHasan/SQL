-- ============================================================
-- 065: Library Queries - book tracking, overdue, popular books
-- ============================================================

CREATE TABLE IF NOT EXISTS books (
    book_id         INT PRIMARY KEY,
    title           VARCHAR(200),
    author_id       INT,
    genre           VARCHAR(50),
    available_copies INT
);

CREATE TABLE IF NOT EXISTS authors (
    author_id   INT PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS members (
    member_id   INT PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    status      VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS loans (
    loan_id     INT PRIMARY KEY,
    book_id     INT,
    member_id   INT,
    loan_date   DATE,
    due_date    DATE,
    return_date DATE,
    status      VARCHAR(20)
);

INSERT INTO authors VALUES (1, 'George', 'Orwell'), (2, 'J.K.', 'Rowling');
INSERT INTO books VALUES (1, '1984', 1, 'Dystopian', 3), (2, 'Animal Farm', 1, 'Satire', 2), (3, 'Harry Potter 1', 2, 'Fantasy', 1);
INSERT INTO members VALUES (1, 'Alice', 'Smith', 'active'), (2, 'Bob', 'Jones', 'active'), (3, 'Charlie', 'Brown', 'suspended');
INSERT INTO loans VALUES (1, 1, 1, '2025-01-01', '2025-01-22', NULL, 'active'), (2, 2, 1, '2025-01-10', '2025-01-31', NULL, 'active'), (3, 3, 2, '2024-12-01', '2024-12-22', '2024-12-20', 'returned');

-- Currently borrowed books
SELECT b.title, m.first_name || ' ' || m.last_name AS borrower, l.loan_date, l.due_date
FROM loans l
JOIN books b ON l.book_id = b.book_id
JOIN members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL AND l.status = 'active'
ORDER BY l.due_date;

-- Overdue books (past due date)
SELECT b.title, m.first_name || ' ' || m.last_name AS borrower,
       l.due_date, CAST(JULIANDAY('now') - JULIANDAY(l.due_date) AS INTEGER) AS days_overdue
FROM loans l
JOIN books b ON l.book_id = b.book_id
JOIN members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL AND l.due_date < DATE('now')
ORDER BY days_overdue DESC;

-- Most popular books (by loan count)
SELECT b.title, a.first_name || ' ' || a.last_name AS author, COUNT(l.loan_id) AS times_borrowed
FROM books b
JOIN authors a ON b.author_id = a.author_id
LEFT JOIN loans l ON b.book_id = l.book_id
GROUP BY b.book_id
ORDER BY times_borrowed DESC;

-- Member borrowing history
SELECT m.first_name || ' ' || m.last_name AS member,
       COUNT(l.loan_id) AS total_loans,
       COUNT(CASE WHEN l.return_date IS NULL AND l.due_date < DATE('now') THEN 1 END) AS overdue_count
FROM members m
LEFT JOIN loans l ON m.member_id = l.member_id
GROUP BY m.member_id
ORDER BY total_loans DESC;

-- Available books (with copies on shelf)
SELECT b.title, b.available_copies
FROM books b
WHERE b.available_copies > 0
ORDER BY b.title;

-- Genre distribution
SELECT genre, COUNT(*) AS book_count
FROM books
GROUP BY genre
ORDER BY book_count DESC;

-- Track book availability (current vs total)
SELECT b.title, b.available_copies, b.total_copies,
       b.total_copies - b.available_copies AS currently_loaned
FROM books b
ORDER BY currently_loaned DESC;

-- Cleanup
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;
