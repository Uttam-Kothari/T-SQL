--Implement User Defined Functions (UDF) in SQL (Advanced) 

-- From the table STUDENT perform the following queries: 

--Part – A: 

--1. Create a table valued function to display all student records.
	CREATE OR ALTER FUNCTION FUN_STUDENT( )
	RETURNS TABLE
	AS
	RETURN ( SELECT * FROM STUDENT ) ;

	SELECT * FROM FUN_STUDENT () ;

--2. Create a table valued function that accepts CITY and returns all students from that city.
	CREATE OR ALTER FUNCTION USING_CITY
	( @CITY VARCHAR(50) )
	RETURNS TABLE
	AS
	RETURN (	SELECT * FROM STUDENT
				WHERE CITY = @CITY ) ;

	SELECT * FROM USING_CITY ('RAJKOT') ;

--3. Create a table valued function that accepts BRANCH and returns all students of that branch.
	CREATE OR ALTER FUNCTION USING_BRANCH
	( @BRANCH VARCHAR(50) )
	RETURNS TABLE
	AS
	RETURN (	SELECT * FROM STUDENT
				WHERE BRANCH = @BRANCH ) ;

	SELECT * FROM USING_BRANCH ('COMPUTER') ;

--4. Create a table valued function that accepts SPI and returns students whose SPI is greater than entered SPI.
	CREATE OR ALTER FUNCTION GREATER_SPI
	( @SPI DECIMAL )
	RETURNS TABLE
	AS
	RETURN (	SELECT * FROM STUDENT
				WHERE SPI > @SPI ) ;

	SELECT * FROM GREATER_SPI (7.30) ;
	

--5. Create a table valued function that accepts MIN_SPI and MAX_SPI and returns students whose SPI lies 
--between given range. 
	CREATE OR ALTER FUNCTION BETWEEN_SPI
	( @MIN_SPI FLOAT,@MAX_SPI FLOAT )
	RETURNS TABLE
	AS
	RETURN (	SELECT * FROM STUDENT
				WHERE SPI BETWEEN @MIN_SPI AND @MAX_SPI ) ;

	SELECT * FROM BETWEEN_SPI (7.30,7.40) ;

 
--Part – B:  

--6. Create a table valued function that accepts STDID and returns details of that student. 
	CREATE OR ALTER FUNCTION USING_STDID
	( @STDID INT )
	RETURNS TABLE
	AS
	RETURN (	SELECT * FROM STUDENT
				WHERE STDID = @STDID ) ;

	SELECT * FROM USING_STDID (101) ;

--7. Create a table valued function that accepts CITY and returns students whose SPI is greater than 7 from 
--that city. 
	CREATE OR ALTER FUNCTION CITY_SPI
	( @CITY VARCHAR(50) )
	RETURNS TABLE
	AS
	RETURN (	SELECT * FROM STUDENT
				WHERE CITY = @CITY AND SPI > 7 ) ;

	SELECT * FROM CITY_SPI ('RAJKOT') ;

--8. Create a table valued function that accepts BRANCH and returns students whose SPI is less than 8 from 
--that branch.
	CREATE OR ALTER FUNCTION BRANCH_SPI
	( @BRANCH VARCHAR(50) )
	RETURNS TABLE
	AS
	RETURN (	SELECT * FROM STUDENT
				WHERE BRANCH = @BRANCH AND SPI < 8 ) ;

	SELECT * FROM BRANCH_SPI ('COMPUTER') ;

--9. Create a table valued function that accepts TOP N and returns top N students based on SPI.
	CREATE OR ALTER FUNCTION FUN_TOP_N
	( @N INT )
	RETURNS TABLE
	AS
	RETURN (	SELECT TOP (@N) * FROM STUDENT
				ORDER BY SPI DESC ) ;

	SELECT * FROM FUN_TOP_N (5) ;

--10. Create a table valued function that accepts BRANCH and returns highest SPI student from that branch. 
	CREATE OR ALTER FUNCTION BRANCH_SPI
	( @BRANCH VARCHAR(50) )
	RETURNS TABLE
	AS
	RETURN (	SELECT * FROM STUDENT
				WHERE	BRANCH = @BRANCH 
						AND SPI = ( SELECT MAX(SPI)
									FROM STUDENT
									WHERE BRANCH = @BRANCH  ) )

	SELECT * FROM BRANCH_SPI ('COMPUTER') ;

--Part – C:  

--11. Create a table valued function that accepts CITY and returns total students from that city. 
	CREATE OR ALTER FUNCTION COUNT_CITY_STUDENT 
	(  @CITY VARCHAR(50) )
	RETURNS TABLE
	AS
	RETURN	(	SELECT * FROM STUDENT
				WHERE CITY = @CITY )

	SELECT COUNT(STDID) AS CITY_STUDENT FROM COUNT_CITY_STUDENT('RAJKOT') ;

--12. Create a table valued function that accepts BRANCH and returns students ordered by SPI in descending 
--order. 
	CREATE OR ALTER FUNCTION BRANCH_STUDENT_SPI 
	(  @BRANCH VARCHAR(50) )
	RETURNS TABLE
	AS
	RETURN	(	SELECT * FROM STUDENT
				WHERE BRANCH = @BRANCH )

	SELECT * FROM BRANCH_STUDENT_SPI('COMPUTER') 
	ORDER BY SPI DESC;

--13. Create a table valued function that accepts CITY and returns top 3 student from that city based on SPI.
	CREATE OR ALTER FUNCTION CITY_TOP3_STUDENT 
	(  @CITY VARCHAR(50) )
	RETURNS TABLE
	AS
	RETURN	(	SELECT * FROM STUDENT
				WHERE CITY = @CITY )

	SELECT TOP 3 * FROM CITY_TOP3_STUDENT('RAJKOT') 
	ORDER BY SPI DESC ;

--14. Create a table valued function that accepts STDID and returns student rank based on SPI (RANK). 
	CREATE OR ALTER FUNCTION STDID_RANK 
	(  @STDID INT )
	RETURNS TABLE
	AS
	RETURN	( SELECT * FROM ( SELECT *,
						RANK() OVER (ORDER BY SPI DESC) AS STUDENT_RANK
						FROM STUDENT
					) AS T
			WHERE STDID = @STDID )

	SELECT * FROM STDID_RANK(101) ;
	SELECT * FROM STUDENT
	
--15. Create a table valued function that accepts BRANCH and returns students having second highest SPI 
--from that branch.
	CREATE OR ALTER FUNCTION BRANCH_SPI 
	(  @BRANCH VARCHAR(50) )
	RETURNS TABLE
	AS
	RETURN	(SELECT * FROM	(SELECT *,
									RANK() OVER (PARTITION BY BRANCH ORDER BY SPI DESC) AS RANK 
									FROM STUDENT ) STUDENT
			WHERE BRANCH = @BRANCH )

	SELECT * FROM BRANCH_SPI('COMPUTER')
	WHERE RANK = 2 ;
