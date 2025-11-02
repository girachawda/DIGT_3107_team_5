-- 220329405 / Chawda / Gira / A
-- 220486114 / Dhawan / Komal / A
-- 219941855 / Carter / Toby / A


INSERT INTO Guests (name, contact_info, is_staff) VALUES
('Santa Claus', 'santa.claus@northpole.com', FALSE),
('Mrs. Claus', 'mrs.claus@northpole.com', TRUE),
('Rudolph Reindeer', 'rudolph@northpole.com', FALSE),
('Frosty Snowman', 'frosty@snowmail.com', FALSE),
('Buddy Elf', 'buddy@elfmail.com', TRUE),
('The Grinch', 'grinch@who-ville.com', TRUE),
('Cindy Lou Who', 'cindy@whoville.com', FALSE),
('Hermey Elf', 'hermey@toyfactory.com', TRUE),
('Jack Frost', 'jack@wintermail.com', FALSE),
('Pepper Minstix', 'pepper@northpole.com', TRUE),
('Snowflake McTwinkle', 'snowflake@northpole.com', TRUE),
('Jingle Bells', 'jingle@northpole.com', FALSE),
('Clarice Reindeer', 'clarice@northpole.com', FALSE),
('Yukon Cornelius', 'yukon@expeditions.com', FALSE),
('Elf on the Shelf', 'elf.shelf@northpole.com', TRUE);

INSERT INTO PaymentMethods (method_type) VALUES
('Credit Card'),
('Debit Card'),
('Cash');

INSERT INTO RoomTypes (type_name, capacity, nightly_price) VALUES
('Single', 1, 100.00),
('Duplex', 2, 250.00),
('Presidential', 4, 500.00);

INSERT INTO Rooms (room_number, room_type_id) VALUES
('101', 1),
('102', 1),
('103', 1),
('104', 1),
('105', 1),
('201', 2),
('202', 2),
('203', 2),
('204', 2),
('301', 3),
('302', 3);

INSERT INTO Bookings (guest_id, room_id, payment_method_id, booking_datetime, check_in, check_out, is_cancelled, discount_applied) VALUES
-- 1. Highest revenue week
(1, 10, 1, '2024-12-01 09:30:00', '2024-12-22 15:00:00', '2024-12-27 11:00:00', FALSE, FALSE),
(2, 11, 2, '2024-12-02 10:15:00', '2024-12-23 14:00:00', '2024-12-28 10:00:00', FALSE, TRUE),
(3, 6, 3, '2024-12-03 11:00:00', '2024-12-24 13:00:00', '2024-12-26 12:00:00', FALSE, FALSE),
(4, 7, 1, '2024-12-04 12:20:00', '2024-12-25 16:00:00', '2024-12-27 11:00:00', FALSE, FALSE),
(5, 8, 2, '2024-12-05 08:50:00', '2024-12-23 14:00:00', '2024-12-26 10:00:00', FALSE, TRUE),
(6, 9, 3, '2024-12-06 09:40:00', '2024-12-24 15:00:00', '2024-12-27 10:00:00', TRUE, TRUE),

-- 2. Double room availability check
(7, 6, 1, '2025-01-02 08:00:00', '2025-01-10 14:00:00', '2025-01-12 10:00:00', FALSE, FALSE),
(8, 7, 2, '2025-01-05 09:00:00', '2025-01-15 15:00:00', '2025-01-18 11:00:00', FALSE, TRUE),
(9, 8, 3, '2025-02-01 10:00:00', '2025-02-10 14:00:00', '2025-02-13 10:00:00', FALSE, FALSE),
(10, 9, 1, '2025-02-15 11:00:00', '2025-02-20 13:00:00', '2025-02-23 11:00:00', TRUE, TRUE),

-- 3. Staff discount year-over-year
(2, 1, 1, '2024-02-10 08:00:00', '2024-03-01 14:00:00', '2024-03-04 10:00:00', FALSE, TRUE),
(5, 2, 2, '2024-05-12 10:00:00', '2024-05-20 14:00:00', '2024-05-22 10:00:00', FALSE, TRUE),
(8, 3, 1, '2025-04-10 09:30:00', '2025-04-15 13:00:00', '2025-04-17 11:00:00', FALSE, TRUE),
(10, 4, 2, '2025-06-01 11:30:00', '2025-06-10 15:00:00', '2025-06-12 10:00:00', FALSE, TRUE),
(11, 5, 3, '2025-08-15 10:00:00', '2025-08-20 14:00:00', '2025-08-23 11:00:00', FALSE, TRUE),

-- 4. Daily check-in + check-out + cancellations
(7, 1, 1, '2024-12-20 09:00:00', '2024-12-22 14:00:00', '2024-12-26 11:00:00', FALSE, FALSE),
(8, 2, 2, '2024-12-21 10:30:00', '2024-12-23 15:00:00', '2024-12-27 12:00:00', FALSE, TRUE),
(9, 3, 3, '2024-12-21 11:15:00', '2024-12-24 14:00:00', '2024-12-28 11:00:00', TRUE, FALSE),
(10, 4, 1, '2024-12-22 08:45:00', '2024-12-24 16:00:00', '2024-12-25 10:00:00', FALSE, FALSE),
(1, 5, 2, '2024-12-22 09:30:00', '2024-12-25 14:00:00', '2024-12-29 11:00:00', FALSE, TRUE),
(2, 6, 3, '2024-12-23 12:00:00', '2024-12-25 15:00:00', '2024-12-28 10:00:00', TRUE, FALSE),
(3, 7, 1, '2024-12-23 13:15:00', '2024-12-26 13:00:00', '2024-12-30 12:00:00', FALSE, FALSE),
(4, 8, 2, '2024-12-24 14:30:00', '2024-12-25 14:00:00', '2024-12-31 10:00:00', TRUE, TRUE),
(5, 9, 3, '2024-12-24 15:45:00', '2024-12-27 12:00:00', '2024-12-31 11:00:00', FALSE, FALSE),
(12, 10, 1, '2025-02-20 15:00:00', '2025-03-01 14:00:00', '2025-03-05 12:00:00', FALSE, FALSE),
(13, 11, 2, '2025-02-21 09:00:00', '2025-03-02 14:00:00', '2025-03-06 11:00:00', FALSE, FALSE),
(14, 1, 3, '2025-02-22 08:00:00', '2025-03-03 13:00:00', '2025-03-05 10:00:00', TRUE, FALSE),
(15, 2, 1, '2025-02-23 12:00:00', '2025-03-04 15:00:00', '2025-03-07 10:00:00', FALSE, FALSE),
(1, 3, 2, '2025-02-25 14:00:00', '2025-03-06 14:00:00', '2025-03-08 10:00:00', FALSE, FALSE),

-- 5. Frequent cancellation customer
(6, 1, 2, '2025-04-10 13:00:00', '2025-05-01 14:00:00', '2025-05-04 10:00:00', TRUE, TRUE),
(6, 2, 1, '2025-06-15 11:00:00', '2025-06-25 15:00:00', '2025-06-28 10:00:00', TRUE, TRUE),
(6, 3, 3, '2025-08-01 10:00:00', '2025-08-10 14:00:00', '2025-08-13 11:00:00', TRUE, TRUE),

-- 6. Rooms not booked in last month
(7, 9, 1, '2025-02-01 10:00:00', '2025-02-05 14:00:00', '2025-02-07 10:00:00', FALSE, FALSE),
(8, 11, 3, '2025-03-01 09:00:00', '2025-03-05 14:00:00', '2025-03-08 10:00:00', FALSE, FALSE);