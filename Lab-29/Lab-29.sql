--EMPLOYEE_LOG (LOGID, EID, OLDVALUE, NEWVALUE, FIELDNAME, OPERATIONTYPE, LOGDATE) 
--From the table EMPLOYEE perform the following queries:  
--Part – A: 
--1. Create trigger for preventing removal of employees from the table. 
	CREATE OR ALTER TRIGGER emp_insert_trigger
	ON EMPLOYEE
	INSTEAD OF  DELETE
	as
	BEGIN
			PRINT('Employee record can not  remove.');
	END;

	SELECT * FROM EMPLOYEE
	DELETE FROM EMPLOYEE
	WHERE EID=113

	DROP TRIGGER emp_insert_trigger

--2. Create INSTEAD OF DELETE trigger to prevent deletion of employee records and store deleted data into 
--EMPLOYEE_LOG table.
	CREATE TABLE EMPLOYEE_LOG (
		LOGID INT PRIMARY KEY,
		OLDVALUE VARCHAR(50),
		NEWVALUE VARCHAR(50) ,
		FIELDNAME VARCHAR(50),
		OPERATIONTYPE VARCHAR(50,),
		LOGDATE DATE )

		
	CREATE OR ALTER TRIGGER emp_delete_trigger
	ON EMPLOYEE
	INSTEAD OF  DELETE
	as
	BEGIN
			
			INSERT INTO EMPLOYEE_LOG
			(LOGID, OLDVALUE, NEWVALUE, FIELDNAME, OPERATIONTYPE, LOGDATE) 

			SELECT EID,FIRSTNAME + ' '+ LASTNAME,NULL,'NAME','DELETE',GETDATE() FROM deleted
			
			PRINT('Employee deletion prevented and data stored in log table.');
	END;

	DELETE FROM EMPLOYEE
	WHERE EID = 113;

	SELECT * FROM EMPLOYEE




--3. Create INSTEAD OF trigger to log all operations on EMPLOYEE table (INSERT/UPDATE/DELETE) into 
--EMPLOYEE_LOG table. 

CREATE OR ALTER TRIGGER emp_all_operations
ON EMPLOYEE
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

    INSERT INTO EMPLOYEE_LOG
    (EID, OLDVALUE, NEWVALUE, FIELDNAME, OPERATIONTYPE, LOGDATE)
    SELECT
        EID,
        NULL,
        FIRSTNAME + ' ' + LASTNAME,
        'NAME',
        'INSERT',
        GETDATE()
    FROM inserted
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM deleted
        WHERE deleted.EID = inserted.EID
    );

    INSERT INTO EMPLOYEE_LOG
    (EID, OLDVALUE, NEWVALUE, FIELDNAME, OPERATIONTYPE, LOGDATE)
    SELECT
        d.EID,
        d.FIRSTNAME + ' ' + d.LASTNAME,
        i.FIRSTNAME + ' ' + i.LASTNAME,
        'NAME',
        'UPDATE',
        GETDATE()
    FROM deleted d
    INNER JOIN inserted i
        ON d.EID = i.EID;

    INSERT INTO EMPLOYEE_LOG
    (EID, OLDVALUE, NEWVALUE, FIELDNAME, OPERATIONTYPE, LOGDATE)
    SELECT
        EID,
        FIRSTNAME + ' ' + LASTNAME,
        NULL,
        'NAME',
        'DELETE',
        GETDATE()
    FROM deleted
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM inserted
        WHERE inserted.EID = deleted.EID
    );

END;
--4. Create trigger to block employees from updating their JOININGYEAR and print message 
--‘Employees are not allowed to update their joining year’.

CREATE OR ALTER TRIGGER emp_joiningyear
ON EMPLOYEE
AFTER UPDATE
AS
BEGIN
    IF UPDATE(JOININGYEAR)
    BEGIN
        PRINT 'Employees are not allowed to update their joining year.';
        ROLLBACK TRANSACTION;
    END;
END;
--5. Create trigger for preventing duplicate employee records having same FIRSTNAME, LASTNAME, and CITY. 

CREATE OR ALTER TRIGGER emp_duplicate
ON EMPLOYEE
AFTER INSERT, UPDATE
AS
BEGIN

    IF EXISTS
    (
        SELECT 1
        FROM EMPLOYEE e
        INNER JOIN inserted i
            ON e.FIRSTNAME = i.FIRSTNAME
            AND e.LASTNAME = i.LASTNAME
            AND e.CITY = i.CITY
            AND e.EID <> i.EID
    )
    BEGIN
        PRINT 'Duplicate employee record is not allowed.';
        ROLLBACK TRANSACTION;
    END;

