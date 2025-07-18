-- TaskTracker Database Setup Script
-- Run this script in Oracle SQL Developer

-- Step 1: Create a dedicated user for the TaskTracker application
-- (Run this as SYSTEM or a user with CREATE USER privilege)

-- Uncomment and modify the following lines if you want to create a new user:
/*
CREATE USER tasktracker_user IDENTIFIED BY your_password_here;
GRANT CONNECT, RESOURCE TO tasktracker_user;
GRANT CREATE TABLE TO tasktracker_user;
GRANT CREATE SESSION TO tasktracker_user;
GRANT UNLIMITED TABLESPACE TO tasktracker_user;
*/

-- Step 2: Create the tasks table
-- (Run this as the tasktracker_user or your preferred user)

-- Drop table if it exists (optional - uncomment if you want to recreate)
-- DROP TABLE tasks CASCADE CONSTRAINTS;

-- Create the tasks table
CREATE TABLE tasks (
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

-- Step 3: Create indexes for better performance
CREATE INDEX idx_tasks_taskno ON tasks(TaskNo);
CREATE INDEX idx_tasks_status ON tasks(Status);
CREATE INDEX idx_tasks_owner ON tasks(TaskOwner);
CREATE INDEX idx_tasks_created_date ON tasks(CreatedDate);

-- Step 4: Create a sequence for TaskNo (optional - for auto-incrementing task numbers)
CREATE SEQUENCE task_no_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Step 5: Insert sample data (optional)
INSERT INTO tasks (
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
    'This is a sample task for testing the API.',
    'Pending',
    1,
    'John Doe',
    CURRENT_TIMESTAMP,
    'Admin'
);

-- Step 6: Commit the changes
COMMIT;

-- Step 7: Verify the table structure
DESCRIBE tasks;

-- Step 8: Verify sample data
SELECT * FROM tasks;

-- Step 9: Show table information
SELECT 
    table_name,
    column_name,
    data_type,
    data_length,
    nullable,
    data_default
FROM user_tab_columns 
WHERE table_name = 'TASKS'
ORDER BY column_id; 

-- If you are sure all descriptions are less than 4000 bytes:
ALTER TABLE tasks MODIFY (TaskDescription VARCHAR2(4000));