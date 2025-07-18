-- Quick Setup Script for TaskTracker
-- Run this in Oracle SQL Developer

-- Create the tasks table
CREATE TABLE tasks (
    TaskId VARCHAR2(36) PRIMARY KEY,
    TaskNo VARCHAR2(50) NOT NULL,
    TaskName VARCHAR2(200) NOT NULL,
    TaskDescription VARCHAR2(200) NOT NULL,
    Status VARCHAR2(50) DEFAULT 'Pending',
    ActiveStatus NUMBER(1) DEFAULT 1,
    TaskOwner VARCHAR2(100),
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CreatedBy VARCHAR2(100)
);

-- Create basic indexes
CREATE INDEX idx_tasks_taskno ON tasks(TaskNo);
CREATE INDEX idx_tasks_status ON tasks(Status);

-- Insert a sample task
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

COMMIT;

-- Verify the setup
SELECT * FROM tasks; 