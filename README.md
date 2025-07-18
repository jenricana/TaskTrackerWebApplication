# Task Tracker

A full-stack Task Tracker application with an Oracle database backend and a React frontend.

---

## Table of Contents
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Backend Setup](#backend-setup)
- [Database Setup](#database-setup)
- [Frontend Setup](#frontend-setup)
- [Usage](#usage)
- [API Endpoints](#api-endpoints)
- [Troubleshooting](#troubleshooting)

---

## Features
- Add, list, complete, and delete tasks
- Filter tasks (All / Completed / Incomplete)
- Simple form validation
- React frontend with plain CSS
- Oracle database backend

---

## Prerequisites
- Node.js (v14+ recommended)
- npm
- Oracle Database (XE or higher)
- SQL Developer or similar tool

---

## Backend Setup

1. **Clone or download this repository.**
2. **Install dependencies:**
   ```bash
   npm install
   ```
3. **Configure environment variables:**
   - Edit `config.env` with your Oracle DB credentials and connection string.
4. **Enable CORS:**
   - CORS is enabled by default in `index.js` with `app.use(cors());`.
5. **Start the backend server:**
   ```bash
   node index.js
   ```
   - The server runs on [http://localhost:5000](http://localhost:5000)

---

## Database Setup

1. **Create the tasks table:**
   - Use the provided `quick_setup.sql` script in SQL Developer:
     ```sql
     @quick_setup.sql
     ```
2. **(Optional) Change TaskDescription to VARCHAR2:**
   If you want `TaskDescription` as VARCHAR2  run:
   ```sql
   ALTER TABLE tasks ADD (TaskDescription2 VARCHAR2(4000));
   UPDATE tasks SET TaskDescription2 = DBMS_LOB.SUBSTR(TaskDescription, 4000, 1);
   COMMIT;
   ALTER TABLE tasks DROP COLUMN TaskDescription;
   ALTER TABLE tasks RENAME COLUMN TaskDescription2 TO TaskDescription;
   ```
3. **Verify the table:**
   ```sql
   SELECT * FROM tasks;
   ```

---

## Frontend Setup

1. **Navigate to the frontend folder:**
   ```bash
   cd ../task-tracker-frontend
   ```
2. **Install dependencies:**
   ```bash
   npm install
   npm install axios
   ```
3. **Start the React app:**
   ```bash
   npm start
   ```
   - The app runs on [http://localhost:3000](http://localhost:3000)

---

## Usage
- Open [http://localhost:3000](http://localhost:3000) in your browser.
- Add, complete, delete, and filter tasks using the UI.
- All changes are reflected in the Oracle database via the backend API.

---

## API Endpoints

- `GET    /tasklist`           - List all tasks
- `GET    /tasklist/:id`       - Get a task by ID
- `POST   /tasklist`           - Add a new task
- `PATCH  /tasklist/:id`       - Update a task
- `DELETE /tasklist/:id`       - Delete a task

---

## Troubleshooting

- **CORS errors:** Ensure `app.use(cors())` is present in `index.js` and the backend is running.
- **Database errors:** Double-check your Oracle credentials and that the `tasks` table exists.
- **Port conflicts:** Make sure nothing else is running on ports 5000 (backend) or 3000 (frontend).
- **Frontend errors:** Ensure `axios` is installed (`npm install axios`).

---

## Credits
- Built with Node.js, Express, OracleDB, and React. 