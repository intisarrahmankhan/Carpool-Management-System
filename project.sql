CREATE DATABASE Carpool
GO 
USE Carpool
GO
-- USER table to store generic data of driver and passengers
CREATE TABLE [User] (
    user_id INT PRIMARY KEY,
    nid VARCHAR(50), 
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);


-- Location table 
CREATE TABLE Location (
    location_id INT PRIMARY KEY,
    address VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL
);

-- Vehicle table
CREATE TABLE Vehicle (
    vehicle_id INT PRIMARY KEY ,
    driver_id INT NOT NULL,
    manufacturer VARCHAR(100),
    model VARCHAR(100),
    [year] INT,
    license_plate VARCHAR(40) UNIQUE NOT NULL,
    color VARCHAR(50),
    [type] VARCHAR(50),
    capacity INT NOT NULL,
    FOREIGN KEY (driver_id) REFERENCES [User](user_id)
);


-- Passenger table
CREATE TABLE Passenger (
    passenger_id INT PRIMARY KEY,
    is_verified BIT DEFAULT 0,
    balance DECIMAL(10, 2) DEFAULT 0.00, 
    location_id INT NULL, 
    FOREIGN KEY (passenger_id) REFERENCES [User](user_id),
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

-- Driver table
CREATE TABLE Driver (
    driver_id INT PRIMARY KEY,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    avg_rating DECIMAL(2, 1) DEFAULT 0.0,
    is_verified BIT DEFAULT 0,
    ride_count INT,
    balance DECIMAL(10, 2) DEFAULT 0.00, 
    location_id INT NULL,
    FOREIGN KEY (driver_id) REFERENCES [User](user_id),
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

-- Ride table
CREATE TABLE Ride (
    ride_id INT PRIMARY KEY,
    passenger_id INT NOT NULL,
    driver_id INT NOT NULL,
    pickup_location_id INT NOT NULL,
    dropoff_location_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NULL,
    fare DECIMAL(8, 2) NOT NULL,
    [status] VARCHAR(50) NOT NULL,
    rating DECIMAL(2, 1) DEFAULT 0.0,
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id),
    FOREIGN KEY (pickup_location_id) REFERENCES Location(location_id),
    FOREIGN KEY (dropoff_location_id) REFERENCES Location(location_id)
);

-- Payment table
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    ride_id INT UNIQUE NOT NULL,
    user_id INT NOT NULL,
    amount DECIMAL(8, 2) NOT NULL,
    payment_date DATETIME DEFAULT GETDATE(),
    payment_method VARCHAR(50),
    transaction_id VARCHAR(100) UNIQUE NOT NULL,
    [status] VARCHAR(50) NOT NULL,
    FOREIGN KEY (ride_id) REFERENCES Ride(ride_id),
    FOREIGN KEY (user_id) REFERENCES [User](user_id)
);

-- Review table
CREATE TABLE Review (
    review_id INT PRIMARY KEY ,
    ride_id INT NOT NULL,
    reviewer_passenger_id INT NOT NULL,
    reviewed_driver_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5) NOT NULL,
    [comment] VARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ride_id) REFERENCES Ride(ride_id),
    FOREIGN KEY (reviewer_passenger_id) REFERENCES Passenger(passenger_id),
    FOREIGN KEY (reviewed_driver_id) REFERENCES Driver(driver_id)
);
-- Support Team table
CREATE TABLE Support_Team (
    support_staff_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    [role] VARCHAR(50)
);

-- Report table
CREATE TABLE Report (
    report_id INT PRIMARY KEY,
    reporter_user_id INT NOT NULL,
    reported_user_id INT NULL,
    reporter_role VARCHAR(20) NOT NULL,
    report_type VARCHAR(100) NOT NULL,
    [description] VARCHAR(MAX) NOT NULL,
    reported_at DATETIME DEFAULT GETDATE(),
    [status] VARCHAR(50) NOT NULL,
    FOREIGN KEY (reporter_user_id) REFERENCES [User](user_id),
    FOREIGN KEY (reported_user_id) REFERENCES [User](user_id),

);

-- Customer Support table
CREATE TABLE Customer_Support (
    ticket_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    assigned_staff_id INT NULL,
    inquiry_type VARCHAR(100),
    [message] VARCHAR(MAX) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    priority VARCHAR(20),
    [status] VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES [User](user_id),
    FOREIGN KEY (assigned_staff_id) REFERENCES Support_Team(support_staff_id)
);

