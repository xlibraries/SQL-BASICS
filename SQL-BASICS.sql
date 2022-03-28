
CREATE TABLE STUDENT(SID INT, SNAME VARCHAR(25), LOCATION VARCHAR(25))

INSERT INTO STUDENT VALUES(101, 'Xlib', 'Havana')
INSERT INTO STUDENT VALUES(102, 'Bob', 'Nepal')
INSERT INTO STUDENT VALUES(103, 'Ram', 'Colombo')
INSERT INTO STUDENT VALUES(104, 'Baba', 'Mexico')
INSERT INTO STUDENT VALUES(105, 'Rajesh', 'Moscow',12)

/*Shows Values from the table*/
SELECT SNAME, SID FROM STUDENT
SELECT * FROM STUDENT

--DELETe values form the table where, where specifies the  condition
DELETE FROM STUDENT WHERE SID = 104

--TRUNCATe vanishes all the table data
TRUNCATE TABLE STUDENT

--Affects data in the  table
UPDATE STUDENT SET LOCATION = 'Merar' WHERE SID = 101

--ADDs/ delete coloumn to the table 
ALTER TABLE STUDENT ADD AGE INT

UPDATE STUDENT SET AGE = 19 WHERE SID = 101
UPDATE STUDENT SET AGE = 29 WHERE SID = 102
UPDATE STUDENT SET AGE = 69 WHERE SID = 103
UPDATE STUDENT SET AGE = 29 WHERE SID = 104
UPDATE STUDENT SET AGE = 99 WHERE SID = 105

--Adding Primary key in Student table
ALTER TABLE STUDENT ALTER COLUMN SID int NOT NULL;
ALTER TABLE STUDENT ADD PRIMARY KEY(SID);


select * from STUDENT FOR XML RAW
select * from STUDENT FOR XML PATH('STUDENT'),ROOT('STUDENT')
select * from STUDENT FOR XML AUTO

DECLARE @XMLCONTENT AS XML
SET @XMLCONTENT = (
SELECT * FROM STUDENT FOR XML PATH('STUDENT'),
ROOT('STUDENT')
)

SELECT @XMLCONTENT


--Inserting records:

CREATE TABLE STUDENTDETAILS(SID INT,SNAME VARCHAR(25),LOCATION VARCHAR(25),AGE INT)

SELECT * FROM STUDENTDETAILS

CREATE PROCEDURE INSERTDETAILS8
@XMLDATA XML
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO STUDENTDETAILS(SID,SNAME,LOCATION,AGE)

SELECT X.value('SID[1]','INT') AS SID,
X.value('SNAME[1]','VARCHAR(25)') AS SNAME,
X.value('LOCATION[1]','VARCHAR(25)') AS LOCATION,
X.value('AGE[1]','INT') AS AGE
FROM @XMLDATA.nodes('//STUDENT') XMLDATA(X)
END

DECLARE @XMLDATA XML
SET @XMLDATA='<STUDENT>
<STUDENT>
<SID>101</SID>
<SNAME>JENI</SNAME>
<LOCATION>CHENNAI</LOCATION>
<AGE>28</AGE>
</STUDENT>
<STUDENT>
<SID>102</SID>
<SNAME>AAA</SNAME>
<LOCATION>PUNE</LOCATION>
<AGE>27</AGE>
</STUDENT>
<STUDENT>
<SID>103</SID>
<SNAME>BBB</SNAME>
<LOCATION>CHENNAI</LOCATION>
<AGE>25</AGE>
</STUDENT>
</STUDENT>'

EXEC INSERTDETAILS8 @XMLDATA

SELECT * FROM STUDENTDETAILS

--CONVERT XML DOCUMENTS INTO RELATIONAL DATA
--sp_xml_preparedocument :CREATE DOM FROM THE XML
--sp_xml_removedocument :DESTROY THE DOM

