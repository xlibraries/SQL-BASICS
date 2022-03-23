
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