-- User Data
INSERT INTO [User] (user_id, nid, first_name, last_name, email, phone_number, password_hash) VALUES
(1, '1995123456', 'Rahim', 'Ahmed', 'rahim.a@email.com', '01711223344', 'e10adc3949'),
(2, '1988765432', 'Fatima', 'Begum', 'fatima.b@email.com', '01822334455', 'f379eaf3c8'),
(3, '2001987654', 'Kamal', 'Hossain', 'kamal.h@email.com', '01933445566', '5170365a68'),
(4, '1990112233', 'Anika', 'Chowdhury', 'anika.c@email.com', '01644556677', '8a5433a388'),
(5, '1985445566', 'Tariq', 'Khan', 'tariq.k@email.com', '01555667788', 'd8578edf84'),
(6, '1992778899', 'Sadia', 'Islam', 'sadia.i@email.com', '01766778899', '1679091c5a'),
(7, '1980101010', 'Jamal', 'Uddin', 'jamal.u@email.com', '01877889900', '25d55ad283'),
(8, '2000202020', 'Nusrat', 'Jahan', 'nusrat.j@email.com', '01988990011', 'e99a18c428'),
(9, '1998303030', 'Iqbal', 'Mahmud', 'iqbal.m@email.com', '01699001122', 'c333677015'),
(10,'1987404040', 'Rifat', 'Sheikh', 'rifat.s@email.com', '01500112233', '900150983c'),
(11,'1993505050', 'Sumaiya', 'Akter', 'sumaiya.a@email.com', '01712345678', '02c75fb22c'),
(12,'1989606060', 'Hasan', 'Mahmud', 'hasan.m@email.com', '01823456789', 'fcea920f74'),
(13,'2002707070', 'Farhana', 'Yasmin', 'farhana.y@email.com', '01934567890', 'a3dcb4d229'),
(14,'1996808080', 'Arif', 'Rahman', 'arif.r@email.com', '01645678901', '7694f4a663'),
(15, '1984909090', 'Nazmul', 'Sarkar', 'nazmul.s@email.com', '01556789012', '1f32aa4c9a'),
(16, '1999121212', 'Sharmin', 'Sultana', 'sharmin.s@email.com', '01767890123', '4e4d6c332b'),
(17, '1986232323', 'Shakib', 'Hasan', 'shakib.h@email.com', '01878901234', 'b59c67bf19'),
(18, '2003343434', 'Ayesha', 'Siddika', 'ayesha.s@email.com', '01989012345', 'c56d0e9a7c'),
(19, '1991454545', 'Mehedi', 'Hasan', 'mehedi.h@email.com', '01690123456', '5f4dcc3b5a'),
(20, '1982565656', 'Tasnim', 'Ferdous', 'tasnim.f@email.com', '01501234567', '3d2172418e');


-- Location data
INSERT INTO Location  VALUES
(101, 'Abdullahpur Bus Stand, Uttara, Dhaka', 23.8794, 90.4005),
(102, 'Jatrabari Chowrasta, Dhaka', 23.7099, 90.4333),
(103, 'Uttara Sector 6 Park, Dhaka', 23.8647, 90.3989),
(104, 'Hazrat Shahjalal International Airport, Dhaka', 23.8433, 90.4043),
(105, 'Jamuna Future Park, Bashundhara, Dhaka', 23.8133, 90.4243),
(106, 'Banani Road 11, Dhaka', 23.7942, 90.4069),
(107, 'Gulshan 2 Circle, Dhaka', 23.7925, 90.4183),
(108, 'Mohakhali Bus Terminal, Dhaka', 23.7820, 90.4048),
(109, 'Farmgate, Tejgaon, Dhaka', 23.7595, 90.3892),
(110, 'Dhanmondi 32 Bridge, Dhaka', 23.7533, 90.3813),
(111, 'Mohammadpur Town Hall, Dhaka', 23.7644, 90.3667),
(112, 'New Market, Dhaka', 23.7346, 90.3876),
(113, 'Shahbag Intersection, Dhaka', 23.7410, 90.3958),
(114, 'Motijheel Shapla Chattar, Dhaka', 23.7259, 90.4172),
(115, 'Sadarghat Launch Terminal, Dhaka', 23.7067, 90.4099);


