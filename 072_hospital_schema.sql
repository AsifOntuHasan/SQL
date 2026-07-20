-- ============================================================
-- 072: Hospital Schema - patients, doctors, appointments, billing
-- Healthcare management database design
-- ============================================================

CREATE TABLE IF NOT EXISTS patients (
    patient_id      INT PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    date_of_birth   DATE,
    gender          VARCHAR(10),
    blood_type      VARCHAR(5),
    phone           VARCHAR(20),
    email           VARCHAR(100),
    address         TEXT,
    emergency_contact VARCHAR(100),
    insurance_id    VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS doctors (
    doctor_id       INT PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    specialization  VARCHAR(100),
    license_number  VARCHAR(50) UNIQUE,
    phone           VARCHAR(20),
    email           VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS departments_hospital (
    dept_id         INT PRIMARY KEY,
    dept_name       VARCHAR(100) NOT NULL,
    head_doctor_id  INT,
    floor           INT,
    FOREIGN KEY (head_doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE IF NOT EXISTS appointments (
    appointment_id  INT PRIMARY KEY,
    patient_id      INT NOT NULL,
    doctor_id       INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME,
    status          VARCHAR(20) DEFAULT 'scheduled',
    reason          TEXT,
    notes           TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE IF NOT EXISTS diagnoses (
    diagnosis_id    INT PRIMARY KEY,
    appointment_id  INT NOT NULL,
    icd_code        VARCHAR(20),
    description     TEXT,
    diagnosed_date  DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

CREATE TABLE IF NOT EXISTS prescriptions (
    prescription_id INT PRIMARY KEY,
    diagnosis_id    INT,
    medication_name VARCHAR(100) NOT NULL,
    dosage          VARCHAR(50),
    frequency       VARCHAR(50),
    start_date      DATE,
    end_date        DATE,
    prescribing_doctor INT,
    FOREIGN KEY (diagnosis_id) REFERENCES diagnoses(diagnosis_id),
    FOREIGN KEY (prescribing_doctor) REFERENCES doctors(doctor_id)
);

CREATE TABLE IF NOT EXISTS billing (
    bill_id         INT PRIMARY KEY,
    patient_id      INT NOT NULL,
    appointment_id  INT,
    service_date    DATE,
    total_amount    DECIMAL(10,2),
    insurance_covered DECIMAL(10,2) DEFAULT 0,
    patient_amount  DECIMAL(10,2),
    paid            INT DEFAULT 0,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

CREATE TABLE IF NOT EXISTS lab_results (
    result_id       INT PRIMARY KEY,
    patient_id      INT NOT NULL,
    doctor_id       INT NOT NULL,
    test_name       VARCHAR(100),
    result_value    VARCHAR(100),
    reference_range VARCHAR(100),
    test_date       DATE,
    status          VARCHAR(20) DEFAULT 'pending',
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- Sample data
INSERT INTO patients VALUES (1, 'Alice', 'Smith', '1985-04-15', 'F', 'O+', '555-3001', 'alice@mail.com', '123 Main St', 'Bob Smith', 'INS-001');
INSERT INTO patients VALUES (2, 'Bob', 'Jones', '1990-07-22', 'M', 'A-', '555-3002', 'bob@mail.com', '456 Oak Ave', 'Mary Jones', 'INS-002');
INSERT INTO doctors VALUES (1, 'Dr. Sarah', 'Brown', 'Cardiology', 'LIC-1001', '555-4001', 'sbrown@hospital.com');
INSERT INTO doctors VALUES (2, 'Dr. David', 'Wilson', 'Pediatrics', 'LIC-1002', '555-4002', 'dwilson@hospital.com');
INSERT INTO appointments VALUES (1, 1, 1, '2025-02-15', '10:00', 'completed', 'Chest pain', 'Normal ECG');
INSERT INTO appointments VALUES (2, 2, 2, '2025-02-20', '14:30', 'scheduled', 'Annual checkup', NULL);
INSERT INTO diagnoses VALUES (1, 1, 'I10', 'Hypertension', '2025-02-15');
INSERT INTO prescriptions VALUES (1, 1, 'Lisinopril', '10mg', 'Once daily', '2025-02-15', '2025-05-15', 1);
INSERT INTO billing VALUES (1, 1, 1, '2025-02-15', 500.00, 350.00, 150.00, 0);

SELECT * FROM patients;
SELECT * FROM doctors;
SELECT * FROM appointments;
