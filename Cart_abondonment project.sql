-- Create database and use it
CREATE DATABASE ecommerce_project;
USE ecommerce_project;

-- Create main table
CREATE TABLE ecommerce_cart_abandonment (
    UserID INT,
    SessionID BIGINT,
    BrowserType VARCHAR(50),
    OperatingSystem VARCHAR(50),
    DeviceType VARCHAR(50),
    NumItemsInCart INT,
    CartTotalAmount DECIMAL(10,2),
    TimeSpentOnSiteMinutes DOUBLE,
    HasCouponApplied BOOLEAN,
    IsReturningUser BOOLEAN,
    LastPageViewedCategory VARCHAR(100),
    AbandonmentReason VARCHAR(255),
    PRIMARY KEY (SessionID)
);

-- Sample preview
SELECT * FROM ecommerce_cart_abandonment LIMIT 10;

-- CTE: Get all abandoned sessions
WITH Abandoned AS (
    SELECT * 
    FROM ecommerce_cart_abandonment
    WHERE AbandonmentReason IS NOT NULL
)
SELECT
  AbandonmentReason,
  COUNT(*) AS occurrences
FROM Abandoned
GROUP BY AbandonmentReason
ORDER BY occurrences DESC;

-- 2. Top Categories Where Abandonment Happens
WITH Abandoned AS (
    SELECT * FROM ecommerce_cart_abandonment
    WHERE AbandonmentReason IS NOT NULL
)
SELECT
  LastPageViewedCategory AS category,
  COUNT(*) AS abandon_count
FROM Abandoned
GROUP BY LastPageViewedCategory
ORDER BY abandon_count DESC
LIMIT 5;

-- 3. Device types most commonly seen in cart abandonment

SELECT 
  DeviceType,
  COUNT(*) AS abandon_sessions
FROM 
  ecommerce_cart_abandonment
GROUP BY 
  DeviceType
ORDER BY 
  abandon_sessions DESC;


-- 4. Most Common Browser-OS Combinations in Abandonment
SELECT
  OperatingSystem,
  BrowserType,
  COUNT(*) AS abandon_sessions
FROM
  ecommerce_cart_abandonment
GROUP BY
  OperatingSystem, BrowserType
ORDER BY
  abandon_sessions DESC;


 -- 5.Abandonment frequency based on coupon usage

SELECT 
  HasCouponApplied,
  COUNT(*) AS abandon_sessions
FROM 
  ecommerce_cart_abandonment
GROUP BY 
  HasCouponApplied
ORDER BY 
  abandon_sessions DESC;

-- 6. Users Who Abandoned More Than 3 Times
WITH Abandoned AS (
    SELECT * FROM ecommerce_cart_abandonment
    WHERE AbandonmentReason IS NOT NULL
)
SELECT 
  UserID,
  COUNT(*) AS abandon_sessions
FROM Abandoned
GROUP BY UserID
HAVING abandon_sessions > 3
ORDER BY abandon_sessions DESC;

-- 7. Average Cart Value and Time Spent Per Abandoning User
WITH Abandoned AS (
    SELECT * FROM ecommerce_cart_abandonment
    WHERE AbandonmentReason IS NOT NULL
)
SELECT
  UserID,
  COUNT(*) AS abandoned_sessions,
  AVG(CartTotalAmount) AS avg_cart_value,
  AVG(TimeSpentOnSiteMinutes) AS avg_time_spent
FROM Abandoned
GROUP BY UserID
ORDER BY abandoned_sessions DESC
LIMIT 20;

-- 8. Browser Usage per User Among Abandoners
WITH Abandoned AS (
    SELECT * FROM ecommerce_cart_abandonment
    WHERE AbandonmentReason IS NOT NULL
)
SELECT
  UserID,
  BrowserType,
  COUNT(*) AS abandoned_sessions
FROM Abandoned
GROUP BY UserID, BrowserType
ORDER BY UserID, abandoned_sessions DESC;
