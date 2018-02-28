-- NewDreamSchoolDM database 
-- Developed and written by Dingyu Liang
-- Originally Written: February 6 2018
-- Revised: February 15 2018
---------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE name = N'NewDreamSchoolDM')
	CREATE DATABASE NewDreamSchoolDM
GO
USE NewDreamSchoolDM

--
-- Delete existing tables
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'FactPerformance'
       )
	DROP TABLE FactPerformance;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimFaculty'
       )
	DROP TABLE DimFaculty;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimCourse'
       )
	DROP TABLE DimCourse;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimDate'
       )
	DROP TABLE DimDate;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimStudent'
       )
	DROP TABLE DimStudent;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimTime'
       )
	DROP TABLE DimTime;
--
-- Create tables
-- *Revised: Use DimTime Table Sript from Amy! 
CREATE TABLE DimTime
	(
	TimeSK [int] IDENTITY(1,1) NOT NULL CONSTRAINT [PK_dim_Time] PRIMARY KEY,
	Time CHAR(8) NOT NULL,
	Hour CHAR(2) NOT NULL,
	MilitaryHour CHAR(2) NOT NULL,
	Minute CHAR(2) NOT NULL,
	Second CHAR(2) NOT NULL,
	AmPm CHAR(2) NOT NULL,
	StandardTime CHAR(11) NULL
	);

--
CREATE TABLE DimFaculty
	(FacultySK           INT IDENTITY(1,1) CONSTRAINT pk_dimfaculty PRIMARY KEY,
    FacultyAK            INT NOT NULL,
	FacultyName          NVARCHAR(50) NOT NULL,
	DateOfBirth         DATE NOT NULL,
	Gender                NVARCHAR(1) NOT NULL,
	Title                 NVARCHAR(30) NOT NULL,
	YearOfAccreditation INT NOT NULL,
	HighestDegree         NVARCHAR(30) NOT NULL,
	YearOfGraduation    INT NOT NULL,
	StartDate DATETIME NULL,
	EndDate DATETIME NULL
	);
--
CREATE TABLE DimCourse
	(CourseSK	       INT IDENTITY(1,1) CONSTRAINT pk_dimcourse PRIMARY KEY,
	CourseAK          INT NOT NULL,
	CourseName	       NVARCHAR(50) NOT NULL,
	Section            INT NOT NULL,
	TypeName	       NVARCHAR(20) NOT NULL
	);
--
CREATE TABLE DimStudent
	(StudentSK           INT IDENTITY(1,1) CONSTRAINT pk_dimstudent PRIMARY KEY,
    StudentAK            INT NOT NULL,
	DateOfBirth         DATE NOT NULL,
	Gender                NVARCHAR(1) NOT NULL,
	City                  NVARCHAR(20) NOT NULL,
	State                 NVARCHAR(20) NOT NULL,
	StartDate DATETIME NULL,
	EndDate DATETIME NULL
	);
--
-- *Revised: Use DimDate Table Sript from Amy! 
CREATE TABLE DimDate
	(	
	DateSK INT PRIMARY KEY, 
	Date DATETIME,
	FullDate CHAR(10),-- Date in MM-dd-yyyy format
	DayOfMonth INT, -- Field will hold day number of Month
	DayName VARCHAR(9), -- Contains name of the day, Sunday, Monday 
	DayOfWeek INT,-- First Day Sunday=1 and Saturday=7
	DayOfWeekInMonth INT, -- 1st Monday or 2nd Monday in Month
	DayOfWeekInYear INT,
	DayOfQuarter INT,
	DayOfYear INT,
	WeekOfMonth INT,-- Week Number of Month 
	WeekOfQuarter INT, -- Week Number of the Quarter
	WeekOfYear INT,-- Week Number of the Year
	Month INT, -- Number of the Month 1 to 12{}
	MonthName VARCHAR(9),-- January, February etc
	MonthOfQuarter INT,-- Month Number belongs to Quarter
	Quarter CHAR(2),
	QuarterName VARCHAR(9),-- First,Second..
	Year INT,-- Year value of Date stored in Row
	YearName CHAR(7), -- CY 2015,CY 2016
	MonthYear CHAR(10), -- Jan-2016,Feb-2016
	MMYYYY INT,
	FirstDayOfMonth DATE,
	LastDayOfMonth DATE,
	FirstDayOfQuarter DATE,
	LastDayOfQuarter DATE,
	FirstDayOfYear DATE,
	LastDayOfYear DATE,
	IsHoliday BIT,-- Flag 1=National Holiday, 0-No National Holiday
	IsWeekday BIT,-- 0=Week End ,1=Week Day
	Holiday VARCHAR(50),--Name of Holiday in US
	Season VARCHAR(10)--Name of Season
	);
--
-- *Revised: Add an Fact Table derived attribute: LengthOfClass! 
CREATE TABLE FactPerformance
	(CONSTRAINT pk_factperformance PRIMARY KEY (CourseStartDate, FacultySK,  CourseSK, StudentSK),
	CourseStartDate    INT CONSTRAINT fk_factPerformance_startdate FOREIGN KEY REFERENCES DimDate(DateSK),
	CourseEndDate      INT CONSTRAINT fk_factPerformance_enddate FOREIGN KEY REFERENCES DimDate(DateSK),
    CourseStartTime    INT CONSTRAINT fk_factPerformance_starttime FOREIGN KEY REFERENCES DimTime(TimeSK),
	CourseEndTime      INT CONSTRAINT fk_factPerformance_endtime FOREIGN KEY REFERENCES DimTime(TimeSK),
	FacultySK          INT CONSTRAINT fk_factPerformance_dimfaculty_sk FOREIGN KEY REFERENCES DimFaculty(FacultySK),
	CourseSK           INT CONSTRAINT fk_factPerformance_dimcourse_sk FOREIGN KEY REFERENCES DimCourse(CourseSK),
	StudentSK          INT CONSTRAINT fk_factPerformance_dimstudent_sk FOREIGN KEY REFERENCES DimStudent(StudentSK),
	Grade              INT NOT NULL,
	CreditHour         INT NOT NULL,
	LengthOfClass      INT
	)
--End of this file.     