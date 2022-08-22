USE CarDorm
GO

--Catatan
--Case Simulasi Customer Transaction mulai pada line 268
--Case Simulasi Staff Purchase mulai pada line 407

--Add New Customer
GO
CREATE PROCEDURE NewCustomer (
	@CustomerID VARCHAR(5), @CustomerName VARCHAR(50),
	@CustomerGender VARCHAR(10), @CustomerAddress VARCHAR(255),
	@CustomerEmail VARCHAR(255), @CustomerPhoneNumber VARCHAR(50)
) AS
BEGIN
	IF NOT EXISTS(SELECT * FROM MsCustomer WHERE CustomerId= @CustomerID) AND
		@CustomerID LIKE 'CU[0-9][0-9][0-9]' AND
		LEN(@CustomerName) > 2 AND
		@CustomerGender IN ('Male', 'Female') AND
		(@CustomerEmail LIKE '%@gmail.com' OR @CustomerEmail LIKE '%@yahoo.com')
		BEGIN
			INSERT INTO MsCustomer VALUES(
			@CustomerID, @CustomerName, @CustomerGender, @CustomerAddress, @CustomerEmail, @CustomerPhoneNumber
			)
		END
	ELSE IF EXISTS(SELECT * FROM MsCustomer WHERE CustomerId = @CustomerID)
		BEGIN
			PRINT 'Duplicate Customer ID'
		END
	ELSE IF @CustomerID NOT LIKE 'CU[0-9][0-9][0-9]'
		BEGIN
			PRINT 'CustomerID should be CUXXX where X is number 0-9'
		END
	ELSE IF LEN(@CustomerName) <= 2
		BEGIN
			PRINT 'CustomerName should have more than 2 characters'
		END
	ELSE IF @CustomerGender NOT IN ('Male', 'Female')
		BEGIN
			PRINT 'CustomerGender should only be Male or Female'
		END
	ELSE IF NOT (@CustomerEmail LIKE '%@gmail.com' OR @CustomerEmail LIKE '%@yahoo.com')
		BEGIN
			PRINT 'CustomerEmail must ends with @gmail.com or @yahoo.com'
		END
END

-- Add New Staff
GO
CREATE PROCEDURE NewStaff (
	@StaffID VARCHAR(5), @StaffName VARCHAR(50),
	@StaffGender VARCHAR(10), @StaffAddress VARCHAR(255),
	@StaffEmail VARCHAR(255), @StaffPhoneNumber VARCHAR(50),
	@StaffSalary DECIMAL(12, 2)
) AS
BEGIN
	IF NOT EXISTS(SELECT * FROM MsStaff WHERE StaffId = @StaffID) AND
		@StaffID LIKE 'ST[0-9][0-9][0-9]' AND
		@StaffGender IN ('Male', 'Female') AND
		(@StaffEmail LIKE '%@gmail.com' OR @StaffEmail LIKE '%@yahoo.com') AND
		@StaffSalary BETWEEN 5000000 AND 10000000
		BEGIN
			INSERT INTO MsStaff VALUES(
			@StaffID, @StaffName, @StaffGender, @StaffAddress, @StaffEmail, @StaffPhoneNumber, @StaffSalary
			)
		END
	ELSE IF EXISTS(SELECT * FROM MsStaff WHERE StaffId = @StaffID)
		BEGIN
			PRINT 'Duplicate Staff ID'
		END
	ELSE IF @StaffID NOT LIKE 'ST[0-9][0-9][0-9]'
		BEGIN
			PRINT 'StaffID should be STXXX where X is number 0-9'
		END
	ELSE IF @StaffGender NOT IN ('Male', 'Female')
		BEGIN
			PRINT 'StaffGender should only be Male or Female'
		END
	ELSE IF NOT (@StaffEmail LIKE '%@gmail.com' OR @StaffEmail LIKE '%@yahoo.com')
		BEGIN
			PRINT 'StaffEmail must ends with @gmail.com or @yahoo.com'
		END
	ELSE IF (@StaffSalary NOT BETWEEN 5000000 AND 10000000)
		BEGIN
			PRINT 'StaffSalary must be between 5000000 and 10000000'
		END
END

