--Implement User Defined Functions (UDF) in SQL (Intermediate)

-- Part – A:  

--1. Implement scalar function to return "Welcome to DBMS Lab".
	CREATE OR ALTER FUNCTION FUN_SCALAR()
	RETURNS VARCHAR(50)
	AS
	BEGIN
		RETURN 'Welcome to DBMS Lab'
	END;

	SELECT DBO.FUN_SCALAR();

--2. Implement scalar function to calculate simple interest.
	CREATE OR ALTER FUNCTION FUN_INTEREST
	( @P INT,@R DECIMAL,@T INT )
	RETURNS DECIMAL
	AS
	BEGIN
    RETURN (@P*@R*@T)/100;
	END;

	SELECT DBO.FUN_INTEREST(5000,1,5) AS INTEREST;

--3. Implement scalar function to find difference in days between two dates.
	CREATE OR ALTER FUNCTION FUN_DATE
	( @DATE1 DATE,@DATE2 DATE )
	RETURNS INT
	AS
	BEGIN
    RETURN DATEDIFF(DAY, @DATE1, @DATE2);
	END;

	SELECT DBO.FUN_DATE('2022-01-22', '2022-01-23') AS DifferenceInDays;


--4. Implement scalar function to check whether number is odd or even. 
	CREATE OR ALTER FUNCTION CHECK_NUM
	( @NUM INT )
	RETURNS VARCHAR(50)
	AS
	BEGIN

--FIRST WAY

   -- RETURN 
			--CASE 
			--	WHEN @NUM%2 = 0 THEN 'EVEN'
			--	ELSE 'ODD'
			--END;

--SECOND WAY

		DECLARE @RESULT VARCHAR(50)

		IF @NUM%2=0 
			SET @RESULT='EVEN'
		ELSE
			SET @RESULT='ODD'

		RETURN @RESULT
	END;

	SELECT DBO.CHECK_NUM(8) AS 'ODD OR EVEN';
	SELECT DBO.CHECK_NUM(5) AS 'ODD OR EVEN';

--5. Implement scalar function to print numbers from 1 to N.
	CREATE OR ALTER FUNCTION PRINT_NUM
	(
		@NUM INT
	)
	RETURNS VARCHAR(100)
	AS
	BEGIN
		DECLARE @I INT = 1;
		DECLARE @ST VARCHAR(100) = '';

		WHILE @I <= @NUM
		BEGIN
			SET @ST = @ST +' ' +CAST(@I AS VARCHAR(10));
			SET @I = @I + 1;
		END;

		RETURN @ST;
	END;


	SELECT DBO.PRINT_NUM(5) ;

 
--Part – B:  

--6. Implement scalar function to calculate factorial of given number.
	CREATE OR ALTER FUNCTION FACTORIAL
	( @NUM INT )
	RETURNS INT
	AS
	BEGIN
		DECLARE @I INT = 1;
		DECLARE @ANS INT = 1;


		WHILE @I<=@NUM
		BEGIN
			SET @ANS = @ANS * @I;
			SET @I = @I+1;
		END;
		RETURN @ANS;
	END;

	SELECT DBO.FACTORIAL(5) AS FACTORIAL ;

--7. Implement scalar function to check palindrome number. 
	CREATE OR ALTER FUNCTION PALINDROME_CHECK
	( @NUM INT )
	RETURNS VARCHAR(50)
	AS
	BEGIN
		DECLARE @I INT = 2;
		DECLARE @COUNT INT = 0;
		DECLARE @RESULT VARCHAR(50);

		WHILE @I < @NUM
		BEGIN
			IF @NUM % @I = 0
			BEGIN
				SET @COUNT = @COUNT + 1;
				SET @I = @I + 1;
			END;

			ELSE
				SET @I = @I + 1;
		END;

		IF @COUNT = 0
			SET @RESULT = 'PALINDROME'
		ELSE
			SET @RESULT = 'NOT PALINDROME'

		RETURN @RESULT;
	END;

	SELECT DBO.PALINDROME_CHECK(13) AS 'PALINDROME OR NOT' ;
	SELECT DBO.PALINDROME_CHECK(30) AS 'PALINDROME OR NOT' ;

