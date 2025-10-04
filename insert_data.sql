INSERT INTO Guests (name, contact_info, is_staff) VALUES
('Rachel Green', 'rachel.green@gmail.com', FALSE),
('Monica Geller', 'monica.geller@hotmail.com', TRUE),
('Phoebe Buffay', '212-555-0123', FALSE),
('Joey Tribbiani', 'joey.tribbiani@yahoo.com', FALSE),
('Chandler Bing', '212-555-0198', TRUE),
('Ross Geller', 'ross.geller@outlook.com', TRUE),
('Janice Hosenstein', '212-555-0156', FALSE),
('Gunther', 'gunther.centralperk@gmail.com', TRUE),
('Mike Hannigan', '212-555-0187', FALSE),
('Emily Waltham', 'emily.waltham@hotmail.com', FALSE);

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
('301', 3);

INSERT INTO Bookings (guest_id, room_id, payment_method_id, booking_datetime, check_in, check_out, is_cancelled, discount_applied) VALUES
(1, 1, 1, '2025-01-10 09:30:00', '2025-02-14 15:00:00', '2025-02-16 11:00:00', FALSE, FALSE),
(2, 6, 2, '2025-01-25 14:15:00', '2025-03-01 14:00:00', '2025-03-05 10:00:00', FALSE, TRUE),
(3, 7, 3, '2025-02-05 11:20:00', '2025-04-10 16:00:00', '2025-04-13 11:00:00', FALSE, FALSE),
(4, 10, 1, '2025-02-20 16:45:00', '2025-05-15 15:00:00', '2025-05-20 12:00:00', FALSE, FALSE),
(5, 2, 1, '2025-03-12 10:30:00', '2025-06-05 14:00:00', '2025-06-08 10:00:00', TRUE, TRUE),
(6, 8, 2, '2025-03-28 13:50:00', '2025-07-10 15:00:00', '2025-07-14 11:00:00', FALSE, TRUE);