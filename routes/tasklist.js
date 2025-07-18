import express from 'express';
import { v4 as uuidv4 } from 'uuid';
import { getConnection } from '../config/database.js';
import oracledb from 'oracledb';

const router = express.Router();

// GET all tasks
router.get('/', async (req, res) => {
  const connection = await getConnection();
  try {
    const result = await connection.execute(
      'SELECT * FROM tasks ORDER BY CreatedDate DESC',
      [],
      { outFormat: oracledb.OUT_FORMAT_OBJECT }
    );
    const tasks = result.rows;
    const processedTasks = await Promise.all(tasks.map(async (task) => {
      return task;
    }));
    res.json(processedTasks);
  } catch (error) {
    console.error('Error fetching tasks:', error);
    res.status(500).json({ error: 'Failed to fetch tasks' });
  } finally {
    await connection.close();
  }
});

// GET task by ID
router.get('/:id', async (req, res) => {
  const { id } = req.params;
  const connection = await getConnection();
  try {
    const result = await connection.execute(
      'SELECT * FROM tasks WHERE TaskId = :id',
      [id],
      { outFormat: oracledb.OUT_FORMAT_OBJECT }
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Task not found' });
    }

    const task = result.rows[0];
    res.json(task);
  } catch (error) {
    console.error('Error fetching task:', error);
    res.status(500).json({ error: 'Failed to fetch task' });
  } finally {
    await connection.close();
  }
});

// Create a new task
router.post('/', async (req, res) => {
  const task = req.body;
  const taskId = uuidv4();
  const connection = await getConnection();
  
  try {
    const result = await connection.execute(
      `INSERT INTO tasks (TaskId, TaskNo, TaskName, TaskDescription, Status, ActiveStatus, TaskOwner, CreatedDate, CreatedBy)
       VALUES (:TaskId, :TaskNo, :TaskName, :TaskDescription, :Status, :ActiveStatus, :TaskOwner, :CreatedDate, :CreatedBy)`,
      {
        TaskId: taskId,
        TaskNo: task.TaskNo,
        TaskName: task.TaskName,
        TaskDescription: task.TaskDescription,
        Status: task.Status || 'Pending',
        ActiveStatus: task.ActiveStatus ? 1 : 0,
        TaskOwner: task.TaskOwner,
        CreatedDate: new Date(),
        CreatedBy: task.CreatedBy
      }
    );
    
    await connection.commit();
    res.status(201).json({ 
      message: `${task.TaskName} has been added to the Task List`,
      taskId: taskId 
    });
  } catch (error) {
    console.error('Error creating task:', error);
    res.status(500).json({ error: 'Failed to create task' });
  } finally {
    await connection.close();
  }
});

// Update a task by TaskId
router.patch('/:id', async (req, res) => {
  const { id } = req.params;
  const updates = req.body;
  const connection = await getConnection();
  
  try {
    // Build dynamic update query
    const updateFields = [];
    const bindVars = { TaskId: id };
    
    if (updates.TaskNo !== undefined) {
      updateFields.push('TaskNo = :TaskNo');
      bindVars.TaskNo = updates.TaskNo;
    }
    if (updates.TaskName !== undefined) {
      updateFields.push('TaskName = :TaskName');
      bindVars.TaskName = updates.TaskName;
    }
    if (updates.TaskDescription !== undefined) {
      updateFields.push('TaskDescription = :TaskDescription');
      bindVars.TaskDescription = updates.TaskDescription;
    }
    if (updates.Status !== undefined) {
      updateFields.push('Status = :Status');
      bindVars.Status = updates.Status;
    }
    if (updates.ActiveStatus !== undefined) {
      updateFields.push('ActiveStatus = :ActiveStatus');
      bindVars.ActiveStatus = updates.ActiveStatus ? 1 : 0;
    }
    if (updates.TaskOwner !== undefined) {
      updateFields.push('TaskOwner = :TaskOwner');
      bindVars.TaskOwner = updates.TaskOwner;
    }
    
    if (updateFields.length === 0) {
      return res.status(400).json({ error: 'No valid fields to update' });
    }
    
    const updateSQL = `UPDATE tasks SET ${updateFields.join(', ')} WHERE TaskId = :TaskId`;
    const result = await connection.execute(updateSQL, bindVars);
    
    if (result.rowsAffected === 0) {
      return res.status(404).json({ error: 'Task not found' });
    }
    
    await connection.commit();
    res.json({ message: `Task with ID ${id} has been updated` });
  } catch (error) {
    console.error('Error updating task:', error);
    res.status(500).json({ error: 'Failed to update task' });
  } finally {
    await connection.close();
  }
});

// Delete a task by TaskId
router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  const connection = await getConnection();
  
  try {
    const result = await connection.execute(
      'DELETE FROM tasks WHERE TaskId = :id',
      [id]
    );
    
    if (result.rowsAffected === 0) {
      return res.status(404).json({ error: 'Task not found' });
    }
    
    await connection.commit();
    res.json({ message: `Task with ID ${id} deleted successfully` });
  } catch (error) {
    console.error('Error deleting task:', error);
    res.status(500).json({ error: 'Failed to delete task' });
  } finally {
    await connection.close();
  }
});

export default router; 