DECLARE @XML NVARCHAR(4000);
DECLARE @DOC INT;
SET @XML='<EMPLOYEE>
<EMPLOYEE>
<EID>101</EID>
<ENAME>Rahul</ENAME>
<SALARY>40000</SALARY>
</EMPLOYEE>
<EMPLOYEE>
<EID>102</EID>
<ENAME>Amy</ENAME>
<SALARY>20000</SALARY>
</EMPLOYEE>
<EMPLOYEE>
<EID>103</EID>
<ENAME>Steven</ENAME>
<SALARY>45000</SALARY>
</EMPLOYEE>
<EMPLOYEE>
<EID>104</EID>
<ENAME>Ryan</ENAME>
<SALARY>50000</SALARY>
</EMPLOYEE>
</EMPLOYEE>'

EXEC sp_xml_preparedocument @doc OUTPUT,@xml

SELECT * FROM OPENXML(@doc,'/EMPLOYEE/EMPLOYEE',11)
WITH (EID INT,ENAME VARCHAR(25),SALARY VARCHAR(25));

EXEC sp_xml_removedocument @doc

--XQUERY :

declare @xlmstudent as XML =
'<STUDENT>
<STUDENTS ROLLNO="300" NAME="SCOTT"/>
<STUDENTS ROLLNO="100" NAME="STEVE"/>
<STUDENTS ROLLNO="200" NAME="CODY"/>
</STUDENT>'

--single row:
SELECT @xlmstudent.query('STUDENT/STUDENTS')

--different row:

SELECT T.C.query('.') AS result
from @xlmstudent.nodes('STUDENT/STUDENTS') T(C)

--CHECKING CONDITION:
SELECT @xlmstudent.query('STUDENT/STUDENTS[@ROLLNO < 300]')

--GET THE VALUES

--single rows
SELECT
STUDENT.C.value('@ROLLNO','int') as ROLLNO,
STUDENT.C.value('@NAME','VARCHAR(25)') as NAME
FROM @xlmstudent.nodes('STUDENT/STUDENTS') STUDENT(C)

--different rows
SELECT T.C.query('.') AS result
FROM @xlmstudent.nodes('STUDENT/STUDENTS') T(C)
ORDER BY T.C.value('NAME[1]','VARCHAR(25)')

--XML DATA TYPE IS DIRECTLY PASSED INTO QUERY
USE SQLBASICS
CREATE TABLE EMPLOYEEXML(EMPID INT PRIMARY KEY, EMP_DATA XML NOT NULL)
SELECT * FROM EMPLOYEEXML
INSERT INTO EMPLOYEEXML VALUES(1,'<EMPLOYEE EMPID = "101"><EMP_NAME>Xlib</EMP_NAME><LOCATION>"HAVANA"</LOCATION></EMPLOYEE>');
INSERT INTO EMPLOYEEXML VALUES(2,'<EMPLOYEE EMPID = "102"><EMP_NAME>Ztip</EMP_NAME><LOCATION>"Merar"</LOCATION></EMPLOYEE>');
INSERT INTO EMPLOYEEXML VALUES(3,'<EMPLOYEE EMPID = "103"><EMP_NAME>Hola</EMP_NAME><LOCATION>"Guvava"</LOCATION></EMPLOYEE>');
INSERT INTO EMPLOYEEXML VALUES(4,'<EMPLOYEE EMPID = "104"><EMP_NAME>Bhola</EMP_NAME><LOCATION>"Sholapur"</LOCATION></EMPLOYEE>');

----for query
	--select ed.EMP_DATA.query('(/EMPLOYEE/EMP_NAME)[1]') as EMPLOYEE_NAME
	--FROM EmployeeXML ed;
----for value
	--select ed.EMP_DATA.value('(/EMPLOYEE/EMP_NAME)[1]','varchar(25)') as EMPLOYEE_NAME
	--FROM EmployeeXML ed;
----for exist
	--select ed.EMP_DATA.exist('(/EMPLOYEE/EMP_NAME)[1]') as EMPLOYEE_NAME
	--FROM EmployeeXML ed
	--where ed.EMPID=102;
----for update

----for 


--Nodes
select ed.EMP_DATA.query('(/EMPLOYEE/EMP_NAME)[1]') as EMPLOYEE_NAME
FROM EmployeeXML ed
CROSS APPLY EMP_DATA.nodes('(EMPLOYEE)') AS MYNODES(EMP_DATA)

