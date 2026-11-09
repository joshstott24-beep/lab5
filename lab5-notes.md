Part 1: Create the Database Tables

Which column is the primary key in each table?

The primary key for the students table is student_id, and the primary key for the tutoring_requests table is request_id. These identify individual records in each table.

Which column is the foreign key, and what relationship does it represent?

The foreign key is student_id in the tutoring_requests table. It connects each tutoring request to a student in the students table. One student can have multiple tutoring requests.

Why is student_email marked UNIQUE?

The UNIQUE constraint prevents multiple students from being registered with the same email address. This helps prevent duplicate student records.

Part 2: Insert Students and Tutoring Requests

Explanation of the results:

The three requests were successfully added with a default status of Open. The database also automatically recorded when each request was created.

Why does Jordan have one student row but two request rows?

Jordan only needs one student record because both requests belong to the same person. The two tutoring requests are stored separately and connected to Jordan through student_id. This avoids storing the same student information multiple times.

Part 3: Read the Stored Data

What does the JOIN condition connect?

The JOIN connects the student_id in the tutoring_requests table with the matching student_id in the students table. This allows us to display student information alongside their tutoring requests.

What is the difference between the purpose of JOIN and WHERE?

JOIN combines related information from different tables, while WHERE filters the results based on specific conditions.

Why should the application retrieve one request by request_id instead of by topic alone?

Multiple students could submit requests for the same topic. Using request_id ensures that the correct request is retrieved because each request has a unique ID.

Part 4: Update One Request

Why is a specific WHERE clause essential in an UPDATE statement?

Without a WHERE clause, the UPDATE statement would change every record in the table. Using a specific request_id ensures that only the intended request is updated.

Why does the Peer Tutoring Hub use a Cancelled status instead of immediately deleting a real request?

Keeping cancelled requests allows the application to maintain a history of tutoring activity. This information could be useful for reporting or reviewing previous requests.

Part 5: Delete One Test Request

Why is a WHERE clause essential in a DELETE statement?

Without a WHERE clause, DELETE would remove every record from the table. Specifying the request_id ensures that only the test request is deleted.

Part 6: Reflect on the CRUD Workflow

CRUD Action	SQL Statement	Peer Tutoring Hub Example
Create	INSERT INTO	Adding students and tutoring requests
Read	SELECT	Retrieving tutoring requests and student information
Update	UPDATE	Changing a request date or cancelling a request
Delete	DELETE	Removing a test tutoring request

How does the database preserve the connection between a student and that student’s requests?

The database uses student_id as a foreign key in the tutoring_requests table. This connects each request to the correct student and helps maintain the relationship between the two tables.

Which database constraint prevents two student rows from using the same email address?

The UNIQUE constraint on student_email prevents duplicate email addresses.

What could happen if an UPDATE or DELETE statement did not include a WHERE clause?

Without a WHERE clause, the statement would affect every record in the table. This could result in accidentally changing or deleting information that should have been left alone.

When the application later receives values from an HTML form, why should PHP send those values as parameters instead of placing them directly into SQL text?

Using parameters helps prevent SQL injection by keeping user input separate from the SQL statements. This makes the application more secure and helps ensure user input is handled correctly.