-- 220329405 / Chawda / Gira / A
-- 220486114 / Dhawan / Komal / A
-- 219941855 / Carter / Toby / A

-- Which Week Generated The Most Revenue
SELECT
    MIN(check_in) AS week_start,
    MAX(check_out) AS week_end,
    SUM(DATEDIFF(check_out, check_in) * rt.nightly_price *
        (CASE WHEN b.discount_applied THEN 0.9 ELSE 1 END)) AS total_revenue
FROM Bookings b
JOIN Rooms r ON b.room_id = r.room_id
JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id
WHERE b.is_cancelled = FALSE
GROUP BY YEAR(check_in), WEEK(check_in)
ORDER BY total_revenue DESC
LIMIT 1;

-- Vacant Duplex Rooms That Are Available For A Specific Date
SELECT r.room_number, '2025-03-02' AS selected_check_in, '2025-03-03' AS selected_check_out
FROM Rooms r
JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id
LEFT JOIN Bookings b
       ON r.room_id = b.room_id
      AND b.is_cancelled = FALSE
      AND '2025-03-02' BETWEEN b.check_in AND b.check_out
WHERE rt.type_name = 'Duplex'
  AND b.room_id IS NULL;

-- Total Savings From Discount Over The Years
SELECT
    YEAR(b.check_in) AS year,
    SUM(DATEDIFF(b.check_out, b.check_in) * rt.nightly_price * 0.1) AS total_savings
FROM Bookings b
JOIN Guests g ON b.guest_id = g.guest_id
JOIN Rooms r ON b.room_id = r.room_id
JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id
WHERE g.is_staff = TRUE AND b.discount_applied = TRUE
GROUP BY YEAR(b.check_in)
ORDER BY year;

-- Daily Check In Schedule For Guests
SELECT
    g.name AS guest_name,
    'check_in' AS event_type,
    b.check_in AS event_date
FROM Bookings b
JOIN Guests g ON b.guest_id = g.guest_id
WHERE b.is_cancelled = FALSE
  AND DATE(b.check_in) = '2024-12-25'

UNION ALL

SELECT
    g.name AS guest_name,
    'check_out' AS event_type,
    b.check_out AS event_date
FROM Bookings b
JOIN Guests g ON b.guest_id = g.guest_id
WHERE b.is_cancelled = FALSE
  AND DATE(b.check_out) = '2024-12-25'
  
UNION ALL

SELECT
    g.name AS guest_name,
    'cancellation' AS event_type,
    b.check_in AS event_date
FROM Bookings b
JOIN Guests g ON b.guest_id = g.guest_id
WHERE b.is_cancelled = TRUE
  AND DATE(b.check_in) = '2024-12-25'

ORDER BY event_date, guest_name;

-- Frequent Cancellation Guest (More than 2 Cancellations) and How Many Cancellations They've Had
SELECT
    g.name AS guest_name,
    COUNT(*) AS total_cancellations
FROM Bookings b
JOIN Guests g ON b.guest_id = g.guest_id
WHERE b.is_cancelled = TRUE
GROUP BY g.guest_id
HAVING COUNT(*) > 2
ORDER BY total_cancellations DESC;

-- Rooms that weren't booked after the holiday season
SELECT
    r.room_number, max(b.booking_datetime)
FROM Rooms r
JOIN Bookings b ON r.room_id = b.room_id
WHERE r.room_id NOT IN (
    SELECT DISTINCT room_id
    FROM Bookings
    WHERE booking_datetime BETWEEN '2024-12-26' AND DATE_ADD('2024-12-26', INTERVAL 30 DAY)
) AND booking_datetime < '2025-01-25'
GROUP BY r.room_number;