--UPDATE delete
UPDATE EMPLOYEEXML
SET EMP_DATA.modify('delete(/EMPLOYEE)[1]');
--UPDATE INSERT
UPDATE EMPLOYEEXML
SET EMP_DATA.modify('insert<EMPLOYEE EMPID = "101"><EMP_NAME>Xlib</EMP_NAME><LOCATION>"HAVANA"</LOCATION></EMPLOYEE> after (/EMPLOYEE[1])')
WHERE EMPLOYEEXML.EMPID = 1;

--Module 4 Indexes(process to order unstructured data)
/* Index Two types clustured and non-clustured
example:- Clustered-> page numbe; Non Clustured-> Groups/ References*/

--Clustured
CREATE TABLE EmployeeDetails
(
	EmpId int NOT NULL,
	PassportNo VarChar(50) Null,
	ExpiryDate VarChar(25) Null
)
INSERT INTO EmployeeDetails VALUES(1,'AASASAA',Null)
INSERT INTO EmployeeDetails VALUES(2,'AASGRAA',Null)
INSERT INTO EmployeeDetails VALUES(7,'AGRGSAA',Null)
INSERT INTO EmployeeDetails VALUES(8,'AHRRSAA',Null)
INSERT INTO EmployeeDetails VALUES(5,'AHTRSAA',Null)

SELECT * FROM EmployeeDetails
CREATE CLUSTERED INDEX CIX_EmpDetails
ON EmployeeDetails(EmpId)

--Non-Clustures
CREATE TABLE EmployeeDetailsNC
(
	EmpId int NOT NULL,
	EmpName VarChar(50) Null,
	EmailId VarChar(25) Null
)
INSERT INTO EmployeeDetailsNC VALUES(1,'Xlib','Xlib@gmail.com')
INSERT INTO EmployeeDetailsNC VALUES(2,'Maya','Maya@gmail.com')
INSERT INTO EmployeeDetailsNC VALUES(7,'Gaya','Gaya@gmail.com')
INSERT INTO EmployeeDetailsNC VALUES(9,'B0la','Bola@gmail.com')
INSERT INTO EmployeeDetailsNC VALUES(5,'Bhola','Bhola@gmail.com')

SELECT * FROM EmployeeDetailsNC

CREATE NONCLUSTERED INDEX NCI_EmpDetails
ON EmployeeDetailsNC(EmpId)
--Deleting index
DROP INDEX NCI_EmpDetails
ON EmployeeDetailsNC
--Alter
ALTER INDEX NCI_EmpDetails
ON EmployeeDetailsNC
SET(IGNORE_DUP_KEY = OFF)



-- Isko waapas karna hai


--Constraints
/*
Primary key:- 
	uniquely identify each row in a table
	not null
	no null value
*/
--Set Primary Key
CREATE TABLE EmployeeTable
(
	EmpId int NOT NULL,
	EmpName VarChar(50) Null,
	EmailId VarChar(25) Null,
	Salary int Null,
	Department VarChar(25) Null
);
SELECT * FROM EmployeeTable
INSERT INTO EmployeeDetails VALUES(1,'Xlib','Xlib@gmail.com',70000,'.NET')
INSERT INTO EmployeeDetails VALUES(2,'Maya','Maya@gmail.com',1000,'Java')
INSERT INTO EmployeeDetails VALUES(3,'Gaya','Gaya@gmail.com',10100,'SF')
INSERT INTO EmployeeDetails VALUES(4,'B0la','Bola@gmail.com',10400,'HR')
INSERT INTO EmployeeDetails VALUES(4,'Bhola','Bhola@gmail.com',40000,'CPO')

--Add Constrains
ALTER TABLE EmployeeTable
ADD CONSTRAINT PK_EmpId PRIMARY KEY(EmpId) 

--DropPrimary Key
ALTER TABLE EmployeeTable
DROP CONSTRAINT EmpId;

--Another Example  DEPARTMENT(DEPTID PK,DEPTNAME)
CREATE TABLE DepartmentTable
(
	DepId int Not Null,	
	DepName VarChar(25),

	CONSTRAINT PK_DepId PRIMARY KEY(DepId)
)

--Set foreign key
ALTER TABLE EmployeeTable
ADD CONSTRAINT FK_DID FOREIGN KEY(DepId)
REFERENCES DepartmentTable(DepId)