-- Add New Car
GO
CREATE PROCEDURE NewCar (
	@CarID CHAR(5), @CarName VARCHAR(50),
	@CarPrice DECIMAL(12, 2), @CarStock INT,
	@BrandID CHAR(5)
) AS
BEGIN
	IF NOT EXISTS(SELECT * FROM MsCar WHERE CarId = @CarID) AND
	@CarID LIKE 'CA[0-9][0-9][0-9]' AND
	EXISTS (SELECT * FROM MsBrand WHERE BrandId = @BrandID)
		BEGIN
			INSERT INTO MsCar VALUES(
			@CarID, @CarName, @CarPrice, @CarStock, @BrandID
			)
		END
	ELSE IF EXISTS(SELECT * FROM MsCar WHERE CarId = @CarID)
		BEGIN
			PRINT 'Duplicate Car ID'
		END
	ELSE IF @CarID NOT LIKE 'CA[0-9][0-9][0-9]'
		BEGIN
			PRINT 'CarID should be CAXXX where X is number 0-9'
		END
	ELSE IF NOT EXISTS (SELECT * FROM MsBrand WHERE BrandId = @BrandID)
		BEGIN
			PRINT 'BrandID does not exist yet'
		END
END

--Add New Vendor
GO
CREATE PROCEDURE NewVendor (
	@VendorID VARCHAR(5), @VendorName VARCHAR(50),
	@VendorAddress VARCHAR(255), @VendorEmail VARCHAR(255), 
	@VendorPhoneNumber VARCHAR(50)
) AS
BEGIN
	IF NOT EXISTS(SELECT * FROM MsVendor WHERE VendorId = @VendorID) AND
		@VendorID LIKE 'VE[0-9][0-9][0-9]' AND
		(@VendorEmail LIKE '%@gmail.com' OR @VendorEmail LIKE '%@yahoo.com')
		BEGIN
			INSERT INTO MsVendor VALUES(
			@VendorID, @VendorName, @VendorAddress, @VendorEmail, @VendorPhoneNumber
			)
		END
	ELSE IF EXISTS(SELECT * FROM MsVendor WHERE VendorId = @VendorID)
		BEGIN
			PRINT 'Duplicate Vendor ID'
		END
	ELSE IF @VendorID NOT LIKE 'VE[0-9][0-9][0-9]'
		BEGIN
			PRINT 'VendorID should be VEXXX where X is number 0-9'
		END
	ELSE IF NOT (@VendorEmail LIKE '%@gmail.com' OR @VendorEmail LIKE '%@yahoo.com')
		BEGIN
			PRINT 'VendorEmail must ends with @gmail.com or @yahoo.com'
		END
END


-- Add New Car Brand
GO
CREATE PROCEDURE NewBrand (
	@BrandID CHAR(5), @BrandName VARCHAR(50)
) AS
BEGIN
	IF NOT EXISTS(SELECT * FROM MsBrand WHERE BrandId = @BrandID) AND
	@BrandID LIKE 'CB[0-9][0-9][0-9]' 
		BEGIN
			INSERT INTO MsBrand VALUES(
			@BrandID, @BrandName
			)
		END
	ELSE IF EXISTS(SELECT * FROM MsBrand WHERE BrandId = @BrandID)
		BEGIN
			PRINT 'Duplicate Brand ID'
		END
	ELSE IF @BrandID NOT LIKE 'CB[0-9][0-9][0-9]'
		BEGIN
			PRINT 'BrandID should be CBXXX where X is number 0-9'
		END
END

