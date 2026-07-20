-- ============================================================
-- 008: CREATE TRIGGER - automatic actions on INSERT/UPDATE/DELETE
-- Note: Syntax varies significantly by database
-- ============================================================

CREATE TABLE IF NOT EXISTS audit_log (
    log_id      INT PRIMARY KEY,
    table_name  VARCHAR(50),
    action_type VARCHAR(20),
    record_id   INT,
    old_value   TEXT,
    new_value   TEXT,
    changed_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS accounts (
    account_id  INT PRIMARY KEY,
    balance     DECIMAL(12,2)
);

INSERT INTO accounts VALUES (1, 1000.00), (2, 500.00);

-- PostgreSQL: Trigger function + trigger
/*
CREATE OR REPLACE FUNCTION trg_audit_accounts()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log(log_id, table_name, action_type, record_id, new_value)
        VALUES (NEXTVAL('seq_log'), 'accounts', 'INSERT', NEW.account_id, ROW_TO_JSON(NEW)::TEXT);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log(log_id, table_name, action_type, record_id, old_value, new_value)
        VALUES (NEXTVAL('seq_log'), 'accounts', 'UPDATE', NEW.account_id,
                ROW_TO_JSON(OLD)::TEXT, ROW_TO_JSON(NEW)::TEXT);
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log(log_id, table_name, action_type, record_id, old_value)
        VALUES (NEXTVAL('seq_log'), 'accounts', 'DELETE', OLD.account_id, ROW_TO_JSON(OLD)::TEXT);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER accounts_audit
AFTER INSERT OR UPDATE OR DELETE ON accounts
FOR EACH ROW EXECUTE FUNCTION trg_audit_accounts();
*/

-- MySQL:
/*
CREATE TRIGGER accounts_audit_insert
AFTER INSERT ON accounts
FOR EACH ROW
BEGIN
    INSERT INTO audit_log(log_id, table_name, action_type, record_id, new_value)
    VALUES (NEXTVAL('seq_log'), 'accounts', 'INSERT', NEW.account_id, JSON_OBJECT('balance', NEW.balance));
END;
*/

-- SQL Server:
/*
CREATE TRIGGER trg_accounts_audit
ON accounts
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO audit_log(table_name, action_type, record_id, old_value, new_value)
    SELECT 'accounts', 'INSERT', i.account_id, NULL, (SELECT * FROM i FOR JSON PATH);
END;
*/

-- SQLite: Trigger
/*
CREATE TRIGGER IF NOT EXISTS trg_accounts_audit_insert
AFTER INSERT ON accounts
BEGIN
    INSERT INTO audit_log(table_name, action_type, record_id, new_value)
    VALUES ('accounts', 'INSERT', NEW.account_id, JSON_OBJECT('balance', NEW.balance));
END;
*/

-- Simulated trigger effect by manual insert
INSERT INTO audit_log (log_id, table_name, action_type, record_id, old_value, new_value)
VALUES (1, 'accounts', 'INSERT', 1, NULL, '{"balance": 1000.00}');

SELECT * FROM audit_log;

-- Cleanup
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS audit_log;
