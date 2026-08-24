--Implement Advanced Stored Procedures with Conditions and Logic.

-- From the table EMPLOYEE perform the following queries:  

--Part – A:  

--1. Create a stored procedure to generate department-wise salary statistics like total salary, average salary, 
--minimum salary, and maximum salary. (User enter only department name) 

	CREATE OR ALTER PROCEDURE SP_SELECT_TOTAL_AVG_MIN_MAX
	@DEPARTMENT VARCHAR(50)
	AS
	BEGIN 
	SELECT SUM(SALARY) AS SUM,AVG(SALARY) AS AVG,MIN(SALARY) AS MIN,MAX(SALARY) AS MAX FROM EMPLOYEE
	WHERE DEPARTMENT = @DEPARTMENT
	END

	EXEC SP_SELECT_TOTAL_AVG_MIN_MAX 'IT' 

--2. Create a stored procedure that accepts a joining year and displays employees who joined that year. 

	CREATE OR ALTER PROCEDURE SP_SELECT_JOIN_YEAR
	@JOININGYEAR DATE
	AS
	BEGIN 
	SELECT * FROM EMPLOYEE
	WHERE JOININGYEAR = @JOININGYEAR
	END

	EXEC SP_SELECT_JOIN_YEAR '2026'

--3. Create a stored procedure for dynamic employee search using parameters (User may enter partial city name). 
	
	CREATE OR ALTER PROCEDURE SP_SELECT_CITY
	@CITY VARCHAR(50)
	AS
	BEGIN 
	SELECT * FROM EMPLOYEE
	WHERE CITY = @CITY
	END

	EXEC SP_SELECT_CITY 'RAJKOT'

--4. Create a stored procedure that accepts a salary amount and displays employees earning more than the entered salary.
	
	CREATE OR ALTER PROCEDURE SP_MORE_SALARY
	@SALARY INT
	AS
	BEGIN 
	SELECT * FROM EMPLOYEE
	WHERE SALARY > @SALARY
	END

	EXEC SP_MORE_SALARY 12000

--5. Create a stored procedure to display top N highest paid employees from each department (Value of N is entered by user). 
	
	CREATE OR ALTER PROCEDURE SP_TOP_N_SALARY
	@N INT
	AS
	BEGIN 
	SELECT TOP (@N) * FROM EMPLOYEE
	ORDER BY SALARY DESC
	END

	EXEC SP_TOP_N_SALARY 3

--6. Create a stored procedure to increase salary department-wise by a given percentage. (User Enter Department Name and %, e.g. Computer 10). 
	
	CREATE OR ALTER PROCEDURE SP_INCREASE_SALARY
	@DEPARTMENT VARCHAR(50),
	@PERSENTAGE INT
	AS
	BEGIN 
	UPDATE EMPLOYEE SET SALARY = SALARY + (SALARY * (@PERSENTAGE)/100)
	WHERE DEPARTMENT = @DEPARTMENT
	END

	EXEC SP_INCREASE_SALARY 'HR',5

	SELECT * FROM EMPLOYEE
	
--7. Create a stored procedure to display employees having experience greater than or equal to the entered years. 
	
	CREATE OR ALTER PROCEDURE SP_EXPERIENCE
	@N INT
	AS
	BEGIN 
	SELECT * FROM EMPLOYEE
	WHERE ( YEAR(GETDATE()) - JOININGYEAR) >= @N
	END

	EXEC SP_EXPERIENCE 3

--8. Create a stored procedure that accepts a number as input and displays details of the last N employees who joined 
--the organization. 
	
	CREATE OR ALTER PROCEDURE SP_LAST_N_EMPLOYEE
	@N INT
	AS
	BEGIN 
	SELECT TOP (@N) * FROM EMPLOYEE
	ORDER BY JOININGYEAR DESC
	END

	EXEC SP_LAST_N_EMPLOYEE 3
 