--Customer Transaction 
GO
CREATE PROCEDURE CustomerTransaction (
	@StaffID VARCHAR(5), @CustomerID VARCHAR(5), 
	@TransactionDate DATE, @TransactionID CHAR(5), 
	@CarQuantity INT, @CarID CHAR(5)
) AS
BEGIN
	IF 
		EXISTS(SELECT * FROM MsStaff WHERE StaffId = @StaffID) AND 
		EXISTS(SELECT * FROM MsCustomer WHERE CustomerId = @CustomerID) AND
		EXISTS(SELECT * FROM MsCar WHERE CarId = @CarID AND CarStock >= @CarQuantity) AND
		NOT EXISTS(SELECT * FROM TransactionHeader WHERE TransactionId = @TransactionID) AND
		@CarQuantity > 0
		BEGIN
			INSERT INTO TransactionHeader VALUES(
			@TransactionID, @TransactionDate, @StaffID, @CustomerID
			)
			INSERT INTO TransactionDetail VALUES(
			@CarQuantity, @TransactionID, @CarID
			)
			UPDATE MsCar
			SET CarStock = CarStock - @CarQuantity
			WHERE CarId = @CarID
		END
	ELSE IF NOT EXISTS(SELECT * FROM MsStaff WHERE StaffId = @StaffID)
		BEGIN
			PRINT 'Staff does not exist'
		END
	ELSE IF NOT EXISTS(SELECT * FROM MsCar WHERE CarId = @CarID)
		BEGIN
			PRINT 'Car does not exist'
		END
	ELSE IF NOT EXISTS(SELECT * FROM MsCustomer WHERE CustomerId = @CustomerID)
		BEGIN
			PRINT 'Customer does not exist'
		END
	ELSE IF EXISTS(SELECT * FROM TransactionHeader WHERE TransactionId = @TransactionID)
		BEGIN
			PRINT 'Duplicate Transaction ID'
		END
	ELSE IF @CarQuantity <= 0
		BEGIN
			PRINT 'Car quantity cannot be 0 or less'
		END
	ELSE IF EXISTS(SELECT CarStock FROM MsCar WHERE CarId = @CarID AND CarStock = 0)
		BEGIN
			PRINT 'Car Out of Stock'
		END
	ELSE IF NOT EXISTS(SELECT CarStock FROM MsCar WHERE CarId = @CarID AND CarStock >= @CarQuantity)
		BEGIN
			PRINT 'Car Stock Insufficient'
		END
END

GO
CREATE PROCEDURE CarTransactionOnly (
	@TransactionID CHAR(5), @CarQuantity INT, 
	@CarID CHAR(5)
) AS
BEGIN
	IF EXISTS(SELECT * FROM MsCar WHERE CarId = @CarID) AND
		EXISTS(SELECT * FROM MsCar WHERE CarId = @CarID AND CarStock >= @CarQuantity) AND
		EXISTS(SELECT * FROM TransactionHeader WHERE TransactionId = @TransactionID) AND
		@CarQuantity > 0
		BEGIN
			INSERT INTO TransactionDetail VALUES(
			@CarQuantity, @TransactionID, @CarID
			)
			UPDATE MsCar
			SET CarStock = CarStock - @CarQuantity
			WHERE CarId = @CarID
		END
	ELSE IF NOT EXISTS(SELECT * FROM TransactionHeader WHERE TransactionId = @TransactionID)
		BEGIN
			PRINT 'Transaction ID does not exist yet'
		END
	ELSE IF NOT EXISTS(SELECT * FROM MsCar WHERE CarId = @CarID)
		BEGIN
			PRINT 'Car does not exist'
		END
	ELSE IF @CarQuantity <= 0
		BEGIN
			PRINT 'Car quantity cannot be 0 or less'
		END
	ELSE IF EXISTS(SELECT CarStock FROM MsCar WHERE CarId = @CarID AND CarStock = 0)
		BEGIN
			PRINT 'Car Out of Stock'
		END
	ELSE IF NOT EXISTS(SELECT CarStock FROM MsCar WHERE CarId = @CarID AND CarStock >= @CarQuantity)
		BEGIN
			PRINT 'Car Stock Insufficient'
		END
END

--Case Simulasi Customer Transaction

--1 
--Customer bernama "Ayra" dengan kode customer CU005 membeli 2 mobil
--Dihatsu Blizzard dengan kode mobil CA003 dan 1 mobil Mutsibushu Bolt 
--dengan kode mobil CA008 dilayani oleh staff bernama "Maximus Schaefer" 
--dengan kode staff ST006 tanggal 24 Desember 2021

EXEC CustomerTransaction 'ST006', 'CU005', '2021-12-24', 'TR021', 2, 'CA003';
EXEC CarTransactionOnly 'TR021', 1, 'CA008';

