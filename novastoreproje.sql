-- =============================================
-- NovaStore E-Ticaret Veri Yönetim Sistemi
-- Muammer Orhan - Proje
-- =============================================

CREATE DATABASE NovaStoreDB;
GO

USE NovaStoreDB;
GO


CREATE TABLE Categories (
 CategoryID INT PRIMARY KEY IDENTITY(1,1),
 CategoryName VARCHAR(50) NOT NULL

)
GO

CREATE TABLE Products(
 ProductID INT PRIMARY KEY IDENTITY(1,1),
 ProductName VARCHAR(100) NOT NULL,
 Price DECIMAL(10,2),
 Stock INT DEFAULT 0 ,
 CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID)
)
GO


CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FullName   VARCHAR(50),
    City       VARCHAR(20),
    Email      VARCHAR(100) UNIQUE
);
GO


CREATE TABLE Orders (
    OrderID     INT PRIMARY KEY IDENTITY(1,1),
    CustomerID  INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderTime DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2)
);
GO


CREATE TABLE OrderDetails (
    DetailID   INT PRIMARY KEY IDENTITY(1,1),
    OrderID    INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID  INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity   INT
);
GO

INSERT INTO Categories (CategoryName) VALUES
('Elektronik'),
('Giyim'),
('Kitap'),
('Kozmetik'),
('Ev ve Yaşam');
GO


INSERT INTO Products (ProductName, Price, Stock, CategoryID) VALUES
-- Elektronik (CategoryID = 1)
('Samsung Galaxy S24', 24999.99, 15, 1),
('Apple AirPods Pro', 8999.99, 30, 1),
('Logitech Mouse', 1299.99, 50, 1),
-- Giyim (CategoryID = 2)
('Nike Spor Ayakkabı', 3499.99, 25, 2),
('Levi''s Jean Pantolon', 1899.99, 40, 2),
('Zara Kaban', 2799.99, 18, 2),
-- Kitap (CategoryID = 3)
('Simyacı - Paulo Coelho', 149.99, 100, 3),
('Suç ve Ceza - Dostoyevski', 189.99, 75, 3),
-- Kozmetik (CategoryID = 4)
('L''Oreal Ruj', 399.99, 60, 4),
('Nivea Krem', 249.99, 80, 4),
-- Ev ve Yaşam (CategoryID = 5)
('Tefal Tencere Seti', 2199.99, 20, 5),
('Philips Blender', 1599.99, 12, 5);
GO

INSERT INTO Customers (FullName,City,Email) VALUES
('Muammer Orhan', 'Nevşehir', 'orhanmuammer@gmail.com'),
('Ayşe Kaya', 'Ankara', 'ayse.kaya@gmail.com'),
('Mehmet Demir', 'İzmir', 'mehmet.demir@gmail.com'),
('Fatma Çelik', 'Konya', 'fatma.celik@gmail.com'),
('Ali Öztürk', 'Antalya', 'ali.ozturk@gmail.com'),
('Zeynep Arslan', 'Adana', 'zeynep.arslan@gmail.com');
GO

INSERT INTO Orders (CustomerID,OrderTime,TotalAmount )  VALUES

(1, '2024-01-15', 24999.99),
(2, '2024-01-20', 4799.98),
(3, '2024-02-05', 3499.99),
(1, '2024-02-10', 339.98),
(4, '2024-02-18', 2199.99),
(5, '2024-03-01', 8999.99),
(6, '2024-03-12', 1899.99),
(2, '2024-03-20', 2799.99),
(3, '2024-04-02', 649.98),
(5, '2024-04-15', 1599.99);
GO

INSERT into OrderDetails(OrderID,ProductID,Quantity) VALUES
(1, 1, 1),   
(2, 4, 1),   
(2, 5, 1),   
(3, 4, 1),   
(4, 7, 1),   
(4, 8, 1),   
(5, 11, 1),  
(6, 2, 1),   
(7, 5, 1),   
(8, 6, 1),   
(9, 9, 1),   
(9, 10, 1),  
(10, 12, 1); 
GO

SELECT ProductName,Stock FROM Products Where Stock<20
ORDER BY Stock DESC ;
GO


SELECT 
c.FullName  AS MusteriAdi,
c.City AS Sehir,
o.OrderTime AS SiparisTarihi,
o.TotalAmount AS ToplamTutar
FROM Customers c
INNER JOIN  Orders o on c.CustomerID=o.CustomerID;
GO


SELECT 
c.FullName AS MusteriAdi,
p.ProductName AS UrunAdi,
p.Price AS Fiyat,
cat.CategoryName AS Kategori

FROM Customers c
INNER JOIN Orders o on c.CustomerID=o.CustomerID
INNER JOIN OrderDetails od on od.OrderID=o.OrderID
INNER JOIN Products p on od.ProductID=p.ProductID
INNER JOIN Categories cat on p.CategoryID=cat.CategoryID
WHERE c.FullName='Muammer Orhan';
GO


SELECT
    cat.CategoryName AS Kategori,
    COUNT (p.ProductID) AS UrunSayisi
FROM Categories cat
 LEFT JOIN Products p on p.CategoryID=cat.CategoryID
 GROUP BY cat.CategoryName;
 GO



SELECT 
    c.FullName    AS MusteriAdi,
    SUM(o.TotalAmount) AS ToplamCiro
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FullName
ORDER BY ToplamCiro DESC;
GO

SELECT 
c.FullName AS MusteriAdi,
o.OrderTime AS SiparisTarihi,
DATEDIFF(DAY,o.OrderTime,GETDATE()) AS GecenGun
FROM Orders o  
INNER JOIN Customers c ON c.CustomerID=o.CustomerID;
GO

-- =============================================
-- BÖLÜM 4: İleri Seviye Veritabanı Nesneleri
-- =============================================

-- 1. VIEW Oluşturma
CREATE VIEW vw_SiparisOzet AS
SELECT 
    c.FullName      AS MusteriAdi,
    o.OrderTime     AS SiparisTarihi,
    p.ProductName   AS UrunAdi,
    od.Quantity     AS Adet
FROM Customers c
INNER JOIN Orders o        ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p      ON od.ProductID = p.ProductID;
GO

SELECT * FROM vw_SiparisOzet;


BACKUP DATABASE NovaStoreDB
TO DISK ='C:\Yedek\NovaStoreDB.bak'
WITH FORMAT , Name = 'NovaStoreDB Tam Yedek';
GO