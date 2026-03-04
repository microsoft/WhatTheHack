
INSERT INTO `departments_flat` 
SELECT `department` AS `row_key`, `department`, `description` FROM `departments`