--2 
--Customer baru bernama "Alya Putri" dengan kode customer CU011, gender
--Female, alamat 18 Ace Ave. Suramaya, email Alya@yahoo.com, dan nomor
--telepon +62-812-992-123 membeli 4 mobil Chovrelot Necro dengan kode
--mobil CA011 dan dan 2 mobil Tayato Goodfella dengan kode mobil CA001 
--dilayani oleh staff bernama "Kristie Garrison" 
--dengan kode staff ST003 tanggal 25 Desember 2021

EXEC NewCustomer 'CU011', 'Alya Putri', 'Female', '18 Ace Ave. Suramaya', 'Alya@yahoo.com', '+62-812-992-123';
EXEC CustomerTransaction 'ST003', 'CU011', '2021-12-25', 'TR022', 4, 'CA011';
EXEC CarTransactionOnly 'TR022', 2, 'CA001';

--Case Saat Gagal pada Simulasi Customer Transaction
--3
--Customer bernama "Morris" dengan kode customer CU006
--membeli 120 mobil Chovrelot Necro dengan kode
--mobil CA011 dilayani oleh staff bernama "Zackery Frank" 
--dengan kode staff ST004 tanggal 25 Desember 2021
--maka simulasi akan mengeluarkan error karena stock
--mobil yang tersedia tidak mencukupi

EXEC CustomerTransaction 'ST004', 'CU006', '2021-12-25', 'TR023', 240, 'CA011';

--4
--Customer bernama "Athena Nunez Santo" dengan kode customer CU007 
--membeli mobil namun salah input, dimasukkan 0 mobil Chovrelot Necro dengan kode
--mobil CA011 dilayani oleh staff bernama "Zackery Frank" 
--dengan kode staff ST004 tanggal 25 Desember 2021
--maka simulasi akan mengeluarkan error karena quantity
--mobil yang dibeli tidak boleh kurang dari atau sama dengan 0

EXEC CustomerTransaction 'ST004', 'CU007', '2021-12-25', 'TR023', 0, 'CA011';

--5
--Customer bernama "Athena Nunez Santo" dengan kode customer CU007 
--membeli 54 mobil Tayato Goodfella dengan kode
--mobil CA001 dilayani oleh staff bernama "Zackery Frank" 
--dengan kode staff ST004 tanggal 25 Desember 2021
--transaksi pertama berhasil namun
--5 jam setelahnya customer yang sama kembali untuk membeli 4 mobil yang sama
--dilayani oleh staff bernama "Gwen Orr" engan kode staff ST002, maka di 
--transaksi keduanya, simulasi akan mengeluarkan error karena
--stock mobil telah habis (Mohon lakukan transaksi di case no 2 terlebih dahulu 
--agar car stock sesuai)

EXEC CustomerTransaction 'ST004', 'CU006', '2021-12-25', 'TR023', 54, 'CA001';
EXEC CustomerTransaction 'ST002', 'CU006', '2021-12-25', 'TR024', 4, 'CA001';



--Staff Purchase
GO
CREATE PROCEDURE StaffPurchase (
	@StaffID VARCHAR(5), @PurchaseDate DATE, 
	@CarQuantity INT, @CarID CHAR(5), 
	@PurchaseID CHAR(5), @VendorID CHAR(5)
) AS
BEGIN
	IF EXISTS(SELECT * FROM MsStaff WHERE StaffId = @StaffID) AND
		EXISTS(SELECT * FROM MsVendor WHERE VendorId = @VendorID) AND
		EXISTS(SELECT * FROM MsCar WHERE CarId = @CarID) AND
		NOT EXISTS(SELECT * FROM PurchaseHeader WHERE PurchaseId = @PurchaseID) AND
		@CarQuantity > 0 
		BEGIN
			INSERT INTO PurchaseHeader VALUES(
			@PurchaseID, @PurchaseDate, @StaffID, @VendorID
			)
			INSERT INTO PurchaseDetail VALUES(
			@CarQuantity, @PurchaseID, @CarID
			)
			UPDATE MsCar
			SET CarStock = CarStock + @CarQuantity
			WHERE CarId = @CarID
		END
	ELSE IF NOT EXISTS(SELECT * FROM MsStaff WHERE StaffId = @StaffID)
		BEGIN
			PRINT 'Staff does not exist'
		END
	ELSE IF NOT EXISTS(SELECT * FROM MsCar WHERE CarId = @CarID)
		BEGIN
			PRINT 'Car does not exist'
		END
	ELSE IF NOT EXISTS(SELECT * FROM MsVendor WHERE VendorId = @VendorID)
		BEGIN
			PRINT 'Vendor does not exist'
		END
	ELSE IF EXISTS(SELECT * FROM PurchaseHeader WHERE PurchaseId = @PurchaseID)
		BEGIN
			PRINT 'Duplicate Purchase ID'
		END
	ELSE IF @CarQuantity <= 0
		BEGIN
			PRINT 'Car quantity cannot be 0 or less'
		END

