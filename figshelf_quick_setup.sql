-- FigShelf Quick Setup Script
-- Run this in Oracle SQL Developer as SYSTEM or a user with CREATE USER privilege

-- Create FigShelf user
CREATE USER FigShelf IDENTIFIED BY FigShelf123;

-- Grant privileges
GRANT CONNECT, RESOURCE TO FigShelf;
GRANT CREATE TABLE TO FigShelf;
GRANT CREATE SESSION TO FigShelf;
GRANT UNLIMITED TABLESPACE TO FigShelf;

-- Connect as FigShelf and create table
-- (You'll need to create a new connection with FigShelf credentials)

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

-- Create indexes
CREATE INDEX FigShelf.idx_tasks_taskno ON FigShelf.tasks(TaskNo);
CREATE INDEX FigShelf.idx_tasks_status ON FigShelf.tasks(Status);

-- Insert sample data
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

COMMIT;

-- Verify the setup
SELECT * FROM FigShelf.tasks; 