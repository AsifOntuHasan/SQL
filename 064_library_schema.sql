-- ============================================================
-- 064: Library Schema - books, members, loans, fines
-- Real-world library management database
-- ============================================================

CREATE TABLE IF NOT EXISTS authors (
    author_id   INT PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    birth_year  INT
);

CREATE TABLE IF NOT EXISTS books (
    book_id     INT PRIMARY KEY,
    isbn        VARCHAR(20) UNIQUE NOT NULL,
    title       VARCHAR(200) NOT NULL,
    author_id   INT,
    publisher   VARCHAR(100),
    publish_year INT,
    genre       VARCHAR(50),
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

CREATE TABLE IF NOT EXISTS members (
    member_id   INT PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    email       VARCHAR(100) UNIQUE,
    phone       VARCHAR(20),
    join_date   DATE DEFAULT CURRENT_DATE,
    status      VARCHAR(20) DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS loans (
    loan_id     INT PRIMARY KEY,
    book_id     INT NOT NULL,
    member_id   INT NOT NULL,
    loan_date   DATE DEFAULT CURRENT_DATE,
    due_date    DATE NOT NULL,
    return_date DATE,
    status      VARCHAR(20) DEFAULT 'active',
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE IF NOT EXISTS fines (
    fine_id     INT PRIMARY KEY,
    loan_id     INT NOT NULL,
    amount      DECIMAL(6,2) NOT NULL,
    paid        INT DEFAULT 0,
    imposed_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

CREATE TABLE IF NOT EXISTS reservations (
    reservation_id INT PRIMARY KEY,
    book_id        INT NOT NULL,
    member_id      INT NOT NULL,
    reserve_date   DATE DEFAULT CURRENT_DATE,
    status         VARCHAR(20) DEFAULT 'active',
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Sample data
INSERT INTO authors VALUES (1, 'George', 'Orwell', 1903), (2, 'J.K.', 'Rowling', 1965), (3, 'Jane', 'Austen', 1775);
INSERT INTO books VALUES (1, '978-0451524935', '1984', 1, 'Secker', 1949, 'Dystopian', 5, 5);
INSERT INTO books VALUES (2, '978-0747532699', 'Harry Potter and the Sorcerer''s Stone', 2, 'Bloomsbury', 1997, 'Fantasy', 3, 3);
INSERT INTO books VALUES (3, '978-0141439518', 'Pride and Prejudice', 3, 'Penguin', 1813, 'Romance', 2, 2);
INSERT INTO members VALUES (1, 'Alice', 'Smith', 'alice@lib.com', '555-0101', '2024-01-15', 'active');
INSERT INTO members VALUES (2, 'Bob', 'Jones', 'bob@lib.com', '555-0102', '2024-03-20', 'active');
INSERT INTO loans VALUES (1, 1, 1, '2025-01-10', '2025-01-31', NULL, 'active');
INSERT INTO loans VALUES (2, 2, 2, '2025-01-15', '2025-02-05', '2025-02-01', 'returned');
INSERT INTO fines VALUES (1, 1, 2.50, 0, '2025-02-01');

SELECT * FROM books;
SELECT * FROM members;
SELECT * FROM loans;