SELECT * FROM EmployeeTable

INSERT INTO DepartmentTable VALUES(101,'IT')
INSERT INTO DepartmentTable VALUES(102,'SALES')
INSERT INTO DepartmentTable VALUES(103,'DESIGNER')
INSERT INTO DepartmentTable VALUES(104,'ADMIN')

SELECT * FROM DepartmentTable

INSERT INTO EmployeeTable VALUES(1,'Rahul','rahul@gmail.com','45000',101)
INSERT INTO EmployeeTable VALUES(2,'arun','arun@gmail.com','30000',102)
INSERT INTO EmployeeTable VALUES(3,'Riya','riya@gmail.com','25000',103)
INSERT INTO EmployeeTable VALUES(4,'rena','rena@gmail.com','15000',104)


------Check Constrains
--Create Table
Create TABLE EMPLOYEEC
(
	EID INT,
	ENAME VARCHAR(25),
	EMAIL VARCHAR(25),
	SALARY INT
)
SELECT * FROM EMPLOYEEC
--Insert Data in Table
INSERT INTO EMPLOYEEC VALUES(101,'AAA','AAA@GMAL.COM', 10000)
INSERT INTO EMPLOYEEC VALUES(102,'ABA','ABA@GMAL.COM', 1000)
INSERT INTO EMPLOYEEC VALUES(103,'ACA','ACA@GMAL.COM', 20000)
--Add Constraint
ALTER TABLE EMPLOYEEC
ADD CONSTRAINT CHK_SALARY
CHECK(SALARY > 2000 AND SALARY < 15000)

--Delete Constraint
ALTER TABLE EMPLOYEEC
DROP CONSTRAINT CHK_SALARY

----UNIQUE CONSTRAINT
--CREATE TABLE
CREATE TABLE EmployeeNumber(EmpID int, EmpName VARCHAR(25), EmpNumber VARCHAR(20))

--Add Unique Key
ALTER TABLE Employeenumber
ADD CONSTRAINT Emp_UN UNIQUE(EmpNumber)
--Inserting Value
INSERT INTO EmployeeNumber VALUES(103,'AAA', '10454')
INSERT INTO EmployeeNumber VALUES(103,'ABA', NULL)
INSERT INTO EmployeeNumber VALUES(103,'AAC', NULL)

SELECT * FROM EmployeeNumber

--DROP UNIQUE KEY
ALTER TABLE EmployeeNumber
DROP CONSTRAINT Emp_UN

--DROP RECORD FROM TABLE
DELETE FROM EmployeeNumber


