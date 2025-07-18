import oracledb from 'oracledb';

// Database configuration
const dbConfig = {
  user: process.env.DB_USER || 'figshelf',
  password: process.env.DB_PASSWORD || 'password',
  connectString: process.env.DB_CONNECT_STRING || 'localhost:1521/XE',
  poolMin: 10,
  poolMax: 10,
  poolIncrement: 0
};

// Initialize the Oracle driver
oracledb.initOracleClient();

// Create connection pool
let pool;

export const initializeDatabase = async () => {
  try {
    pool = await oracledb.createPool(dbConfig);
    console.log('Oracle database pool created successfully');
    
    // Create the tasks table if it doesn't exist
    await createTasksTable();
    
    return pool;
  } catch (error) {
    console.error('Error initializing database:', error);
    throw error;
  }
};

export const getConnection = async () => {
  try {
    const connection = await pool.getConnection();
    return connection;
  } catch (error) {
    console.error('Error getting database connection:', error);
    throw error;
  }
};

export const closePool = async () => {
  try {
    await pool.close();
    console.log('Database pool closed successfully');
  } catch (error) {
    console.error('Error closing database pool:', error);
  }
};

// Create tasks table
const createTasksTable = async () => {
  const connection = await getConnection();
  try {
    const createTableSQL = `
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
      )
    `;
    
    await connection.execute(createTableSQL);
    await connection.commit();
    console.log('Tasks table created successfully');
  } catch (error) {
    // Table might already exist, which is fine
    if (error.code === 955) { // ORA-00955: name is already being used
      console.log('Tasks table already exists');
    } else {
      console.error('Error creating tasks table:', error);
    }
  } finally {
    await connection.close();
  }
};

export default {
  initializeDatabase,
  getConnection,
  closePool
}; 