--8. Implement scalar function to find maximum of three numbers.
	CREATE OR ALTER FUNCTION MAX_CHECK
	( @A INT, @B INT, @C INT )
	RETURNS INT
	AS
	BEGIN
		DECLARE @ANS INT;

	--FIRST WAY

		--IF @A > @B
		--BEGIN
		--	IF @A > @C
		--		SET @ANS = @A 
		--	ELSE
		--		SET @ANS = @C
		--END;

		--ELSE
		--BEGIN
		--	IF @B > @C
		--		SET @ANS = @B 
		--	ELSE
		--		SET @ANS = @C
		--END;

	--SECOND WAY

		SET @ANS=@A

		IF @B > @ANS
			SET @ANS = @B

		IF @C > @ANS
			SET @ANS = @C
			
		RETURN @ANS;
	END;

	SELECT DBO.MAX_CHECK(1,9,6) AS 'MAXIMUM NUMBER' ;

--9. Implement scalar function to calculate square and cube of a number. 
	CREATE OR ALTER FUNCTION SQURE_CUBE
	(
		@NUM INT
	)
	RETURNS VARCHAR(100)
	AS
	BEGIN
		DECLARE @SQURE INT;
		DECLARE @CUBE INT;

		SET @SQURE = @NUM * @NUM;
		SET @CUBE = @NUM * @NUM * @NUM;

		RETURN 'Square = ' + CAST(@SQURE AS VARCHAR(20)) +
				', Cube = ' + CAST(@CUBE AS VARCHAR(20));
	END;


	SELECT DBO.SQURE_CUBE(5) AS INTEREST;
	
 
--From the table EMPLOYEE perform the following queries:  

--Part – C:  

select * from employee

--10. Implement scalar function to return employee full details using EID.
	CREATE OR ALTER FUNCTION USING_EID
	( @EID INT )
	RETURNS TABLE
	AS
	RETURN	(	SELECT * FROM EMPLOYEE
				WHERE EID = @EID )


	SELECT * FROM USING_EID(101) ;

--11. Implement scalar function to return highest salary from a given department.
	CREATE OR ALTER FUNCTION DEPARTMENT_MAXSALARY
	( @DEPARTMENT VARCHAR(50) )
	RETURNS INT
	AS
	BEGIN
	RETURN	(	SELECT MAX(SALARY) FROM EMPLOYEE
				WHERE DEPARTMENT = @DEPARTMENT )
	END;
	
	SELECT  DBO.DEPARTMENT_MAXSALARY('ADMIN') AS MAX_SALARY;

--12. Implement scalar function to count total employees in EMPLOYEE table.
	CREATE OR ALTER FUNCTION COUNT_EMPLOYEE ( )
	RETURNS INT
	AS
	BEGIN
	RETURN	(	SELECT COUNT(EID) FROM EMPLOYEE )
	END;

	SELECT DBO.COUNT_EMPLOYEE() AS TOTAL_EMPLOYEE;

--13. Implement scalar function to find total experience of employee using JoiningYear.
	CREATE OR ALTER FUNCTION EXPERIENCE 
	(@EID INT)
	RETURNS INT
	AS
	BEGIN
	RETURN	(	SELECT ( YEAR(GETDATE())- JOININGYEAR ) FROM EMPLOYEE WHERE EID = @EID)
	END;

	SELECT DBO.EXPERIENCE(105) AS TOTAL_EXPERIENCE;


--14. Implement scalar function to return total number of employees in a given department.
	CREATE OR ALTER FUNCTION COUNT_DEPARTMENT_EMPLOYEE 
	(  @DEPARTMENT VARCHAR(50) )
	RETURNS INT
	AS
	BEGIN
	RETURN	(	SELECT COUNT(EID) FROM EMPLOYEE
				WHERE DEPARTMENT = @DEPARTMENT )
	END;

	SELECT DBO.COUNT_DEPARTMENT_EMPLOYEE('HR') AS TOTAL_DEPARTMENT_EMPLOYEE ;

--15. Implement scalar function to count total employees from a given city.
	CREATE OR ALTER FUNCTION COUNT_CITY_EMPLOYEE 
	(  @CITY VARCHAR(50) )
	RETURNS INT
	AS
	BEGIN
	RETURN	(	SELECT COUNT(EID) FROM EMPLOYEE
				WHERE CITY = @CITY )
	END;

	SELECT DBO.COUNT_CITY_EMPLOYEE('RAJKOT') AS TOTAL_DEPARTMENT_EMPLOYEE ;