--Soal E
USE CarDorm

-- 1
SELECT 'Mrs. ' + CustomerName AS [CustomerName], 
UPPER(CustomerGender) AS [CustomerGender],
COUNT(th.TransactionId) AS [Total Transaction]
FROM MsCustomer AS c 
JOIN TransactionHeader AS th 
ON c.CustomerId = th.CustomerId
WHERE CustomerGender = 'Female' AND 
LEN(TRIM(CustomerName)) - LEN(REPLACE(TRIM(CustomerName), ' ', '')) > 0
GROUP BY CustomerName, CustomerGender;


--2
SELECT c.CarId, 
c.CarName, 
b.BrandName AS [CarBrandName], 
c.CarPrice, 
CONVERT(VARCHAR(10), SUM(td.CarQuantity)) + ' Car(s)' 
AS [Total of Car That Has Been Sold]
FROM MsCar AS c
JOIN MsBrand AS b 
ON c.BrandId = b.BrandId
JOIN TransactionDetail AS td 
ON c.CarId = td.CarId
WHERE CarPrice > 300000000 AND
CONVERT(INT, RIGHT(c.CarId, 3)) % 2 = 1
GROUP BY c.CarId, c.CarName, b.BrandName, c.CarPrice
HAVING SUM(CarQuantity) > 1;

--3
SELECT REPLACE(s.StaffId, 'ST', 'Staff ') AS [StaffId], 
s.StaffName, 
COUNT(DISTINCT(th.TransactionId)) AS [Total Transaction Handled], 
MAX(td.CarQuantity) AS [MaximumQuantity in One Transaction]
FROM MsStaff AS s
JOIN TransactionHeader AS th ON s.StaffId = th.StaffId
JOIN TransactionDetail AS td ON th.TransactionId = td.TransactionId
WHERE LEN(TRIM(s.StaffName)) - LEN(REPLACE(TRIM(StaffName), ' ', '')) > 0 AND
MONTH(th.TransactionDate) = 4 
GROUP BY s.StaffId, s.StaffName, s.StaffEmail
HAVING COUNT(DISTINCT(th.TransactionId)) > 1
ORDER BY [MaximumQuantity in One Transaction] DESC;

--4
SELECT c.CustomerName,
LEFT(c.CustomerGender, 1) AS [CustomerGender],
COUNT(DISTINCT(th.TransactionId)) AS [Total Purchase], 
SUM(td.CarQuantity) AS [Total of Car That Has Been Purchased]
FROM MsCustomer AS c
JOIN TransactionHeader AS th ON c.CustomerId = th.CustomerId
JOIN TransactionDetail AS td ON th.TransactionId = td.TransactionId
WHERE c.CustomerEmail LIKE '%@gmail.com'
GROUP BY c.CustomerName, c.CustomerGender
HAVING SUM(td.CarQuantity) > 2

--5
SELECT REPLACE(v.VendorName, 'PT', 'Perseroan Terbatas') AS [VendorName], 
v.VendorPhoneNumber, 
RIGHT(ph.PurchaseId, 3) AS [Purchase ID Number],
SUM(pd.CarQuantity) AS [Quantity]
FROM MsVendor AS v
JOIN PurchaseHeader AS ph on v.VendorId = ph.VendorId
JOIN PurchaseDetail AS pd on ph.PurchaseId = pd.PurchaseId,
	(SELECT AVG(y.quantity) AS Avg_Quantity
	FROM (
		SELECT ph.PurchaseId, SUM(pd.CarQuantity) AS quantity
		FROM MsVendor AS v
		JOIN PurchaseHeader AS ph on v.VendorId = ph.VendorId
		JOIN PurchaseDetail AS pd on ph.PurchaseId = pd.PurchaseId
		WHERE v.VendorName LIKE '%a%'
		GROUP BY ph.PurchaseId
		) y
	) x
GROUP BY v.VendorName, v.VendorPhoneNumber, ph.PurchaseId, x.Avg_Quantity
HAVING SUM(pd.CarQuantity) > x.Avg_Quantity;

