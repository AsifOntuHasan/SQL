-- ============================================================
-- 073: Hospital Queries - patient care, scheduling, billing
-- ============================================================

CREATE TABLE IF NOT EXISTS patients (
    patient_id  INT PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    date_of_birth DATE,
    insurance_id VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS doctors (
    doctor_id   INT PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    specialization VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS appointments (
    appointment_id  INT PRIMARY KEY,
    patient_id      INT,
    doctor_id       INT,
    appointment_date DATE,
    status          VARCHAR(20),
    reason          TEXT
);

CREATE TABLE IF NOT EXISTS diagnoses (
    diagnosis_id INT PRIMARY KEY,
    appointment_id INT,
    icd_code     VARCHAR(20),
    description  TEXT
);

CREATE TABLE IF NOT EXISTS billing (
    bill_id         INT PRIMARY KEY,
    patient_id      INT,
    total_amount    DECIMAL(10,2),
    patient_amount  DECIMAL(10,2),
    paid            INT
);

INSERT INTO patients VALUES (1, 'Alice', 'Smith', '1985-04-15', 'INS-001'), (2, 'Bob', 'Jones', '1990-07-22', 'INS-002');
INSERT INTO doctors VALUES (1, 'Sarah', 'Brown', 'Cardiology'), (2, 'David', 'Wilson', 'Pediatrics');
INSERT INTO appointments VALUES (1, 1, 1, '2025-02-15', 'completed', 'Chest pain'), (2, 2, 2, '2025-02-20', 'scheduled', 'Checkup'), (3, 1, 2, '2025-03-01', 'scheduled', 'Follow-up');
INSERT INTO diagnoses VALUES (1, 1, 'I10', 'Hypertension');
INSERT INTO billing VALUES (1, 1, 500, 150, 0), (2, 2, 200, 50, 1);

-- Today's appointments
SELECT a.appointment_date, a.appointment_time,
       p.first_name || ' ' || p.last_name AS patient,
       d.first_name || ' ' || d.last_name AS doctor,
       a.reason, a.status
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
WHERE a.appointment_date = '2025-02-20'
ORDER BY a.appointment_time;

-- Patient history (diagnoses + prescriptions)
SELECT p.first_name || ' ' || p.last_name AS patient,
       a.appointment_date, d.icd_code, d.description
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
JOIN diagnoses d ON a.appointment_id = d.appointment_id
ORDER BY p.last_name, a.appointment_date;

-- Doctor workload
SELECT d.first_name || ' ' || d.last_name AS doctor,
       COUNT(a.appointment_id) AS total_appointments,
       SUM(CASE WHEN a.status = 'scheduled' THEN 1 ELSE 0 END) AS upcoming,
       SUM(CASE WHEN a.status = 'completed' THEN 1 ELSE 0 END) AS completed
FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id
ORDER BY total_appointments DESC;

-- Outstanding patient balances
SELECT p.first_name || ' ' || p.last_name AS patient,
       COUNT(b.bill_id) AS bills,
       SUM(b.patient_amount) AS total_owed,
       SUM(CASE WHEN b.paid = 0 THEN b.patient_amount ELSE 0 END) AS unpaid
FROM patients p
JOIN billing b ON p.patient_id = b.patient_id
GROUP BY p.patient_id
ORDER BY unpaid DESC;

-- Most common diagnoses
SELECT d.icd_code, d.description, COUNT(*) AS occurrence_count
FROM diagnoses d
GROUP BY d.icd_code, d.description
ORDER BY occurrence_count DESC;

-- Patient demographics
SELECT CASE
           WHEN CAST((JULIANDAY('now') - JULIANDAY(date_of_birth)) / 365.25 AS INTEGER) < 18 THEN '0-17'
           WHEN CAST((JULIANDAY('now') - JULIANDAY(date_of_birth)) / 365.25 AS INTEGER) < 40 THEN '18-39'
           WHEN CAST((JULIANDAY('now') - JULIANDAY(date_of_birth)) / 365.25 AS INTEGER) < 65 THEN '40-64'
           ELSE '65+'
       END AS age_group, COUNT(*) AS patient_count
FROM patients
GROUP BY age_group
ORDER BY age_group;

-- Cleanup
DROP TABLE IF EXISTS billing;
DROP TABLE IF EXISTS diagnoses;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS patients;