END;

--Part – B: 
--6. Create INSTEAD OF INSERT trigger to prevent insertion of duplicate EID in EMPLOYEE table. 

CREATE OR ALTER TRIGGER emp_duplicate_eid
ON EMPLOYEE
INSTEAD OF INSERT
AS
BEGIN

    IF EXISTS
    (
        SELECT 1
        FROM EMPLOYEE e
        INNER JOIN inserted i
            ON e.EID = i.EID
    )
    BEGIN
        PRINT 'Duplicate EID is not allowed.';
        RETURN;
    END;

    INSERT INTO EMPLOYEE
    (
        EID,
        FIRSTNAME,
        LASTNAME,
        CITY,
        GENDER,
        DEPARTMENT,
        JOININGYEAR
    )
    SELECT
        EID,
        FIRSTNAME,
        LASTNAME,
        CITY,
        GENDER,
        DEPARTMENT,
        JOININGYEAR
    FROM inserted;

END;
--7. Create INSTEAD OF UPDATE trigger to maintain complete employee update history into EMPLOYEE_LOG 
--table. 

CREATE OR ALTER TRIGGER emp_update_history
ON EMPLOYEE
AFTER UPDATE
AS
BEGIN

    INSERT INTO EMPLOYEE_LOG
    (EID, OLDVALUE, NEWVALUE, FIELDNAME, OPERATIONTYPE, LOGDATE)

    SELECT
        d.EID,
        CAST(d.FIRSTNAME AS VARCHAR(100)),
        CAST(i.FIRSTNAME AS VARCHAR(100)),
        'FIRSTNAME',
        'UPDATE',
        GETDATE()
    FROM deleted d
    INNER JOIN inserted i ON d.EID = i.EID
    WHERE ISNULL(d.FIRSTNAME,'') <> ISNULL(i.FIRSTNAME,'');

    INSERT INTO EMPLOYEE_LOG
    (EID, OLDVALUE, NEWVALUE, FIELDNAME, OPERATIONTYPE, LOGDATE)

    SELECT
        d.EID,
        CAST(d.LASTNAME AS VARCHAR(100)),
        CAST(i.LASTNAME AS VARCHAR(100)),
        'LASTNAME',
        'UPDATE',
        GETDATE()
    FROM deleted d
    INNER JOIN inserted i ON d.EID = i.EID
    WHERE ISNULL(d.LASTNAME,'') <> ISNULL(i.LASTNAME,'');

    INSERT INTO EMPLOYEE_LOG
    (EID, OLDVALUE, NEWVALUE, FIELDNAME, OPERATIONTYPE, LOGDATE)

    SELECT
        d.EID,
        CAST(d.CITY AS VARCHAR(100)),
        CAST(i.CITY AS VARCHAR(100)),
        'CITY',
        'UPDATE',
        GETDATE()
    FROM deleted d
    INNER JOIN inserted i ON d.EID = i.EID
    WHERE ISNULL(d.CITY,'') <> ISNULL(i.CITY,'');

END;
--8. Create INSTEAD OF UPDATE trigger to prevent changing employee EID once record is created.

CREATE OR ALTER TRIGGER emp_eid_update
ON EMPLOYEE
INSTEAD OF UPDATE
AS
BEGIN

    IF EXISTS
    (
        SELECT 1
        FROM deleted d
        INNER JOIN inserted i
            ON d.EID <> i.EID
    )
    BEGIN
        PRINT 'Employee EID cannot be changed.';
        RETURN;
    END;

    UPDATE e
    SET
        e.FIRSTNAME = i.FIRSTNAME,
        e.LASTNAME = i.LASTNAME,
        e.CITY = i.CITY,
        e.GENDER = i.GENDER,
        e.DEPARTMENT = i.DEPARTMENT,
        e.JOININGYEAR = i.JOININGYEAR
    FROM EMPLOYEE e
    INNER JOIN inserted i
        ON e.EID = i.EID;

END;

--9. Create INSTEAD OF INSERT trigger to block insertion of employees with NULL department name. 

    CREATE OR ALTER TRIGGER emp_department
    ON EMPLOYEE
    INSTEAD OF INSERT
    AS
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM inserted
            WHERE DEPARTMENT IS NULL
        )
        BEGIN
            PRINT 'Department name cannot be NULL.';
            RETURN;
        END;

        INSERT INTO EMPLOYEE
        (
            EID,
            FIRSTNAME,
            LASTNAME,
            CITY,
            GENDER,
            DEPARTMENT,
            JOININGYEAR
        )
        SELECT
            EID,
            FIRSTNAME,
            LASTNAME,
            CITY,
            GENDER,
            DEPARTMENT,
            JOININGYEAR
        FROM inserted;

    END;

