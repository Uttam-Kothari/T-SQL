--Implement Stored Procedures for Reusable SQL Operations.

--From the table STUDENT perform the following queries:  

--Part – A:  

--1. INSERT Procedures: Create stored procedures to insert records into STUDENT tables (SP_INSERT_STUDENT) 
--	STDID	SNAME	CITY	SPI		BRANCH 
--	115		PUSHTI	RAJKOT	9.48	COMPUTER 
--	116		NIKUNJ	SURAT	8.80	CHEMICAL 

	CREATE OR ALTER PROCEDURE SP_INSERT_STUDENT
	@ID INT ,
	@SNAME VARCHAR(50),
	@CITY VARCHAR(50),
	@SPI DECIMAL(5,2),
	@BRANCH VARCHAR(50) 
	AS
	BEGIN 
	INSERT INTO  STUDENT VALUES(@ID,@SNAME,@CITY,@SPI,@BRANCH);
	END ;


	EXEC SP_INSERT_STUDENT 115,'PUSHIT','RAJKOT',9.48,'COMPUTER'
	EXEC SP_INSERT_STUDENT 116,'NIKUNJ','SURAT',8.80,'CHEMICAL'

	SELECT * FROM STUDENT ;

--2. INSERT Procedures: Create stored procedures to insert records into DEPOSIT tables (SP_INSERT_DEPOSIT) 
--	ACTNO	CNAME	BNAME	AMOUNT	ADATE 
--	118		HEMENT	BEDI	16000	05-05-2025 
--	119		RAVI	MAVDI	24000	09-07-2024

	CREATE OR ALTER PROSCEDURE SP_INSERT_DEPOSIT
    @ACTNO INT,
    @CNAME VARCHAR(50),
    @BNAME VARCHAR(50),
    @AMOUNT DECIMAL(5,0),
    @ADATE DATE
	AS
	BEGIN
    INSERT INTO DEPOSIT
    VALUES (@ACTNO, @CNAME, @BNAME, @AMOUNT, @ADATE);	
	END;

	EXEC SP_INSERT_DEPOSIT 118,'HEMENT','BEDI',16000,'05-05-2025'
	EXEC SP_INSERT_DEPOSIT 119,'RAVI','MAVDI',24000,'09-07-2024'

	SELECT * FROM DEPOSIT

--3. UPDATE Procedures: Create stored procedure SP_UPDATE_STUDENT to update Branch in STUDENT table. (Update using studentID)                                    
--	STDID	BRANCH 
--	115		ELECTRICAL 
--	116		MECHANICAL 

	CREATE OR ALTER PROCEDURE SP_UPDATE_STUDENT
	@STDID INT ,
	@BRANCH VARCHAR(50)
	AS
	BEGIN 
	UPDATE STUDENT  SET BRANCH=@BRANCH
	WHERE STDID=@STDID
	END;


	EXEC SP_UPDATE_STUDENT 115,'ELECTRICAL'
	EXEC SP_UPDATE_STUDENT 116,'MECHANICAL'

	SELECT * FROM STUDENT


 
--4. DELETE Procedures: Create stored procedure SP_DELETE_STUDENT to delete records from STUDENT where Student Name is RAVI. 

	CREATE OR ALTER PROCEDURE SP_DELETE_STUDENT
	@SNAME VARCHAR(50)
	AS
	BEGIN 
	DELETE  STUDENT  
	WHERE SNAME=@SNAME
	END;

	EXEC SP_DELETE_STUDENT 'RAVI'
	
	SELECT * FROM STUDENT

--5. SELECT BY PRIMARY KEY: Create stored procedures to select records by primary key (SP_SELECT_STUDENT_BY_ID) from Student table. (Display All Columns) 
	
	CREATE OR ALTER PROCEDURE SP_SELECT_STUDENT_BY_ID
	@STDID INT
	AS
	BEGIN 
	SELECT * FROM STUDENT
	WHERE STDID = @STDID
	END;

	EXEC SP_SELECT_STUDENT_BY_ID 102

--6. Create a stored procedure that shows details of the first 5 students ordered by SPI (Highest First). 
	
	CREATE OR ALTER PROCEDURE SP_SELECT_STUDENT_TOP_5
	AS
	BEGIN 
	SELECT TOP 5 * FROM STUDENT
	ORDER BY SPI DESC
	END;

	EXEC SP_SELECT_STUDENT_TOP_5
 
--From the table EMPLOYEE perform the following queries:

--Part – B:   

--7. Create a stored procedure which displays all employee details.
	
	CREATE OR ALTER PROCEDURE SP_SELECT_EMPLOYEE
	AS
	BEGIN 
	SELECT * FROM EMPLOYEE
	END;

	EXEC SP_SELECT_EMPLOYEE
 
--8. Create a stored procedure that takes department name as input and returns all the employee in that department.
	
	CREATE OR ALTER PROCEDURE SP_SELECT_DEPARTMENT
	@DEPARTMENT VARCHAR(50)
	AS
	BEGIN 
	SELECT * FROM EMPLOYEE
	WHERE DEPARTMENT = @DEPARTMENT
	END;

	EXEC SP_SELECT_DEPARTMENT 'IT'

--Part – C:  

--9. Create a stored procedure which displays department-wise maximum, minimum, and average salary of employee. 
	
	CREATE OR ALTER PROCEDURE SP_SELECT_MAX_MIN_AVG
	@DEPARTMENT VARCHAR(50)
	AS
	BEGIN 
	SELECT MAX(SALARY),MIN(SALARY),AVG(SALARY) FROM EMPLOYEE
	WHERE DEPARTMENT = @DEPARTMENT
	END;

	EXEC SP_SELECT_MAX_MIN_AVG 'IT'

--10. Create a stored procedure that accepts department name as parameter and returns total salary of their department. 
	
	CREATE OR ALTER PROCEDURE SP_SELECT_TOTAL
	@DEPARTMENT VARCHAR(50)
	AS
	BEGIN 
	SELECT SUM(SALARY) FROM EMPLOYEE
	WHERE DEPARTMENT = @DEPARTMENT
	END;

	EXEC SP_SELECT_TOTAL 'IT'
