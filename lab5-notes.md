# Lab 5 Notes: Peer Tutoring Hub Database

**GitHub Repository:** https://github.com/joshstott24-beep/lab5

The full script is in `tutoring.sql`. I ran it in GitHub Codespaces using:

```bash
sqlite3 tutoring.db < tutoring.sql | tee lab5-output.txt
```

## Part 1: Create the Database Tables

**SQL statements:**

```sql
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
```

**Output of `.tables` and `.schema`:**

```text
===== Part 1: Create tables =====
--- .tables ---
      name
-----------------
students
tutoring_requests
--- .schema ---
CREATE TABLE students (
  student_id INTEGER PRIMARY KEY,
  student_name TEXT NOT NULL,
  student_email TEXT NOT NULL UNIQUE
);
CREATE TABLE tutoring_requests (
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
```

**Which column is the primary key in each table?**

The primary key for the students table is student_id, and the primary key for the tutoring_requests table is request_id. Each one identifies a specific row.

**Which column is the foreign key, and what relationship does it represent?**

The foreign key is student_id in the tutoring_requests table. It links a request to the student who made it. A student can have more than one request.

**Why is student_email marked UNIQUE?**

So two students can’t be entered with the same email address.

## Part 2: Insert Students and Tutoring Requests

**INSERT statements:**

```sql
INSERT INTO students (student_name, student_email)
VALUES ('Jordan Lee', 'jordan.lee@example.edu');

INSERT INTO students (student_name, student_email)
VALUES ('Avery Patel', 'avery.patel@example.edu');

INSERT INTO tutoring_requests (student_id, course, topic, preferred_date, preferred_time)
VALUES (1, 'IS 6465', 'Forms', '2026-11-16', '15:00');

INSERT INTO tutoring_requests (student_id, course, topic, preferred_date, preferred_time)
VALUES (1, 'IS 6465', 'SQL SELECT', '2026-11-18', '10:00');

INSERT INTO tutoring_requests (student_id, course, topic, preferred_date, preferred_time)
VALUES (2, 'IS 6465', 'SQLite CRUD', '2026-11-17', '13:00');
```

**`SELECT * FROM students;` and `SELECT * FROM tutoring_requests;` output:**

```text
--- 3.1 All students ---
student_id  student_name       student_email
----------  ------------  -----------------------
         1  Jordan Lee    jordan.lee@example.edu
         2  Avery Patel   avery.patel@example.edu

--- 3.2 All tutoring requests ---
request_id  student_id  course      topic     preferred_date  preferred_time  status      created_at
----------  ----------  -------  -----------  --------------  --------------  ------  -------------------
         1           1  IS 6465  Forms        2026-11-16      15:00           Open    2026-11-09 02:30:04
         2           1  IS 6465  SQL SELECT   2026-11-18      10:00           Open    2026-11-09 02:30:04
         3           2  IS 6465  SQLite CRUD  2026-11-17      13:00           Open    2026-11-09 02:30:04
```

**Explanation of the results:**

All three requests were added as Open. The database filled in the creation timestamps automatically.

**Why does Jordan have one student row but two request rows?**

Jordan is one student, but submitted two requests. Both requests point to the same student_id, so we don’t have to enter Jordan’s information twice.

## Part 3: Read the Stored Data

**1. All rows in students** (output shown in Part 2)

```sql
SELECT * FROM students;
```

**2. All rows in tutoring_requests** (output shown in Part 2)

```sql
SELECT * FROM tutoring_requests;
```

**3. Requests with a status of Open**

```sql
SELECT * FROM tutoring_requests
WHERE status = 'Open';
```

```text
--- 3.3 Open requests ---
request_id  student_id  course      topic     preferred_date  preferred_time  status      created_at
----------  ----------  -------  -----------  --------------  --------------  ------  -------------------
         1           1  IS 6465  Forms        2026-11-16      15:00           Open    2026-11-09 02:30:04
         2           1  IS 6465  SQL SELECT   2026-11-18      10:00           Open    2026-11-09 02:30:04
         3           2  IS 6465  SQLite CRUD  2026-11-17      13:00           Open    2026-11-09 02:30:04
```

**4. One request by request_id**

```sql
SELECT * FROM tutoring_requests
WHERE request_id = 2;
```

```text
--- 3.4 Request with request_id = 2 ---
request_id  student_id  course     topic     preferred_date  preferred_time  status      created_at
----------  ----------  -------  ----------  --------------  --------------  ------  -------------------
         2           1  IS 6465  SQL SELECT  2026-11-18      10:00           Open    2026-11-09 02:30:04
```

**5. JOIN request list ordered by preferred_date**

```sql
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
```

```text
--- 3.5 JOIN request list ---
request_id  student_name       student_email       course      topic     preferred_date  preferred_time  status
----------  ------------  -----------------------  -------  -----------  --------------  --------------  ------
         1  Jordan Lee    jordan.lee@example.edu   IS 6465  Forms        2026-11-16      15:00           Open
         3  Avery Patel   avery.patel@example.edu  IS 6465  SQLite CRUD  2026-11-17      13:00           Open
         2  Jordan Lee    jordan.lee@example.edu   IS 6465  SQL SELECT   2026-11-18      10:00           Open
```

