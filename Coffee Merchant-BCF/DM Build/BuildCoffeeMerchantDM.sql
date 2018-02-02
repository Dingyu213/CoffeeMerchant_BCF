-- CoffeeMerchantDM database developed
-- Written by Siyu Pei, Xiao Li, Dingyu Liang
-- Originally Written: January 2018
---------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE name = N'CoffeeMerchantDM')
	CREATE DATABASE CoffeeMerchantDM
GO
USE CoffeeMerchantDM

--
-- Delete existing tables
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'FactSales'
       )
	DROP TABLE FactSales;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimProduct'
       )
	DROP TABLE DimProduct;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimEmployee'
       )
	DROP TABLE DimEmployee;
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
	WHERE name = N'DimRegion'
       )
	DROP TABLE DimRegion;
--
-- Create tables
--
CREATE TABLE DimRegion
	(Region_SK   INT IDENTITY(1,1) CONSTRAINT pk_dimregion PRIMARY KEY,
	Region_AK    NVARCHAR(2) NOT NULL,
	State        NVARCHAR(25) NOT NULL CONSTRAINT un_dimregion_state UNIQUE,
	City         NVARCHAR(50) NOT NULL
	);

--
CREATE TABLE DimEmployee
	(Employee_SK    INT IDENTITY(1,1) CONSTRAINT pk_dimemployee PRIMARY KEY,
    Employee_AK     INT NOT NULL,
	First_Name      NVARCHAR(30) NOT NULL,
	Last_Name       NVARCHAR(30) NOT NULL,
	Commission_Rate NUMERIC(4,4) NOT NULL,
	Hire_Date       DATETIME NOT NULL,
	Birth_Date      DATETIME NOT NULL,
	Gender          NVARCHAR(1) NOT NULL CONSTRAINT ck_dimemployee_gender CHECK ((Gender = 'M') OR (Gender = 'F'))
	);
--
CREATE TABLE DimProduct
	(Product_SK	        INT IDENTITY(1,1) CONSTRAINT pk_dimproduct PRIMARY KEY,
	Product_AK          INT NOT NULL,
	Item_Name	        NVARCHAR(40) NOT NULL,
	Item_Type	        NVARCHAR(5) NOT NULL,
	Country_of_Origin	NVARCHAR(40) NOT NULL
	);
--
CREATE TABLE DimDate
	(Date_SK       INT IDENTITY(1,1) CONSTRAINT pk_dimdate PRIMARY KEY,
	Date           DATETIME NOT NULL,
	Day_of_Week    NVARCHAR(50) NOT NULL,
	Date_Name      NVARCHAR(50) NOT NULL,
	Month          INT NOT NULL,
	Month_Name     NVARCHAR(50) NOT NULL,
	Day_of_Month   INT NOT NULL,
	Quarter	       INT NOT NULL,
	Season		   NVARCHAR(50) NOT NULL,
	Year		   INT NOT NULL,
	HolidayFlag	   NVARCHAR(1) NOT NULL,
	Holiday_Name   NVARCHAR(100)
);

--
CREATE TABLE FactSales
	(CONSTRAINT pk_factsales PRIMARY KEY (Order_ID, Product_SK, Employee_SK, Region_SK),
	Product_SK        INT CONSTRAINT fk_factsales_dimproduct_sk FOREIGN KEY REFERENCES DimProduct(Product_SK),
    Employee_SK       INT CONSTRAINT fk_factsales_dimemployee_sk FOREIGN KEY REFERENCES DimEmployee(Employee_SK),
    Region_SK         INT CONSTRAINT fk_factsales_dimregion_sk FOREIGN KEY REFERENCES DimRegion(Region_SK),
    Order_Date        INT NOT NULL CONSTRAINT fk_factsales_orderdate FOREIGN KEY REFERENCES DimDate(Date_SK),
    Ship_Date         INT NOT NULL CONSTRAINT fk_factsales_shipdate FOREIGN KEY REFERENCES DimDate(Date_SK),
    Order_ID          INT,
	Sales_Quantity    INT NOT NULL,
    Full_Price        NUMERIC(6,2) NOT NULL,
    Cost              NUMERIC(6,2) NOT NULL,
    Discount          NUMERIC(4,4) NOT NULL,
    Inventory_On_Hand INT NOT NULL,
    Tax_Rate          NUMERIC(7,4) NOT NULL

);
 --End of the OLAP file.
