CREATE DATABASE CarDorm;
GO
USE CarDorm;
GO

CREATE TABLE [MsCustomer](
	[CustomerId] CHAR(5) PRIMARY KEY 
		CHECK (CustomerId LIKE 'CU[0-9][0-9][0-9]'),
	[CustomerName] VARCHAR(50) NOT NULL
		CHECK (LEN(CustomerName) > 2),
	[CustomerGender] VARCHAR(10) NOT NULL
		CHECK (CustomerGender IN ('Male', 'Female')),
	[CustomerAddress] VARCHAR(255) NOT NULL,
	[CustomerEmail] VARCHAR(255) NOT NULL
		CHECK (CustomerEmail LIKE '%@gmail.com' OR CustomerEmail LIKE '%@yahoo.com'),
	[CustomerPhoneNumber] VARCHAR(50) NOT NULL
);

CREATE TABLE [MsStaff](
	[StaffId] CHAR(5) PRIMARY KEY 
		CHECK (StaffId LIKE 'ST[0-9][0-9][0-9]'),
	[StaffName] VARCHAR(50) NOT NULL,
	[StaffGender] VARCHAR(10) NOT NULL
		CHECK (StaffGender IN ('Male', 'Female')),
	[StaffAddress] VARCHAR(255) NOT NULL,
	[StaffEmail] VARCHAR(255) NOT NULL
		CHECK (StaffEmail LIKE '%@gmail.com' OR StaffEmail LIKE '%@yahoo.com'),
	[StaffPhoneNumber] VARCHAR(50) NOT NULL,
	[StaffSalary] DECIMAL(12, 2) NOT NULL
		CHECK(StaffSalary BETWEEN 5000000 AND 10000000)
);

CREATE TABLE [MsVendor](
	[VendorId] CHAR(5) PRIMARY KEY 
		CHECK (VendorId LIKE 'VE[0-9][0-9][0-9]'),
	[VendorName] VARCHAR(50) NOT NULL,
	[VendorAddress] VARCHAR(255) NOT NULL,
	[VendorEmail] VARCHAR(255) NOT NULL
		CHECK (VendorEmail LIKE '%@gmail.com' OR VendorEmail LIKE '%@yahoo.com'),
	[VendorPhoneNumber] VARCHAR(50) NOT NULL
);

CREATE TABLE [MsBrand](
	[BrandId] CHAR(5) PRIMARY KEY 
		CHECK (BrandId LIKE 'CB[0-9][0-9][0-9]'),
	[BrandName] VARCHAR(50) NOT NULL
);


CREATE TABLE [MsCar](
	[CarId] CHAR(5) PRIMARY KEY 
		CHECK (CarId LIKE 'CA[0-9][0-9][0-9]'),
	[CarName] VARCHAR(50) NOT NULL,
	[CarPrice] DECIMAL(12, 2) NOT NULL,
	[CarStock] INT NOT NULL,
	[BrandId] CHAR(5) NOT NULL FOREIGN KEY REFERENCES MsBrand(BrandId)
);

CREATE TABLE [PurchaseHeader](
	[PurchaseId] CHAR(5) PRIMARY KEY 
		CHECK (PurchaseId LIKE 'PU[0-9][0-9][0-9]'),
	[PurchaseDate] DATE NOT NULL
		CHECK (CAST(PurchaseDate as DATE) <= CAST(GETDATE() as DATE)),
	[StaffId] CHAR(5) NOT NULL,
	[VendorId] CHAR(5) NOT NULL,
	FOREIGN KEY(StaffId) REFERENCES MsStaff(StaffId) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(VendorId) REFERENCES MsVendor(VendorId) ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE [TransactionHeader](
	[TransactionId] CHAR(5) PRIMARY KEY 
		CHECK (TransactionId LIKE 'TR[0-9][0-9][0-9]'),
	[TransactionDate] DATE NOT NULL
		CHECK (CAST(TransactionDate as DATE) <= CAST(GETDATE() as DATE)),
	[StaffId] CHAR(5) NOT NULL,
	[CustomerId] CHAR(5) NOT NULL,
	FOREIGN KEY(StaffId) REFERENCES MsStaff(StaffId) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(CustomerId) REFERENCES MsCustomer(CustomerId) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE [PurchaseDetail](
	[CarQuantity] INT NOT NULL
		CHECK (CarQuantity > 0),
	[PurchaseId] CHAR(5) NOT NULL,
	[CarId] CHAR(5) NOT NULL,
	PRIMARY KEY(PurchaseId, CarId),
	FOREIGN KEY(PurchaseId) REFERENCES PurchaseHeader(PurchaseId) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(CarId) REFERENCES MsCar(CarId) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE [TransactionDetail](
	[CarQuantity] INT NOT NULL,
		CHECK (CarQuantity > 0),
	[TransactionId] CHAR(5) NOT NULL,
	[CarId] CHAR(5) NOT NULL,
	PRIMARY KEY(TransactionId, CarId),
	FOREIGN KEY(TransactionId) REFERENCES TransactionHeader(TransactionId) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(CarId) REFERENCES MsCar(CarId) ON UPDATE CASCADE ON DELETE CASCADE
);
