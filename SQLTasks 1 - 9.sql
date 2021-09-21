/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 1 of the case study, which means that there'll be more guidance for you about how to 
setup your local SQLite connection in PART 2 of the case study. 

The questions in the case study are exactly the same as with Tier 2. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT name
FROM Facilities
WHERE membercost > 0.0;

output:
('Tennis Court 1'),
('Tennis Court 2'),
('Massage Room 1'),
('Massage Room 2'),
('Squash Court');

/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(name)
FROM Facilities
WHERE membercost = 0;

output:
(4);

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance 
FROM Facilities
WHERE membercost > 0 AND membercost < monthlymaintenance*.2;

output:
(0, 'Tennis Court 1', 5.0, 200),
(1, 'Tennis Court 2', 5.0, 200),
(4, 'Massage Room 1', 9.9, 3000),
(5, 'Massage Room 2', 9.9, 3000),
(6, 'Squash Court', 3.5, 80);


/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT *
FROM Facilities
WHERE facid = 1 OR facid = 5

output:
(1, 'Tennis Court 2', 5.0, 25.0, 8000, 200),
(5, 'Massage Room 2', 9.9, 80.0, 4000, 3000);


/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance,
CASE WHEN monthlymaintenance <= 100 THEN 'cheap'
    ELSE 'expensive' END AS cheap_or_expensive
FROM Facilities;

output:
('Tennis Court 1', 200, 'expensive'),
('Tennis Court 2', 200, 'expensive'),
('Badminton Court', 50, 'cheap'),
('Table Tennis', 10, 'cheap'),
('Massage Room 1', 3000, 'expensive'),
('Massage Room 2', 3000, 'expensive'),
('Squash Court', 80, 'cheap'),
('Snooker Table', 15, 'cheap'),
('Pool Table', 15, 'cheap');


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT firstname, surname, joindate
FROM Members
WHERE joindate = 
	(SELECT MAX(joindate)
     FROM Members);

output:
('Darren', 'Smith', '2012-09-26 18:08:45');


/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT 
		CONCAT_WS(' ', m.firstname, m.surname) as name,
		Facilities.name as facility
FROM Members as m 
JOIN Bookings ON m.memid = Bookings.memid
JOIN Facilities ON Facilities.facid = Bookings.facid
WHERE Facilities.name LIKE 'Tennis%'
ORDER BY m.surname;


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT f.name AS facility, CONCAT_WS(' ', firstname, surname) AS member_name,
CASE WHEN m.memid = 0 THEN guestcost * slots
	 ELSE membercost * slots END AS cost_of_booking 
FROM Members AS m,
	 Facilities AS f, 
	 Bookings AS b
WHERE b.starttime LIKE '2012-09-14%' AND (guestcost*slots > 30 AND membercost*slots > 30)
ORDER BY cost_of_booking DESC;


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT *
FROM (SELECT name, surname,
      CASE WHEN name = 'GUEST' THEN guestcost 
      ELSE membercost END AS cost_of_booking
      FROM Bookings
      LEFT JOIN Members USING(memid)
      LEFT JOIN Facilities USING(facid)
      WHERE starttime LIKE '2012-09-14%') AS sub
WHERE cost_of_booking > 30;




 


