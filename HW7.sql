-- Create tables
CREATE TABLE STUDENT (
    Student_number INT PRIMARY KEY,
    Name VARCHAR2(50) NOT NULL,
    Class INT,
    Major VARCHAR2(10)
);

CREATE TABLE COURSE (
    Course_number VARCHAR2(10) PRIMARY KEY,
    Course_name VARCHAR2(50) UNIQUE,
    Credit_hours INT,
    Department VARCHAR2(10)
);

CREATE TABLE PREREQUISITE (
    Course_number VARCHAR2(10),
    Prerequisite_number VARCHAR2(10),
    PRIMARY KEY (Course_number, Prerequisite_number),
    FOREIGN KEY (Course_number) REFERENCES COURSE(Course_number), 
    FOREIGN KEY (Prerequisite_number) REFERENCES COURSE(Course_number)
);

CREATE TABLE SECTION (
    Section_identifier INT PRIMARY KEY,
    Course_number VARCHAR2(10) NOT NULL,
    Semester VARCHAR2(10) NOT NULL,
    Year INT NOT NULL,
    Instructor VARCHAR2(50),
    FOREIGN KEY (Course_number) REFERENCES COURSE(Course_number)
);

CREATE TABLE GRADE_REPORT (
    Student_number INT,
    Section_identifier INT,
    Grade CHAR(1),
    PRIMARY KEY (Student_number, Section_identifier),
    FOREIGN KEY (Student_number) REFERENCES STUDENT(Student_number),
    FOREIGN KEY (Section_identifier) REFERENCES SECTION(Section_identifier)
);

COMMIT;

-- Insert into STUDENT
INSERT INTO STUDENT VALUES (17, 'Smith', 1, 'CS');
INSERT INTO STUDENT VALUES (8, 'Brown', 2, 'CS');

-- Insert into COURSE 
INSERT INTO COURSE VALUES ('CS1310', 'Intro to Computer Science', 4, 'CS');
INSERT INTO COURSE VALUES ('CS3320', 'Data Structures', 4, 'CS');
INSERT INTO COURSE VALUES ('MATH2410', 'Discrete Mathematics', 3, 'MATH');
INSERT INTO COURSE VALUES ('CS3380', 'Database', 3, 'CS');

-- Insert into PREREQUISITE 
INSERT INTO PREREQUISITE VALUES ('CS3380', 'CS3320');
INSERT INTO PREREQUISITE VALUES ('CS3380', 'MATH2410');
INSERT INTO PREREQUISITE VALUES ('CS3320', 'CS1310');

-- Insert  into SECTION
INSERT INTO SECTION VALUES (85, 'MATH2410', 'Fall', 2007, 'King');
INSERT INTO SECTION VALUES (92, 'CS1310', 'Fall', 2007, 'Anderson');
INSERT INTO SECTION VALUES (102, 'CS3320', 'Spring', 2008, 'Knuth');
INSERT INTO SECTION VALUES (112, 'MATH2410', 'Fall', 2008, 'Chang');
INSERT INTO SECTION VALUES (119, 'CS1310', 'Fall', 2008, 'Anderson');
INSERT INTO SECTION VALUES (135, 'CS3380', 'Fall', 2008, 'Stone');

-- Insert into GRADE_REPORT 
INSERT INTO GRADE_REPORT VALUES (17, 112, 'B');
INSERT INTO GRADE_REPORT VALUES (17, 119, 'C');
INSERT INTO GRADE_REPORT VALUES (8, 85, 'A');
INSERT INTO GRADE_REPORT VALUES (8, 92, 'A');
INSERT INTO GRADE_REPORT VALUES (8, 102, 'B');
INSERT INTO GRADE_REPORT VALUES (8, 135, 'A');

COMMIT;

-- Retrieve name and grade of students who took 'Discrete Mathematics' in Fall 
-- 2008
SELECT S.Name, G.Grade
FROM GRADE_REPORT G
JOIN STUDENT S ON G.Student_number = S.Student_number
JOIN SECTION SEC ON G.Section_identifier = SEC.Section_identifier
JOIN COURSE C ON SEC.Course_number = C.Course_number
WHERE C.Course_name = 'Discrete Mathematics'
  AND SEC.Semester = 'Fall'
  AND SEC.Year = 2008;

-- Update grade
UPDATE GRADE_REPORT
SET Grade = 'A'
WHERE Student_number = 8 AND Section_identifier = 102;

ROLLBACK;

-- Violate primary key constraint
INSERT INTO STUDENT VALUES (8, 'Joe', 6, 'CS');

-- Violate entity integrity (NULL value in non-null column)
INSERT INTO SECTION VALUES (195, NULL, 'fall', 2007, 'JoeShmo');

-- Violate referential integrity on DELETE
DELETE FROM STUDENT WHERE Student_number = 17;

-- Violate primary key uniqueness on UPDATE
UPDATE STUDENT SET Student_number = 8 WHERE Student_number = 17;

-- Violate referential integrity on UPDATE
UPDATE GRADE_REPORT SET Student_number = 5 WHERE Student_number = 8;

-- Drop tables in correct order
DROP TABLE GRADE_REPORT;
DROP TABLE SECTION;
DROP TABLE PREREQUISITE;
DROP TABLE COURSE;
DROP TABLE STUDENT;

-- Final commit
COMMIT;