-- Passenger Data 
INSERT INTO Passenger  VALUES
(1, 1, 450.50, 101),
(3, 1, 1200.00, 103),
(5, 0, 125.75, 105),
(7, 1, 880.90, 107),
(9, 0, 50.00, 109),
(11, 1, 200.00, 111),
(13, 0, 150.50, 113),
(15, 1, 999.99, 115),
(16, 1, 300.00, 101),
(19, 1, 110.00, 105);

-- Driver Data 
INSERT INTO Driver 
VALUES
(2, 'BD-012345678', 4.8, 1, 110, 5500.25, 102),
(4, 'BD-023456789', 4.5, 1, 90, 3200.50, 104),
(6, 'BD-034567890', 4.2, 1, 50, 1500.00, 106),
(8, 'BD-045678901', 4.9, 1, 200, 8750.80, 108),
(10, 'BD-056789012', 4.1, 1, 30, 950.00, 110),
(12, 'BD-067890123', 4.7, 1, 150, 6000.00, 112),
(14, 'BD-078901234', 4.3, 1, 75, 2550.00, 114),
(17, 'BD-089012345', 4.6, 1, 120, 4300.00, 102),
(18, 'BD-090123456', 4.4, 1, 100, 3850.00, 103),
(20, 'BD-101234567', 4.0, 1, 65, 2100.00, 106);


-- Vehicle Data 
INSERT INTO Vehicle VALUES
(1, 2, 'Toyota', 'Premio', 2018, 'Dhaka Metro-Ga 35-1121', 'Silver', 'Sedan', 4),
(2, 4, 'Toyota', 'Aqua', 2019, 'Dhaka Metro-Kha 22-3456', 'White', 'Hybrid', 4),
(3, 6, 'Honda', 'Vezel', 2020, 'Dhaka Metro-Gha 41-7890', 'Black', 'SUV', 5),
(4, 8, 'Toyota', 'Allion', 2017, 'Ctg Metro-Ka 19-2345', 'Red', 'Sedan', 4),
(5, 10, 'Toyota', 'HiAce', 2019, 'Dhaka Metro-Cha 53-6789', 'White', 'Microbus', 11),
(6, 12, 'Mitsubishi', 'Outlander', 2021, 'Dhaka Metro-Gha 45-1011', 'Grey', 'SUV', 6),
(7, 14, 'Toyota', 'Axio', 2020, 'Dhaka Metro-Ga 39-2122', 'Black', 'Sedan', 4),
(8, 17, 'Suzuki', 'Swift', 2022, 'Dhaka Metro-Ka 28-3233', 'Blue', 'Hatchback', 4),
(9, 18, 'Nissan', 'X-Trail', 2018, 'Dhaka Metro-Gha 33-4344', 'Pearl White', 'SUV', 5),
(10, 20, 'Honda', 'Grace', 2019, 'Dhaka Metro-Kha 25-5455', 'Silver', 'Hybrid', 4);

-- Support Team data
INSERT INTO Support_Team  VALUES
('Karim', 'Hossain', 'k.hossain@support.com', 'Tier 1 Agent'),
('Tasnia', 'Begum', 't.begum@support.com', 'Tier 2 Specialist'),
('Imran', 'Khan', 'i.khan@support.com', 'Manager'),
('Sadia', 'Akter', 's.akter@support.com', 'Tier 1 Agent'),
('Jamil', 'Ahmed', 'j.ahmed@support.com', 'Tier 1 Agent'),
('Afsana', 'Chowdhury', 'a.chowdhury@support.com', 'Tier 2 Specialist'),
('Rohan', 'Islam', 'r.islam@support.com', 'Tier 1 Agent'),
('Maria', 'Rahman', 'm.rahman@support.com', 'Tier 1 Agent'),
('Faisal', 'Haque', 'f.haque@support.com', 'Tier 2 Specialist'),
('Farhana', 'Sultana', 'f.sultana@support.com', 'Manager');



--  View all data in all tables
SELECT * FROM [User];

SELECT * FROM Location;

SELECT * FROM Vehicle;

SELECT * FROM Passenger;

SELECT * FROM Driver;

SELECT * FROM Ride;

SELECT * FROM Payment;

SELECT * FROM Review;

SELECT * FROM Support_Team;