----Triggers: Event occering in database called trigger(in C# we know  it by event handeling)
/*
Types of Trigger:-
DML:- INSERT,UPDATE, DELETE //(when specific paat of taable is affected)
DDL:- CREATE, ALTER, DROP //(when whole table is affected)

Syntax:
CREATE TRIGGER <TRIGGERNAME>
ON <TABLENAME>
--OPETIONS we can select for trigger [FOR\ AFTER UPDATE/ INSTEAD OF DELETE]
*/
--Creating Table
CREATE TABLE EmpLog
(
	LogID INT IDENTITY(1,1) NOT NULL,
	EmpID INT NOT NULL,
	Operations VARCHAR(10) NOT NULL,
	EventDate DATETIME NOT NULL
)
--Create FOR(when all the instructions are complted then only it will update EmpLog Table) trigger
CREATE TRIGGER trgEmpInsert
ON EmployeeTable
FOR INSERT
AS
INSERT INTO EmpLog(EmpID, Operations, EventDate)
SELECT EmpID, 'INSERT', GETDATE() FROM inserted;

SELECT * FROM EmpLog
SELECT * FROM EmployeeTable

--Inserting value in Employee table to check if trigger is working fine  or not and it is working fine
INSERT INTO EmployeeTable VALUES(10,'Mena','Mena@gmail.com','16000',104)

--Create AFTER UPDATE
CREATE TRIGGER trgEmpInsertAfter
ON EmployeeTable
AFTER UPDATE
AS
INSERT INTO EmpLog(EmpID, Operations, UpdateDate)
SELECT EmpID, 'UPDATE', GETDATE() FROM deleted;

SELECT * FROM EmpLog
SELECT * FROM EmployeeTable

UPDATE EmployeeTable SET Salary = '15943' WHERE EmpId = 10

--Create Instead of Delete Trigger
CREATE TRIGGER trgEmpDelete
ON EmployeeTable
INSTEAD OF DELETE
AS
INSERT INTO EmpLog(EmpID, Operations, EventDate)
SELECT EmpID, 'DELETE', GETDATE() FROM deleted;

SELECT * FROM EmpLog
SELECT * FROM EmployeeTable

DELETE FROM EmployeeTable WHERE EmpId = 10

--Creating Views
CREATE VIEW SHOW
AS
SELECT S1.EmpID, S1.EmpName, S2.DepName
FROM EmployeeTable S1, DepartmentTable S2
WHERE S1.DepID = S2.DepId
SELECT * FROM SHOW

--Applying conditions to view
CREATE VIEW SHOW2
AS
SELECT EmpName FROM EmployeeTable
WHERE Salary > 15000
SELECT *  FROM SHOW2

CREATE TABLE Enrollement(SID INT, SName VARCHAR(25), Course VARCHAR(25))
CREATE TABLE StudentDetails(SID INT, SName VARCHAR(25), Address VARCHAR(50), Age INT)

INSERT INTO Enrollement VALUES (1001,'RAAYN', 'MBA')
INSERT INTO Enrollement VALUES (1002,'BRAAYN', 'BE')
INSERT INTO Enrollement VALUES (1003,'ZAAYN', 'BCOM')
INSERT INTO Enrollement VALUES (1004,'TAYNA', 'BA')
INSERT INTO Enrollement VALUES (1005,'RAY', 'BBA')

INSERT INTO StudentDetails VALUES (1001,'RAY', 'Texas', 25)
INSERT INTO StudentDetails VALUES (1001,'BRAAYN', 'Lala', 18)
INSERT INTO StudentDetails VALUES (1001,'ZAAYN', 'Iland', 34)
INSERT INTO StudentDetails VALUES (1001,'TAYNA', 'MainLand', 25)
INSERT INTO StudentDetails VALUES (1001,'RAY', 'NorWay', 29)

SELECT * FROM Enrollement
SELECT * FROM StudentDetails

TRUNCATE TABLE Enrollement
TRUNCATE TABLE StudentDetails

CREATE VIEW VIEW0
AS
SELECT S1.SID, S1.SName, S2.Course 
FROM  StudentDetails S1, Enrollement S2
WHERE S1.SID = S2.SID
SELECT Address FROM StudentDetails

SELECT * FROM VIEW0

CREATE VIEW VIEW2
AS
SELECT StudentDetails.SID, StudentDetails.Sname, Enrollement.Course
FROM StudentDetails
LEFT JOIN
Enrollement
ON StudentDetails.SID = Enrollement.SID

SELECT * FROM VIEW2
--Dropping View
DROP VIEW VIEW0

ALTER VIEW VIEW2
AS
SELECT  StudentDetails.Sname, StudentDetails.Address, Enrollement.Course
FROM StudentDetails
INNER JOIN
Enrollement
ON StudentDetails.SID = Enrollement.SID

SELECT * FROM VIEW2


--STORED PROCEDURE
--SET of statement that performs a logic
--accepts i/o 
 
--CREATE and select value in PROCEDURE
SELECT * FROM EmployeeTable

CREATE PROCEDURE udp_get
AS
BEGIN
SELECT EmpName, Email, Salary
FROM EmployeeTable
WHERE SALARY > 15000
END

EXEC udp_get

SP_HELPTEXT udp_get

--INSERT -- redo this

CREATE PROC UDP_INSERT
(
	@EmpID INT,
	@EmpName VARCHAR(20),
	@Email VARCHAR(20),
	@Salary VARCHAR(20),
	@DepID INT
)
AS 
--DROP PROC UDP_INSERT
BEGIN
INSERT INTO EmployeeTable
(EmpID,EmpName,Email,Salary,DepID)
VALUES
(
	@EmpID,
	@EmpName, 
	@Email,
	@Salary,
	@DepID
)
END

------from JENIFER to All Attendees:
----CREATE PROC UDP_INSERT
----(@EMPID INT
----,@EMPNAME VARCHAR(20)
----,@EMAIL VARCHAR(20)
----,@SALARY  VARCHAR(20)
----,@DEPTID INT)
----AS
----BEGIN
----INSERT INTO EMPTABLE1
----(EMPID,EMPNAME,EMAIL,SALARY,DEPTID)
----VALUES(
----@EMPID 
----,@EMPNAME 
----,@EMAIL 
----,@SALARY  
----,@DEPTID )
----END

--Try catch block
CREATE PROC divide
(
	@a decimal,
	@b decimal,
	@c decimal output
)
AS

BEGIN
BEGIN TRY
	SET @c = @a/@b;
END TRY
BEGIN CATCH
SELECT
ERROR_LINE() as ErrorLine,
ERROR_MESSAGE() AS ErrorMessage,
ERROR_PROCEDURE() AS ErrorProcedure,
ERROR_NUMBER() as ErrorNumber,
ERROR_SEVERITY() as ErrorSeverity,
ERROR_STATE() as ErrorState
END CATCH
END

DECLARE @r decimal
exec DIVIDE 10,5, @r output;
print @r;

--Functions

SELECT * FROM EmployeeTable
SELECT * FROM DepartmentTable

CREATE TABLE EmployeeTable1
(
	EmpId int NOT NULL,
	EmpName VarChar(50) Null,
	EmailId VarChar(25) Null,
	Salary int Null,
	Department VarChar(25) Null
);
SELECT * FROM EmployeeTable1
INSERT INTO EmployeeTable1 VALUES(1,'Xlib','Xlib@gmail.com',70000,'.NET')
INSERT INTO EmployeeTable1 VALUES(2,'Maya','Maya@gmail.com',1000,'Java')
INSERT INTO EmployeeTable1 VALUES(3,'Gaya','Gaya@gmail.com',10100,'SF')
INSERT INTO EmployeeTable1 VALUES(4,'B0la','Bola@gmail.com',10400,'HR')
INSERT INTO EmployeeTable1 VALUES(4,'Bhola','Bhola@gmail.com',40000,'CPO')

--Add Constrains
ALTER TABLE EmployeeTable1
ADD CONSTRAINT PK_EmpId PRIMARY KEY(EmpId) 

--Create function
CREATE FUNCTION avgSalary()
RETURNS INT
AS
BEGIN
DECLARE @Sal INT
SET @Sal = 0
SELECT @Sal = AVG(Salary) FROM EmployeeTable1
RETURN @Sal
END

SELECT dbo.avgSalary() as Average

--Function for number of employees
CREATE FUNCTION empCount()
RETURNS INT
AS
BEGIN
DECLARE @Count INT
SET @Count = 0
SELECT @Count = count(EmpId) FROM EmployeeTable1
RETURN @Count
END

SELECT dbo.empCount() as Count

--Function return's table
ALTER FUNCTION empInfo(@Sal INT)
RETURNS  TABLE
AS
RETURN (SELECT * FROM EmployeeTable1 WHERE Salary > @Sal)

SELECT * FROM empInfo(15000)

--Drop funvction
DROP FUNCTION dbo.empCount

--Calling function insie procedure
ALTER PROCEDURE udp_get
AS 
BEGIN 
SELECT dbo.empInfo()
END

declare @a int
SET @a = 15000
EXEC udp_get @a OUTPUT;
print @a;

--Multi line statement function 
ALTER FUNCTION GETSENIOREMPLOYEE()
RETURNS @sEmp TABLE
(
	EmpID INT,
	EmpName VARCHAR(20)
)
AS
BEGIN
INSERT INTO @sEmp SELECT EmpID,EmpName FROM EmployeeTable1
DELETE FROM @sEmp WHERE EmpID > 3
RETURN 
END

SELECT * FROM GETSENIOREMPLOYEE()

--CREATING MANAGED CODE:
/*
-Create Assembly
-Understant Database Managed Objects

Advantages:
-Common developeement enviroment
-ability to define data types
-better programming model

NameSpaces:
System.Data // to supporty I/o
-System.Data.SQLClient //For CLR Interrgration
-System.Data.SQLTypes //for Var and other data  tyopes

Classes:
1)SqlContext			//assemblies to include
2)SqlPipe				//for messaging system from sql code to server and vise cera
3)SqlTriggerContext		//whenever a trigger/ event is occured
4)SqlConnection			// will tell you your  database connection/ server name/ authontacation type/ which ddatabase  you are goin to work with
5)SqlCommand			//help to do C.R.U.D(Create, read, update,  delete) operations
6)SqlDataReader			// return's result set
*/

--Creatting managed stored procedure
SELECT * FROM EmployeeTable

--to remove CLR error
EXEC sp_configure 'clr enabled',1;
RECONFIGURE WITH OVERRIDE

--To execute database added via Visual Studio
EXEC dbo.GetEmployeeSP

--Transation
/*
  Trannsaction:
  Unit of work performed on a database
  -ACID
  (
        ATOMICITY:-> Either completted or Failed
        CONSISTENCY:-> every time you make an operation values are upted on a database
        ISOLATION:-> It enavles pathway of one trainstion doesnot effect oter
        DURIBALITY:-> How it is persisting// Even in case of system faliur database and all the revalance are maintained


		Modes:
		-Auto // you don't begint you don't end simple insert satement 
		-Implicit
		-Explicit
   )
 */

 CREATE TABLE PRODUCT
 (
	ProdID  INT PRIMARY KEY,
	ProdNmae VARCHAR(25),
	Price INT,
	Quantity INT
 )

 INSERT INTO PRODUCT VALUES(101,'Product1', 200,387)
 INSERT INTO PRODUCT VALUES(102,'Product2', 220,87)
 INSERT INTO PRODUCT VALUES(103,'Product3', 240,37)
 INSERT INTO PRODUCT VALUES(104,'Product4', 220,337)
 INSERT INTO PRODUCT VALUES(105,'Product6', 2670,7)

 SELECT * FROM PRODUCT
 -- External explicit transaction mode
 BEGIN TRANSACTION
  INSERT INTO PRODUCT VALUES(106,'Product6', 20,3)
  UPDATE PRODUCT SET Quantity = 30 WHERE ProdID = 104;
  DELETE FROM PRODUCT WHERE ProdID = 127
  COMMIT TRANSACTION -- Permintely saved you can not roll back after this 
  RollBACK Transaction -- to unndo chages made by previous transcaction

  --Implicit // it is autometicaly started by SQL Server
  SET IMPLICIT_TRANSACTION ON
  INSERT PRODUCT VALUES(107, 'Product7', 347, 76)
  INSERT PRODUCT VALUES(17, 'Product7', 37, 7634)
  INSERT PRODUCT VALUES(127, 'Product7', 47, 74)
  ROLLBACK TRANSACTION

  --NESTED TRANSACTION
  BEGIN TRANSACTION T1
  INSERT PRODUCT VALUES(201, 'NESTED1', 47, 74)
  INSERT PRODUCT VALUES(202, 'NESTED2', 47, 74)
  BEGIN TRANSACTION T2
  INSERT PRODUCT VALUES(203, 'NESTED3', 47, 74)
  INSERT PRODUCT VALUES(204, 'NESTED4', 47, 74)
  COMMIT TRANSACTION T2
  COMMIT TRANSACTION T1

  SELECT * FROM PRODUCT

/*SAVE POINT
It will split transaction into multiple Unit so that you  have the flexiblity to roll back and chage particular part of transaction  
*/

BEGIN TRANSACTION
SAVE TRANSACTION S1
  INSERT PRODUCT VALUES(301, 'SAVEPOINT1', 07, 7)
  INSERT PRODUCT VALUES(302, 'SAVEPOINT2', 17, 70)

SAVE TRANSACTION S2
  INSERT PRODUCT VALUES(303, 'SAVEPOINT3', 27, 17)
  INSERT PRODUCT VALUES(304, 'SAVEPOINT4', 37, 71)

SAVE TRANSACTION S3
  INSERT PRODUCT VALUES(305, 'SAVEPOINT5', 47, 27)
  INSERT PRODUCT VALUES(306, 'SAVEPOINT6', 57, 72)

SELECT * FROM PRODUCT

COMMIT TRANSACTION S2
ROLLBACK TRANSACTION S2