**What does the JOIN condition connect?**

It matches student_id in both tables so the results show each request with the student’s name and email.

**What is the difference between the purpose of JOIN and WHERE?**

JOIN pulls related data from both tables. WHERE narrows down which rows show up.

**Why should the application retrieve one request by request_id instead of by topic alone?**

More than one request could have the same topic. request_id identifies the exact request we want.

## Part 4: Update One Request

**UPDATE statements:**

```sql
-- Revise Jordan's Forms request (new date and time)
UPDATE tutoring_requests
SET preferred_date = '2026-11-19',
    preferred_time = '16:00'
WHERE request_id = 1;

-- Cancel Avery's request
UPDATE tutoring_requests
SET status = 'Cancelled'
WHERE request_id = 3;
```

**Before and after the revision** (`SELECT * FROM tutoring_requests WHERE request_id = 1;`):

```text
--- 4.1 Before update (request_id = 1) ---
request_id  student_id  course   topic  preferred_date  preferred_time  status      created_at
----------  ----------  -------  -----  --------------  --------------  ------  -------------------
         1           1  IS 6465  Forms  2026-11-16      15:00           Open    2026-11-09 02:30:04

--- 4.2 After update (request_id = 1) ---
request_id  student_id  course   topic  preferred_date  preferred_time  status      created_at
----------  ----------  -------  -----  --------------  --------------  ------  -------------------
         1           1  IS 6465  Forms  2026-11-19      16:00           Open    2026-11-09 02:30:04
```

**Avery's Cancelled status** (`SELECT * FROM tutoring_requests WHERE request_id = 3;`):

```text
--- 4.3 Avery request after cancelling (request_id = 3) ---
request_id  student_id  course      topic     preferred_date  preferred_time   status        created_at
----------  ----------  -------  -----------  --------------  --------------  ---------  -------------------
         3           2  IS 6465  SQLite CRUD  2026-11-17      13:00           Cancelled  2026-11-09 02:30:04
```

**Why is a specific WHERE clause essential in an UPDATE statement?**

Without WHERE, every request could get updated. Using request_id changes only the one we picked.

**Why does the Peer Tutoring Hub use a Cancelled status instead of immediately deleting a real request?**

Cancelling keeps the request in the database, so there’s still a record of what happened.

## Part 5: Delete One Test Request

**INSERT statement for the test request:**

```sql
INSERT INTO tutoring_requests (student_id, course, topic, preferred_date, preferred_time)
VALUES (1, 'IS 6465', 'Delete Practice', '2026-11-20', '09:00');
```

**DELETE statement:**

```sql
DELETE FROM tutoring_requests
WHERE request_id = 4;
```

**Verification** (`SELECT * FROM tutoring_requests;` before and after the DELETE):

```text
--- 5.1 Before delete ---
request_id  student_id  course        topic       preferred_date  preferred_time   status        created_at
----------  ----------  -------  ---------------  --------------  --------------  ---------  -------------------
         1           1  IS 6465  Forms            2026-11-19      16:00           Open       2026-11-09 02:30:04
         2           1  IS 6465  SQL SELECT       2026-11-18      10:00           Open       2026-11-09 02:30:04
         3           2  IS 6465  SQLite CRUD      2026-11-17      13:00           Cancelled  2026-11-09 02:30:04
         4           1  IS 6465  Delete Practice  2026-11-20      09:00           Open       2026-11-09 02:30:04

--- 5.2 After delete ---
request_id  student_id  course      topic     preferred_date  preferred_time   status        created_at
----------  ----------  -------  -----------  --------------  --------------  ---------  -------------------
         1           1  IS 6465  Forms        2026-11-19      16:00           Open       2026-11-09 02:30:04
         2           1  IS 6465  SQL SELECT   2026-11-18      10:00           Open       2026-11-09 02:30:04
         3           2  IS 6465  SQLite CRUD  2026-11-17      13:00           Cancelled  2026-11-09 02:30:04
```

The test record (request_id 4, Delete Practice) is gone after the DELETE, and requests 1–3 remain.

**Why is a WHERE clause essential in a DELETE statement?**

Without WHERE, DELETE would wipe out every request. The request_id makes sure we only delete the test row.

## Part 6: Reflect on the CRUD Workflow

| CRUD Action | SQL Statement | Peer Tutoring Hub Example |
|---|---|---|
| Create | INSERT INTO | Adding students and tutoring requests |
| Read | SELECT | Retrieving tutoring requests and student information |
| Update | UPDATE | Changing a request date or cancelling a request |
| Delete | DELETE | Removing a test tutoring request |

**How does the database preserve the connection between a student and that student’s requests?**

Each request stores a student_id that points to the students table. The foreign key makes sure it refers to a real student.

**Which database constraint prevents two student rows from using the same email address?**

The UNIQUE constraint on student_email.

**What could happen if an UPDATE or DELETE statement did not include a WHERE clause?**

It could update or delete every row instead of just the one we meant to change.

**When the application later receives values from an HTML form, why should PHP send those values as parameters instead of placing them directly into SQL text?**

Parameters keep form input separate from the SQL command, which helps prevent SQL injection.