--10. Create INSTEAD OF UPDATE trigger to prevent updating GENDER column after employee registration. 
    CREATE OR ALTER TRIGGER emp_gender
    ON EMPLOYEE
    AFTER UPDATE
    AS
    BEGIN

    IF UPDATE(GENDER)
    BEGIN
        PRINT 'Gender cannot be updated after employee registration.';
        ROLLBACK TRANSACTION;
    END;

    END;

--STUDENT_LOG (LOGID, STDID, SNAME, OLDVALUE, NEWVALUE, FIELDNAME, OPERATIONTYPE, LOGDATE) 
    CREATE TABLE STUDENT_LOG
    (
        LOGID INT IDENTITY(1,1) PRIMARY KEY,
        STDID INT,
        SNAME VARCHAR(100),
        OLDVALUE VARCHAR(100),
        NEWVALUE VARCHAR(100),
        FIELDNAME VARCHAR(50),
        OPERATIONTYPE VARCHAR(50),
        LOGDATE DATE
    );

--From the table STUDENT perform the following queries:  

--Part – C:

--11. Create INSTEAD OF INSERT trigger to prevent insertion of students whose SPI is greater than 10 or less 
--than 0. 
    CREATE OR ALTER TRIGGER student_spi_insert
    ON STUDENT
    INSTEAD OF INSERT
    AS
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM inserted
            WHERE SPI > 10 OR SPI < 0
        )
        BEGIN
            PRINT 'SPI must be between 0 and 10.';
            RETURN;
        END;

        INSERT INTO STUDENT
        (
            STDID,
            SNAME,
            SPI,
            BRANCH
        )
        SELECT
            STDID,
            SNAME,
            SPI,
            BRANCH
        FROM inserted;

    END;

--12. Create INSTEAD OF UPDATE trigger to block students from changing their BRANCH after admission. 

    CREATE OR ALTER TRIGGER student_branch
    ON STUDENT
    AFTER UPDATE
    AS
    BEGIN

        IF UPDATE(BRANCH)
        BEGIN
            PRINT 'Students are not allowed to change their branch.';
            ROLLBACK TRANSACTION;
        END;

    END;

--13. Create INSTEAD OF DELETE trigger to move deleted student records into STUDENT_LOG table instead of 
--permanent deletion. 
    CREATE OR ALTER TRIGGER student_delete_log
    ON STUDENT
    INSTEAD OF DELETE
    AS
    BEGIN

        INSERT INTO STUDENT_LOG
        (
            STDID,
            SNAME,
            OLDVALUE,
            NEWVALUE,
            FIELDNAME,
            OPERATIONTYPE,
            LOGDATE
        )
        SELECT
            STDID,
            SNAME,
            CAST(SPI AS VARCHAR(100)),
            NULL,
            'SPI',
            'DELETE',
            GETDATE()
        FROM deleted;

        PRINT 'Student record deleted and stored in log table.';

    END;    

--14. Create INSTEAD OF UPDATE trigger to prevent updating student SPI. 
    CREATE OR ALTER TRIGGER student_spi_update
    ON STUDENT
    AFTER UPDATE
    AS
    BEGIN

        IF UPDATE(SPI)
        BEGIN
            PRINT 'Student SPI cannot be updated.';
            ROLLBACK TRANSACTION;
        END;

    END;

--15. Create INSTEAD OF UPDATE trigger to store student branch transfer history into STUDENT_LOG table. 
    CREATE OR ALTER TRIGGER student_branch_history
    ON STUDENT
    AFTER UPDATE
    AS
    BEGIN

        INSERT INTO STUDENT_LOG
        (
            STDID,
            SNAME,
            OLDVALUE,
            NEWVALUE,
            FIELDNAME,
            OPERATIONTYPE,
            LOGDATE
        )
        SELECT
            d.STDID,
            i.SNAME,
            d.BRANCH,
            i.BRANCH,
            'BRANCH',
            'UPDATE',
            GETDATE()
        FROM deleted d
        INNER JOIN inserted i
            ON d.STDID = i.STDID
        WHERE ISNULL(d.BRANCH,'') <> ISNULL(i.BRANCH,'');

    END;