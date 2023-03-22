-- create a new database; we must create the database before we can use it
create database swimming_coach; 

-- switch our active database to what we have just created
use swimming_coach;

-- to see all tables in the current databases
show tables;

-- `create table` command is to create a new table
-- the `engine = innodb` is needed for foregin keys
CREATE TABLE parents (
    parent_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_number VARCHAR(8)
) engine = innodb;

-- see the columns in a table
DESCRIBE parents;

-- create the students table first
-- then set the foregin key
CREATE TABLE students (
    student_id MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    swimming_level TINYINT,
    date_of_birth DATETIME,
    -- only creating the parent_id column at this point
    -- still have to set the foregin key
    parent_id INT UNSIGNED NOT NULL
) engine = innodb;

-- Now we set the foregin key such that the parent_id column
-- in the students table must refer to a valid row in the parents table

-- ALTER TABLE <name of the table> ADD CONSTRAINT <name of the constraint>
ALTER TABLE students ADD CONSTRAINT fk_students_parents
  FOREIGN KEY (parent_id) REFERENCES parents(parent_id);

-- insert some parents
-- to insert new rows into a table, we use the `INSERT INTO <table name>` command
INSERT INTO parents (name, contact_number) VALUES ("Tan Ah Kow", "11223344");
-- the following works because contact_number column in parents table
-- is nullable
INSERT INTO parents (name) VALUES ("Phua Chua Kang");
-- to see all the rows in a table
SELECT * FROM parents;

-- insert a new student
INSERT INTO students (name, swimming_level, date_of_birth, parent_id) 
    VALUES ("Tan Ah Boy", 0, "2022-01-03", 1); 

-- the following won't work because there is no parent with the parent_id of 99
INSERT INTO students(name, swimming_level, date_of_birth, parent_id)
    VALUES("Tan Ah Girl", 0, "2022-01-03", 99);

-- the following will work because there is a parent with parent_id of 1
INSERT INTO students(name, swimming_level, date_of_birth, parent_id)
    VALUES("Tan Ah Girl", 0, "2022-01-03", 1);

-- Change an existing column definition
-- for example, change the contact number in the parents table to varchar(11)
ALTER TABLE parents MODIFY COLUMN contact_number VARCHAR(11);

DROP TABLE asd;