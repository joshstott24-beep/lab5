-- Lab 5: Peer Tutoring Hub Database
-- Run from the lab5 folder with:  sqlite3 tutoring.db < tutoring.sql

-- Display settings: show column headers and line up output in columns
.headers on
.mode column

-- Enforce the foreign key between tutoring_requests and students
PRAGMA foreign_keys = ON;

-- Reset so the script can be rerun without duplicate rows or "table already exists" errors
DROP TABLE IF EXISTS tutoring_requests;
DROP TABLE IF EXISTS students;


-- ============================================================
-- Part 1: Create tables
-- ============================================================
.print '===== Part 1: Create tables ====='

CREATE TABLE IF NOT EXISTS students (
  student_id INTEGER PRIMARY KEY,
  student_name TEXT NOT NULL,
  student_email TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS tutoring_requests (
  request_id INTEGER PRIMARY KEY,
  student_id INTEGER NOT NULL,
  course TEXT NOT NULL,
  topic TEXT NOT NULL,
  preferred_date TEXT NOT NULL,
  preferred_time TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'Open',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(student_id)
);

.print '--- .tables ---'
.tables
.print '--- .schema ---'
.schema


-- ============================================================
-- Part 2: Insert students and tutoring requests
-- ============================================================
.print ''
.print '===== Part 2: Insert students and tutoring requests ====='

-- Insert each student once (Jordan becomes student_id 1, Avery becomes student_id 2)
INSERT INTO students (student_name, student_email)
VALUES ('Jordan Lee', 'jordan.lee@example.edu');

INSERT INTO students (student_name, student_email)
VALUES ('Avery Patel', 'avery.patel@example.edu');

-- Insert the requests using each student's student_id
INSERT INTO tutoring_requests (student_id, course, topic, preferred_date, preferred_time)
VALUES (1, 'IS 6465', 'Forms', '2026-11-16', '15:00');

INSERT INTO tutoring_requests (student_id, course, topic, preferred_date, preferred_time)
VALUES (1, 'IS 6465', 'SQL SELECT', '2026-11-18', '10:00');

INSERT INTO tutoring_requests (student_id, course, topic, preferred_date, preferred_time)
VALUES (2, 'IS 6465', 'SQLite CRUD', '2026-11-17', '13:00');


-- ============================================================
-- Part 3: Read the stored data
-- ============================================================
.print ''
.print '===== Part 3: Read the stored data ====='

-- 1. All rows in students
.print '--- 3.1 All students ---'
SELECT * FROM students;

-- 2. All rows in tutoring_requests
.print ''
.print '--- 3.2 All tutoring requests ---'
SELECT * FROM tutoring_requests;

-- 3. Only requests with a status of Open
.print ''
.print '--- 3.3 Open requests ---'
SELECT * FROM tutoring_requests
WHERE status = 'Open';

-- 4. One request by its request_id
.print ''
.print '--- 3.4 Request with request_id = 2 ---'
SELECT * FROM tutoring_requests
WHERE request_id = 2;

-- 5. Request list using a JOIN, ordered by preferred_date
.print ''
.print '--- 3.5 JOIN request list ---'
SELECT
  r.request_id,
  s.student_name,
  s.student_email,
  r.course,
  r.topic,
  r.preferred_date,
  r.preferred_time,
  r.status
FROM tutoring_requests AS r
JOIN students AS s ON r.student_id = s.student_id
ORDER BY r.preferred_date;


-- ============================================================
-- Part 4: Update one request
-- ============================================================
.print ''
.print '===== Part 4: Update one request ====='

-- Before: Jordan's Forms request
.print '--- 4.1 Before update (request_id = 1) ---'
SELECT * FROM tutoring_requests
WHERE request_id = 1;

-- Revise Jordan's Forms request (new date and time)
UPDATE tutoring_requests
SET preferred_date = '2026-11-19',
    preferred_time = '16:00'
WHERE request_id = 1;

-- After: Jordan's Forms request
.print ''
.print '--- 4.2 After update (request_id = 1) ---'
SELECT * FROM tutoring_requests
WHERE request_id = 1;

-- Cancel Avery's request
UPDATE tutoring_requests
SET status = 'Cancelled'
WHERE request_id = 3;

.print ''
.print '--- 4.3 Avery request after cancelling (request_id = 3) ---'
SELECT * FROM tutoring_requests
WHERE request_id = 3;


-- ============================================================
-- Part 5: Delete one test request
-- ============================================================
.print ''
.print '===== Part 5: Delete one test request ====='

-- Insert a clearly labeled test request (becomes request_id 4)
INSERT INTO tutoring_requests (student_id, course, topic, preferred_date, preferred_time)
VALUES (1, 'IS 6465', 'Delete Practice', '2026-11-20', '09:00');

.print '--- 5.1 Before delete ---'
SELECT * FROM tutoring_requests;

-- Delete only the test request
DELETE FROM tutoring_requests
WHERE request_id = 4;

.print ''
.print '--- 5.2 After delete ---'
SELECT * FROM tutoring_requests;