SELECT * FROM Report;

SELECT * FROM Customer_Support;



-- Ride Book Query
BEGIN TRAN;

BEGIN TRY

    -- Paasenger info and Preference 
    DECLARE @PassengerIDToFind INT = 15; 
    DECLARE @DestinationLocationID INT = 111;               
    DECLARE @VehicleTypePreference VARCHAR(50) = 'Microbus';               
    DECLARE @PassengerID INT;
    DECLARE @PassengerLocationID INT;
    DECLARE @PassengerLat DECIMAL(10, 8);
    DECLARE @PassengerLon DECIMAL(11, 8);
    DECLARE @PassengerBalance DECIMAL(10, 2);

    -- Destination Info & Fare
    DECLARE @DestinationLat DECIMAL(10, 8);
    DECLARE @DestinationLon DECIMAL(11, 8);
    DECLARE @NearestDriverID INT;
    DECLARE @RatePerKm DECIMAL(4, 2);
    DECLARE @CalculatedFare DECIMAL(8, 2);
    DECLARE @CalculatedDistanceKM DECIMAL(10, 2);
    
    --New Ride Info
    DECLARE @NewRideID INT;
    DECLARE @NewReviewID INT;
    DECLARE @NewPaymentID INT; 
    DECLARE @NewRatingGiven DECIMAL(2, 1) = 4.0;        


    -- Find the passenger's details using their ID
    SELECT
        @PassengerID = P.passenger_id,
        @PassengerLocationID = P.location_id,
        @PassengerLat = L.latitude,
        @PassengerLon = L.longitude,
        @PassengerBalance = P.balance
    FROM
        Passenger AS P
    JOIN
        [User] AS U ON P.passenger_id = U.user_id
    JOIN
        Location AS L ON P.location_id = L.location_id
    WHERE
        U.user_id = @PassengerIDToFind;

    -- Find the destination's coordinates
    SELECT
        @DestinationLat = latitude,
        @DestinationLon = longitude
    FROM
        Location
    WHERE
        location_id = @DestinationLocationID;


     --- Finding Nearest Driver
    SELECT TOP 1
        @NearestDriverID = D.driver_id
    FROM
        Driver AS D
    JOIN
        Location AS L ON D.location_id = L.location_id
    JOIN
        Vehicle AS V ON D.driver_id = V.driver_id
    CROSS APPLY (
        -- Calculating the distance in KM using the Haversine formula
        SELECT
            (6371 * 2 * ATN2(
                SQRT(
                    SIN(RADIANS(L.latitude - @PassengerLat) / 2) * SIN(RADIANS(L.latitude - @PassengerLat) / 2) +
                    COS(RADIANS(@PassengerLat)) * COS(RADIANS(L.latitude)) *
                    SIN(RADIANS(L.longitude - @PassengerLon) / 2) * SIN(RADIANS(L.longitude - @PassengerLon) / 2)
                ),
                SQRT(1 - (
                    SIN(RADIANS(L.latitude - @PassengerLat) / 2) * SIN(RADIANS(L.latitude - @PassengerLat) / 2) +
                    COS(RADIANS(@PassengerLat)) * COS(RADIANS(L.latitude)) *
                    SIN(RADIANS(L.longitude - @PassengerLon) / 2) * SIN(RADIANS(L.longitude - @PassengerLon) / 2)
                ))
            )) AS Kilometers
    ) AS Dist
    WHERE
        D.is_verified = 1                      
        AND V.[type] = @VehicleTypePreference  
    ORDER BY
        Dist.Kilometers ASC;

    IF @NearestDriverID IS NULL
    BEGIN
        RAISERROR('No available drivers found.', 16, 1);
        ROLLBACK TRAN;
        RETURN;
    END;

    
    -- Calculating fare
    SET @CalculatedDistanceKM = (
        6371 * 2 * ATN2(
            SQRT(
                SIN(RADIANS(@DestinationLat - @PassengerLat) / 2) * SIN(RADIANS(@DestinationLat - @PassengerLat) / 2) +
                COS(RADIANS(@PassengerLat)) * COS(RADIANS(@DestinationLat)) *
                SIN(RADIANS(@DestinationLon - @PassengerLon) / 2) * SIN(RADIANS(@DestinationLon - @PassengerLon) / 2)
            ),
            SQRT(1 - (
                SIN(RADIANS(@DestinationLat - @PassengerLat) / 2) * SIN(RADIANS(@DestinationLat - @PassengerLat) / 2) +
                COS(RADIANS(@PassengerLat)) * COS(RADIANS(@DestinationLat)) *
                SIN(RADIANS(@DestinationLon - @PassengerLon) / 2) * SIN(RADIANS(@DestinationLon - @PassengerLon) / 2)
            ))
        )
    );


    -- fare by Vehicle catagory
    SET @RatePerKm = CASE @VehicleTypePreference
                        WHEN 'Sedan' THEN 25.00
                        WHEN 'SUV' THEN 35.00
                        WHEN 'Hybrid' THEN 22.00
                        WHEN 'Microbus' THEN 40.00
                        ELSE 20.00 -- Default
                     END;

    SET @CalculatedFare = @CalculatedDistanceKM * @RatePerKm;

    -- Check if passenger has enough balance
    IF @PassengerBalance < @CalculatedFare
    BEGIN
        RAISERROR('Insufficient balance for this ride.', 16, 1);
        ROLLBACK TRAN;
        RETURN;
    END;


    --  Creating new Ride record
    SELECT @NewRideID = ISNULL(MAX(ride_id), 0) + 1 FROM Ride;

    INSERT INTO Ride 
    VALUES (
        @NewRideID,
        @PassengerID,
        @NearestDriverID,
        @PassengerLocationID,
        @DestinationLocationID,
        DATEADD(minute, -15, GETDATE()),
        GETDATE(),                       
        @CalculatedFare,
        'completed',
        @NewRatingGiven
    );

    -- Updating Passenger balance
    UPDATE Passenger
    SET balance = balance - @CalculatedFare
    WHERE passenger_id = @PassengerID;

    -- Updating Driver balance, ride_count and avg_rating
    UPDATE Driver
    SET
        balance = balance + @CalculatedFare,
        avg_rating = CASE 
                        WHEN ride_count = 0 THEN @NewRatingGiven
                        ELSE ( (avg_rating * ride_count) + @NewRatingGiven ) / (ride_count + 1)
                     END,
        ride_count = ride_count + 1
    WHERE
        driver_id = @NearestDriverID;

    -- Add to Review table
    SELECT @NewReviewID = ISNULL(MAX(review_id), 0) + 1 FROM Review;

    
    INSERT INTO Review (
        review_id,
        ride_id,
        reviewer_passenger_id,
        reviewed_driver_id,
        rating,
        [comment]
    )
    VALUES (
        @NewReviewID,
        @NewRideID,
        @PassengerID,
        @NearestDriverID,
        @NewRatingGiven,
        'The driver was very professional. A truly amazing and safe ride.'
    );

    SELECT @NewPaymentID = ISNULL(MAX(payment_id), 0) + 1 FROM Payment;
    -- Inserting Payment
    INSERT INTO Payment
    VALUES (
        @NewPaymentID,
        @NewRideID,
        @PassengerID,      
        @CalculatedFare,
        GETDATE(),        
        CASE 
            WHEN @NewRideID % 3 = 0 THEN 'Cash'
            WHEN @NewRideID % 3 = 1 THEN 'Credit Card'
            ELSE 'Digital Wallet'
        END,
        CONCAT('TXN', RIGHT('0000' + CAST(@NewRideID AS VARCHAR(10)), 4)),
        'Success'
    );

    COMMIT TRAN;

    SELECT 
        'Ride Booked, Completed & Paid Successfully!' AS Result,
        @NewRideID AS NewRideID,
        @NewPaymentID AS NewPaymentID,
        U_Pass.first_name AS PassengerName,
        U_Drive.first_name AS DriverName,
        @CalculatedFare AS Fare,
        @CalculATEDDistanceKM AS DistanceKM
    FROM
        [User] AS U_Pass
    JOIN
        [User] AS U_Drive ON U_Drive.user_id = @NearestDriverID
    WHERE
        U_Pass.user_id = @PassengerID;