END

GO
CREATE PROCEDURE CarPurchaseOnly (
	@PurchaseID CHAR(5), @CarQuantity INT, 
	@CarID CHAR(5)
) AS
BEGIN
	IF EXISTS(SELECT * FROM MsCar WHERE CarId = @CarID) AND
		EXISTS(SELECT * FROM PurchaseHeader WHERE PurchaseId = @PurchaseID) AND
		@CarQuantity > 0
		BEGIN
			INSERT INTO PurchaseDetail VALUES(
			@CarQuantity, @PurchaseID, @CarID
			)
			UPDATE MsCar
			SET CarStock = CarStock + @CarQuantity
			WHERE CarId = @CarID
		END
	ELSE IF NOT EXISTS(SELECT * FROM PurchaseHeader WHERE PurchaseId = @PurchaseID)
		BEGIN
			PRINT 'Purchase ID does not exist yet'
		END
	ELSE IF NOT EXISTS(SELECT * FROM MsCar WHERE CarId = @CarID)
		BEGIN
			PRINT 'Car does not exist'
		END
	ELSE IF @CarQuantity <= 0
		BEGIN
			PRINT 'Car quantity cannot be 0 or less'
		END
END

--Case Simulasi Staff Purchase

--1 
--Staff bernama "Gwen Orr" dengan kode staff ST002 
--membeli 2 Nassin Spret dengan kode mobil CA006 dan 10 Masdah
--Ace Spade dengan kode mobil CA016 dari vendor 
--"PT Nila Bangsa Semesta" dengan kode vendor VE008
-- pada tanggal 10 Oktober 2021

EXEC StaffPurchase 'ST002', '2021-10-10', 2, 'CA006', 'PU016', 'VE008';
EXEC CarPurchaseOnly 'PU016', 10, 'CA016';

--2
--Staff bernama "Zaki Gunn" dengan kode staff ST010 
--membeli 12 Kai Fang dengan kode mobil CA018 dan 1 mobil dengan 
--brand baru bernama Tuzla dengan kode brand baru CB011 dan namanya
--Vegeza dengan kode mobil baru CA021 dengan harga 512500100 dari 
--vendor baru bernama "PT Ceria Mantap" dengan kode vendor baru 
--VE011 beralamat 78 Olivia Foe Riverview, email Ceriamantap@gmail.com, 
--dan nomor telepon +62-812-462-921 pada tanggal 12 Oktober 2021

EXEC NewVendor 'VE011', 'PT Ceria Mantap', '78 Olivia Foe Riverview', 'Ceriamantap@gmail.com', '+62-812-462-921';
EXEC NewBrand 'CB011', 'Tuzla';
EXEC NewCar 'CA021', 'Vegeza', 512500100, 0, CB011;
EXEC StaffPurchase 'ST010', '2021-10-12', 12, 'CA018', 'PU017', 'VE011';
EXEC CarPurchaseOnly 'PU017', 1, 'CA021';

--Case Saat Gagal pada Simulasi Staff Purchase

--3
--Staff bernama "Zackery Frank"  dengan kode customer ST004 
--membeli 0 mobil Chovrelot Necro dengan kode mobil CA011 kepada 
--"PT Sekajang" dengan kode vendor VE003 tanggal 10 November 2021
--maka simulasi akan mengeluarkan error karena quantity
--mobil yang dibeli staff tidak boleh kurang dari atau sama dengan 0

EXEC StaffPurchase 'ST004', '2021-11-10', 0, 'CA011', 'PU018', 'VE003';


