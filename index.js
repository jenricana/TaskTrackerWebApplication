import express from 'express';
import bodyParser from 'body-parser';
import dotenv from 'dotenv';
import { initializeDatabase, closePool } from './config/database.js';
import cors from 'cors';

// Load environment variables
dotenv.config({ path: './config.env' });

const app = express();
import taskListRoutes from './routes/tasklist.js'

const PORT = process.env.PORT || 5000;

app.use(bodyParser.json());
app.use(cors());

app.use('/tasklist', taskListRoutes);

app.get('/', (req, res) => res.send('HELLO FROM HOMEPAGE'))

// Initialize database and start server
const startServer = async () => {
  try {
    await initializeDatabase();
    app.listen(PORT, () => console.log(`Server running on port: http://localhost:${PORT}`));
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
};

// Graceful shutdown
process.on('SIGINT', async () => {
  console.log('\nShutting down gracefully...');
  await closePool();
  process.exit(0);
});

startServer();