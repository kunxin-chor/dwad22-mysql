-- UPDATE allows us to update a row
update students SET name="Christopher Tan" WHERE student_id = 1;

-- UPDATE MANY COLUMNS
UPDATE parents SET name="Gurmit Phua", contact_number="11223344"
WHERE parent_id = 2;

-- Insert a parent which we will remove later
INSERT INTO parents (name, contact_number) 
VALUES ("Roti Prata Guy", "10010001");

-- DELETE A ROW
DELETE FROM parents WHERE parent_id = 3;

-- DELETE MULTIPLE
-- Delete all students from parent id 1
DELETE FROM students where parent_id = 1;

