-- Create wth database
CREATE DATABASE wth;

-- Create a user Contosoapp that would own the application data for migration

CREATE USER if not exists 'contosoapp'   identified by 'OCPHack8' ;

GRANT SUPER on *.* to contosoapp identified by 'OCPHack8'; -- may not be needed

GRANT ALL PRIVILEGES ON wth.* to contosoapp ;

-- Show tables in wth database - should be empty now

USE wth ;

SHOW TABLES;