END TRY
BEGIN CATCH
    ROLLBACK TRAN;
    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_LINE() AS ErrorLine;
END CATCH
GO


---------------- Report -----------------

DECLARE @NewReportID INT = (SELECT ISNULL(MAX(report_id), 0) + 1 FROM Report);

DECLARE @UserWhoIsReporting INT = 15; 
DECLARE @UserBeingReported INT = 10; 
INSERT INTO Report (
    report_id,
    reporter_user_id,
    reported_user_id,
    reporter_role,
    report_type,
    [description],
    [status]
    )
VALUES (
    @NewReportID,
    @UserWhoIsReporting,
    @UserBeingReported,
    'Passenger',
    'Driver Behavior',
    'Driver was speeding and playing music too loudly.',
    'Open' 
);

SELECT * FROM Report WHERE report_id = @NewReportID;

---------------Customer Support------------
BEGIN TRAN;
BEGIN TRY

  
    DECLARE @SubmittingUserID INT = 3;
    DECLARE @InquiryType VARCHAR(100) = 'Account Help';
    DECLARE @MessageText VARCHAR(MAX) = 'I forgot my password and cannot reset it.';
    DECLARE @Priority VARCHAR(20) = 'High';

    -- Find the next available ticket_id
    DECLARE @NewTicketID INT;
    SET @NewTicketID = (SELECT ISNULL(MAX(ticket_id), 0) + 1 FROM Customer_Support);

    -- Insert the new ticket record
    INSERT INTO Customer_Support 
    (
    ticket_id,
        user_id,
        assigned_staff_id, 
        inquiry_type,
        [message],
        [priority],
        [status]   
        )
    VALUES (
        @NewTicketID,
        @SubmittingUserID,
        NULL,
        @InquiryType,
        @MessageText,
        @Priority,
        'Pending Staff Review'
    );

  
  -- Assigned Staff to Handle Ticket
    DECLARE @AssignToStaffID INT = 2;

    UPDATE Customer_Support
    SET
        assigned_staff_id = @AssignToStaffID, 
        [status] = 'In Progress' 
    WHERE
        ticket_id = @NewTicketID;

    SELECT
        'My Open Ticket' AS ViewTitle,
        CS.ticket_id,
        CS.inquiry_type,
        CS.[status],
        CS.created_at,
        CS.[message],
        ISNULL(ST.first_name + ' ' + ST.last_name, 'Not Assigned Yet') AS AssignedStaff
    FROM
        Customer_Support AS CS
    LEFT JOIN
        Support_Team AS ST ON CS.assigned_staff_id = ST.support_staff_id
    WHERE
        CS.ticket_id = @NewTicketID;

    UPDATE Customer_Support
    SET
        [status] = 'Resolved'
    WHERE
        ticket_id = @NewTicketID;


    COMMIT TRAN;