--6
SELECT UPPER(CONCAT(BrandName, ' ', CarName)) AS [Name],
'Rp. '+ CONVERT(VARCHAR, c.CarPrice) AS [Price], 
CONVERT(VARCHAR, c.CarStock) + ' Stock(s)' AS [Stock]  
FROM MsCar AS c
JOIN MsBrand AS b ON c.BrandId = b.BrandId,
(SELECT AVG(c.CarPrice) avg_price
	FROM MsCar AS c
) x
WHERE c.CarPrice > x.avg_price AND c.CarName LIKE '%e%';

--7
SELECT RIGHT(c.CarId, 3) AS [Car ID Number], 
c.CarName, UPPER(b.BrandName) AS [Brand],
'Rp. ' + CONVERT(VARCHAR, c.CarPrice) AS [Price],
SUM(td.CarQuantity) AS [Total of Car That Has Been Sold]
FROM MsCar AS c
JOIN MsBrand AS b ON c.BrandId = b.BrandId
JOIN TransactionDetail AS td ON c.CarId = td.CarId,
(
SELECT AVG(y.quantity) AS avg_quantity
FROM (SELECT c.CarId, SUM(CarQuantity) AS quantity
	FROM MsCar AS c
	JOIN MsBrand AS b ON c.BrandId = b.BrandId
	JOIN TransactionDetail AS td ON c.CarId = td.CarId
	GROUP BY c.CarId, c.CarName, b.BrandName
) y
) x
WHERE c.CarPrice > 200000000 AND
CarName LIKE '%o%'
GROUP BY c.CarId, c.CarName, b.BrandName, c.CarPrice, x.avg_quantity
HAVING SUM(td.CarQuantity) > x.avg_quantity;


--8
SELECT SUBSTRING(s.StaffName, 1, CHARINDEX(' ', s.StaffName, 1)-1) AS [Staff First Name],
SUBSTRING(s.StaffName, LEN(s.StaffName) - (CHARINDEX(' ', REVERSE(s.StaffName),1)-2), LEN(s.StaffName)) AS [Staff Last Name],
SUM(td.CarQuantity) AS [Total of Car That Has Been Sold]
FROM MsStaff AS s
JOIN TransactionHeader AS th ON s.StaffId = th.StaffId
JOIN TransactionDetail AS td ON th.TransactionId = td.TransactionId,
(
SELECT AVG(y.quantity) AS avg_quantity
FROM (SELECT th.TransactionId, SUM(CarQuantity) AS quantity
	FROM TransactionHeader AS th
	JOIN TransactionDetail AS td ON th.TransactionId = td.TransactionId
	GROUP BY th.TransactionId
) y
) x
WHERE LEN(TRIM(s.StaffName)) - LEN(REPLACE(TRIM(s.StaffName), ' ', '')) >0
GROUP BY s.StaffId, s.StaffName, x.avg_quantity
HAVING SUM(td.CarQuantity) > x.avg_quantity;


--9
CREATE VIEW [Vendor_Transaction_Handled_and_Minimum_View]
AS 
SELECT REPLACE(v.VendorId, 'VE', 'Vendor ') AS [Vendor ID],
v.VendorName AS [VendorName], 
COUNT(DISTINCT(ph.PurchaseId)) AS [Total Transaction Handled],
MIN(pd.CarQuantity) AS [Minimum Purchases in One Transaction]
FROM MsVendor AS v
JOIN PurchaseHeader AS ph ON v.VendorId = ph.VendorId
JOIN PurchaseDetail AS pd ON ph.PurchaseId = pd.PurchaseId
WHERE MONTH(ph.PurchaseDate) = 5 AND
v.VendorName LIKE '%a%'
GROUP BY v.VendorId, v.VendorName;

--10
CREATE VIEW [Staff_Total_Purchase_and_Max_Car_Purchase_View]
AS
SELECT s.StaffId AS [StaffID], 
s.StaffName AS [StaffName], 
UPPER(s.StaffEmail) AS [StaffEmail],
COUNT(DISTINCT(ph.PurchaseId)) AS [Total Purchase],
MAX(pd.CarQuantity) AS [Maximum of Car That Has Been Purchased in One Purchase]
FROM MsStaff AS s
JOIN PurchaseHeader AS ph ON s.StaffId = ph.StaffId
JOIN PurchaseDetail AS pd ON ph.PurchaseId = pd.PurchaseId
WHERE s.StaffGender = 'Female' AND
s.StaffEmail LIKE '%@yahoo.com'
GROUP BY s.StaffId, s.StaffName, s.StaffEmail;