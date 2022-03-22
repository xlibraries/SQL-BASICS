
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


--Adding Primary key in Student table
ALTER TABLE STUDENT ALTER COLUMN SID int NOT NULL;
ALTER TABLE STUDENT ADD PRIMARY KEY(SID);


SELECT * FROM STUDENT FOR XML PATH('STUDENT'), ROOT('STUDENT') 
SELECT * FROM STUDENT FOR XML RAW 
SELECT * FROM STUDENT FOR XML AUTO
SELECT * FROM STUDENT FOR XML EXPLICIT


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