--From the table AUTHOR, PUBLISHER and BOOK perform the following queries:  

--Part – B:  
	
--9. Create a stored procedure that accepts an author name and displays all books written by that author.
	
	CREATE OR ALTER PROCEDURE ALL_BOOK
	@NAME VARCHAR(50)
	AS
	BEGIN 
	SELECT * FROM BOOK B
	JOIN AUTHOR A
	ON B.AUTHORID = A.AUTHORID
	WHERE AUTHORNAME = @NAME
	END

	EXEC ALL_BOOK 'CHETAN BHAGAT'

--10. Create a stored procedure that accepts a publication year and displays books published after that year. 
	
	CREATE OR ALTER PROCEDURE AFTER_YEAR
	@YEAR INT
	AS
	BEGIN 
	SELECT * FROM BOOK
	WHERE PUBLICATIONYEAR > @YEAR
	END

	EXEC AFTER_YEAR 2013

--11. Create a stored procedure that accepts a country name and displays all authors from that country with their books.
	
	CREATE OR ALTER PROCEDURE COUNTRY_AUTHOR
	@NAME VARCHAR(50)
	AS
	BEGIN 
	SELECT A.AUTHORID,AUTHORNAME,COUNTRY,TITLE
	FROM BOOK B
	JOIN AUTHOR A
	ON B.AUTHORID = A.AUTHORID
	WHERE COUNTRY = @NAME
	GROUP BY A.AUTHORID,AUTHORNAME,COUNTRY,TITLE
	END

	EXEC COUNTRY_AUTHOR 'INDIA'

--12. Create a stored procedure that accepts a number as input and displays the top N most expensive books with 
--author and publisher details. 
	
	CREATE OR ALTER PROCEDURE TOP_EXPENSIVE
    @N INT
	AS
	BEGIN
    SELECT TOP (@N) B.*,A.AUTHORNAME,P.PUBLISHERNAME
    FROM BOOK B
    JOIN AUTHOR A
    ON B.AUTHORID = A.AUTHORID
    JOIN PUBLISHER P
    ON B.PUBLISHERID = P.PUBLISHERID
    ORDER BY B.PRICE DESC;
	END;

	EXEC TOP_EXPENSIVE 5;
 
--Part – C:  

--13. Create a stored procedure that accepts a publisher name and displays the total number of books published by
--that publisher. 
	
	CREATE OR ALTER PROCEDURE TOTAL_BOOKS
    @PUBLISHERNAME VARCHAR(100)
	AS
	BEGIN
    SELECT COUNT(*) AS TOTAL_BOOKS
    FROM BOOK B
    JOIN PUBLISHER P
    ON B.PUBLISHERID = P.PUBLISHERID
    WHERE P.PUBLISHERNAME = @PUBLISHERNAME;
	END;

	EXEC TOTAL_BOOKS 'Penguin';

--14. Create a stored procedure that accepts a price range (Min Price Max Price) and displays books whose prices 
--fall within that range. 
	
	CREATE OR ALTER PROCEDURE BOOKS_BY_PRICE
    @MINPRICE DECIMAL(10,2),
    @MAXPRICE DECIMAL(10,2)
	AS
	BEGIN
    SELECT * FROM BOOK
    WHERE PRICE BETWEEN @MINPRICE AND @MAXPRICE;
	END;

	EXEC BOOKS_BY_PRICE 500, 1500;

--15. Create a stored procedure that accepts an author ID and deletes all books written by that author. 
	
	CREATE OR ALTER PROCEDURE DELETE_BOOKS_BY_AUTHOR
    @AUTHORID INT
	AS
	BEGIN
    DELETE FROM BOOK
    WHERE AUTHORID = @AUTHORID;
	END;

	EXEC DELETE_BOOKS_BY_AUTHOR 3;

	SELECT *  FROM AUTHOR
	SELECT * FROM PUBLISHER
	SELECT * FROM BOOK