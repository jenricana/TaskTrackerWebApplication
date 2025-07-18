-- FigShelf Schema Setup for TaskTracker
-- Run this script in Oracle SQL Developer as SYSTEM or a user with CREATE USER privilege

-- Step 1: Create the FigShelf user/schema
CREATE USER FigShelf IDENTIFIED BY FigShelf123;

-- Step 2: Grant necessary privileges to FigShelf
GRANT CONNECT, RESOURCE TO FigShelf;
GRANT CREATE TABLE TO FigShelf;
GRANT CREATE SESSION TO FigShelf;
GRANT CREATE VIEW TO FigShelf;
GRANT CREATE SEQUENCE TO FigShelf;
GRANT UNLIMITED TABLESPACE TO FigShelf;

-- Step 3: Connect to FigShelf schema (you'll need to create a new connection)
-- In SQL Developer: Right-click on "Oracle Connections" -> "New Connection"
-- Connection Name: FigShelf
-- Username: FigShelf
-- Password: FigShelf123
-- Hostname: localhost
-- Port: 1521
-- SID/Service Name: XE (or your database SID)

-- Step 4: Create the tasks table in FigShelf schema
-- (Run this part after connecting as FigShelf user)

CREATE TABLE FigShelf.tasks (
    TaskId VARCHAR2(36) PRIMARY KEY,
    TaskNo VARCHAR2(50) NOT NULL,
    TaskName VARCHAR2(200) NOT NULL,
    TaskDescription CLOB,
    Status VARCHAR2(50) DEFAULT 'Pending',
    ActiveStatus NUMBER(1) DEFAULT 1,
    TaskOwner VARCHAR2(100),
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CreatedBy VARCHAR2(100)
);

-- Step 5: Create indexes for better performance
CREATE INDEX FigShelf.idx_tasks_taskno ON FigShelf.tasks(TaskNo);
CREATE INDEX FigShelf.idx_tasks_status ON FigShelf.tasks(Status);
CREATE INDEX FigShelf.idx_tasks_owner ON FigShelf.tasks(TaskOwner);
CREATE INDEX FigShelf.idx_tasks_created_date ON FigShelf.tasks(CreatedDate);

-- Step 6: Create a sequence for TaskNo (optional)
CREATE SEQUENCE FigShelf.task_no_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Step 7: Insert sample data
INSERT INTO FigShelf.tasks (
    TaskId, 
    TaskNo, 
    TaskName, 
    TaskDescription, 
    Status, 
    ActiveStatus, 
    TaskOwner, 
    CreatedDate, 
    CreatedBy
) VALUES (
    '550e8400-e29b-41d4-a716-446655440000',
    'TASK-001',
    'Sample Task',
    'This is a sample task for testing the FigShelf API.',
    'Pending',
    1,
    'John Doe',
    CURRENT_TIMESTAMP,
    'Admin'
);

-- Step 8: Commit the changes
COMMIT;

-- Step 9: Verify the table structure
DESCRIBE FigShelf.tasks;

-- Step 10: Verify sample data
SELECT * FROM FigShelf.tasks;

-- Step 11: Show table information
SELECT 
    table_name,
    column_name,
    data_type,
    data_length,
    nullable,
    data_default
FROM all_tab_columns 
WHERE owner = 'FIGSHELF' AND table_name = 'TASKS'
ORDER BY column_id; 