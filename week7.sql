-- 1NF Transformation: Ensuring each product is in its own row
-- Step 1: Create a table for 1NF transformation
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(50)
);

-- Step 2: Insert data into the new table by splitting the Products column
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT OrderID, CustomerName, TRIM(value) AS Product
FROM ProductDetail
CROSS APPLY STRING_SPLIT(Products, ',')
ORDER BY OrderID;

-- 2NF Transformation: Removing partial dependencies
-- Step 1: Create OrderDetails table to store order products and quantities
CREATE TABLE OrderDetails (
    OrderID INT,
    Product VARCHAR(50),
    Quantity INT,
    PRIMARY KEY (OrderID, Product)
);

-- Step 2: Insert data into OrderDetails
INSERT INTO OrderDetails (OrderID, Product, Quantity)
SELECT OrderID, TRIM(value) AS Product, Quantity
FROM OrderDetails
CROSS APPLY STRING_SPLIT(Product, ',');

-- Step 3: Create Customers table to store customer names
CREATE TABLE Customers (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Step 4: Insert data into Customers
INSERT INTO Customers (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;