END TRY
BEGIN CATCH
    ROLLBACK TRAN;

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_LINE() AS ErrorLine;
END CATCH
GO
---------Ride history for passenger(id = 15)---------
SELECT * FROM Ride
WHERE passenger_id = 15

--------Checking balance from passenger-----------
SELECT 
    P.passenger_id AS Passenger_ID, 
    concat(U.first_name ,' ', U.last_name) AS Passenger_Name, 
    P.balance AS My_Balance
FROM Passenger AS P
JOIN [User] AS U 
    ON P.passenger_id = U.user_id
WHERE P.passenger_id = 15

----------Checking balance from driver------------
SELECT 
    D.driver_id AS Driver_ID, 
    CONCAT(U.first_name, ' ', U.last_name) AS Driver_Name, 
    D.balance AS My_Balance
FROM 
    Driver AS D
JOIN 
    [User] AS U ON D.driver_id = U.user_id
WHERE 
    D.driver_id = 10;

------------Checking Ride History-----------
SELECT 
    R.ride_id,R.passenger_id,  -- This selects all columns from the Ride table
    CONCAT(U_Pass.first_name, ' ', U_Pass.last_name) AS Passenger_Name,
    R.driver_id,
    CONCAT(U_Drive.first_name, ' ', U_Drive.last_name) AS DriverName,
    R.pickup_location_id,R.dropoff_location_id,R.start_time,R.end_time,R.fare,R.status,R.rating

FROM 
    Ride AS R
JOIN 
    [User] AS U_Pass ON R.passenger_id = U_Pass.user_id  -- Join to get Passenger name
JOIN 
    [User] AS U_Drive ON R.driver_id = U_Drive.user_id   -- Join to get Driver name
WHERE 
    R.driver_id = 10;

----Checking ticket history----
SELECT * FROM Customer_Support
WHERE user_id = 3




