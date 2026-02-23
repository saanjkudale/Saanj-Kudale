DROP DATABASE IF EXISTS PersonalBudget;
CREATE DATABASE PersonalBudget; 
USE PersonalBudget; 
CREATE TABLE Users ( 
    UserID INT AUTO_INCREMENT PRIMARY KEY, 
    UserName VARCHAR(50) NOT NULL, 
    Email VARCHAR(50) UNIQUE NOT NULL, 
    Password VARCHAR(50) NOT NULL 
);
CREATE TABLE Income ( 
    IncomeID INT AUTO_INCREMENT PRIMARY KEY, 
    UserID INT, 
    IncomeSource VARCHAR(50) NOT NULL, 
    Amount DECIMAL(10,2) NOT NULL, 
    DateReceived DATE NOT NULL, 
    FOREIGN KEY (UserID) REFERENCES Users(UserID) 
);
CREATE TABLE Expenses ( 
    ExpenseID INT AUTO_INCREMENT PRIMARY KEY, 
    UserID INT, 
    ExpenseCategory VARCHAR(50) NOT NULL, 
    Amount DECIMAL(10,2) NOT NULL, 
    ExpenseDate DATE NOT NULL, 
    FOREIGN KEY (UserID) REFERENCES Users(UserID) 
);
CREATE TABLE Budget ( 
    BudgetID INT AUTO_INCREMENT PRIMARY KEY, 
    UserID INT, 
    Category VARCHAR(50) NOT NULL, 
    PlannedAmount DECIMAL(10,2) NOT NULL, 
    Month VARCHAR(20) NOT NULL, 
    FOREIGN KEY (UserID) REFERENCES Users(UserID) 
);
CREATE TABLE Reports ( 
    ReportID INT AUTO_INCREMENT PRIMARY KEY, 
    UserID INT, 
    ReportType VARCHAR(50) NOT NULL, 
    GeneratedOn DATE NOT NULL, 
    ReportData TEXT NOT NULL, 
    FOREIGN KEY (UserID) REFERENCES Users(UserID) 
);
INSERT INTO Users (UserName, Email, Password) 
VALUES ('Dhanashree', 'dhanashree@example.com', 'pass123');
INSERT INTO Income (UserID, IncomeSource, Amount, DateReceived) 
VALUES (1, 'Salary', 50000, '2026-02-01');
INSERT INTO Expenses (UserID, ExpenseCategory, Amount, ExpenseDate) 
VALUES (1, 'Food', 5000, '2026-02-05');
INSERT INTO Budget (UserID, Category, PlannedAmount, Month) 
VALUES (1, 'Food', 6000, 'February');
INSERT INTO Reports (UserID, ReportType, GeneratedOn, ReportData) 
VALUES (1, 'Monthly Summary', '2026-02-28', 'Income: 50000, Expenses: 5000, Savings: 
45000');
SELECT * FROM Income WHERE UserID = 1;
SELECT * FROM Expenses WHERE UserID = 1;
SELECT u.UserName, i.Amount AS TotalIncome, SUM(e.Amount) AS TotalExpenses, 
       (i.Amount - SUM(e.Amount)) AS Balance 
FROM Users u 
JOIN Income i ON u.UserID = i.UserID 
JOIN Expenses e ON u.UserID = e.UserID 
WHERE u.UserID = 1 
GROUP BY u.UserName, i.Amount;
SELECT ExpenseCategory, SUM(Amount) AS TotalSpent 
FROM Expenses 
WHERE UserID = 1 
GROUP BY ExpenseCategory; 
SELECT ExpenseCategory, SUM(Amount) AS TotalSpent 
FROM Expenses 
WHERE UserID = 1 
GROUP BY ExpenseCategory 
HAVING SUM(Amount) > 3000; 
SELECT UserID, UserName 
FROM Users 
WHERE UserID IN ( 
    SELECT UserID 
    FROM Expenses 
    WHERE ExpenseCategory = 'Food' AND Amount > 4000 
);
CREATE VIEW MonthlySummary AS 
SELECT u.UserID, u.UserName, 
       i.Amount AS TotalIncome, 
       SUM(e.Amount) AS TotalExpenses, 
       (i.Amount - SUM(e.Amount)) AS Balance 
FROM Users u 
JOIN Income i ON u.UserID = i.UserID 
JOIN Expenses e ON u.UserID = e.UserID 
GROUP BY u.UserID, u.UserName, i.Amount;