--- Clients Table: Info about each client
CREATE TABLE Clients (
    ClientID INT PRIMARY KEY,
    ClientName VARCHAR(100),
    Industry VARCHAR(50),
    Region VARCHAR(50),
    AccountManager VARCHAR(100)
);

 --Projects Table: Each project given by a client
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ClientID INT,
    ProjectName VARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID)
);

---Revenue Table: Monthly payments from each project
CREATE TABLE Revenue (
    RevenueID INT PRIMARY KEY,
    ProjectID INT,
    Month DATE,
    Amount DECIMAL(10,2),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

INSERT INTO Clients VALUES
(1, 'Infosys', 'IT', 'Asia', 'John Doe'),
(2, 'TCS', 'IT', 'Europe', 'Jane Smith'),
(3, 'Wipro', 'IT', 'US', 'Mike Johnson');

SELECT * FROM Clients;

INSERT INTO Projects VALUES
(101, 1, 'Data Cleanup', '2024-01-01', '2024-03-01', 'Completed'),
(102, 2, 'Web Analytics', '2024-02-01', '2024-05-01', 'Ongoing'),
(103, 3, 'Automation Bot', '2024-03-01', '2024-07-01', 'Ongoing');

INSERT INTO Revenue VALUES
(1, 101, '2024-01-01', 10000.00),
(2, 101, '2024-02-01', 12000.00),
(3, 102, '2024-02-01', 15000.00),
(4, 103, '2024-03-01', 20000.00);

INSERT INTO ClientFeedback VALUES
(1, 1, '2024-01-01', 9),
(2, 1, '2024-02-01', 8),
(3, 2, '2024-02-01', 5),
(4, 3, '2024-03-01', 6);

---Monthly Revenue by Region
SELECT 
    C.Region,
    FORMAT(R.Month, 'yyyy-MM') AS Month,
    SUM(R.Amount) AS TotalRevenue
FROM Revenue R
JOIN Projects P ON R.ProjectID = P.ProjectID
JOIN Clients C ON P.ClientID = C.ClientID
GROUP BY C.Region, FORMAT(R.Month, 'yyyy-MM')
ORDER BY Month, Region;

---Top 5 Clients by Total Revenue
SELECT TOP 5
    C.ClientName,
    SUM(R.Amount) AS TotalRevenue
FROM Revenue R
JOIN Projects P ON R.ProjectID = P.ProjectID
JOIN Clients C ON P.ClientID = C.ClientID
GROUP BY C.ClientName
ORDER BY TotalRevenue DESC;

---Clients With Low Satisfaction (Avg < 6)
SELECT 
    C.ClientName,
    AVG(F.SatisfactionScore) AS AvgScore
FROM ClientFeedback F
JOIN Clients C ON F.ClientID = C.ClientID
GROUP BY C.ClientName
HAVING AVG(F.SatisfactionScore) < 6;

----Delayed Projects
SELECT 
    P.ProjectName, 
    C.ClientName, 
    P.EndDate, 
    P.Status
FROM Projects P
JOIN Clients C ON P.ClientID = C.ClientID
WHERE P.EndDate < CAST(GETDATE() AS DATE) 
  AND P.Status <> 'Completed';





