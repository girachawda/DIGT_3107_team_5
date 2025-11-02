DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Rooms;
DROP TABLE IF EXISTS Guests;
DROP TABLE IF EXISTS RoomTypes;
DROP TABLE IF EXISTS PaymentMethods;

Create Table Guests (
    guest_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_info VARCHAR(254) NOT NULL,
    is_staff BOOLEAN NOT NULL DEFAULT FALSE
);

Create Table PaymentMethods (
    payment_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_type VARCHAR(11) NOT NULL
);

Create Table RoomTypes (
    room_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(12) NOT NULL,
    capacity INT NOT NULL,
    nightly_price DECIMAL(5,2) NOT NULL
);

Create Table Rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(3) NOT NULL UNIQUE,
    room_type_id INT NOT NULL,
    FOREIGN KEY (room_type_id) REFERENCES RoomTypes (room_type_id)
);

Create Table Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    payment_method_id INT NOT NULL,
    booking_datetime DATETIME NOT NULL,
    check_in DATETIME NOT NULL,
    check_out DATETIME NOT NULL,
    is_cancelled BOOLEAN NOT NULL DEFAULT FALSE,
    discount_applied BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (guest_id) REFERENCES Guests (guest_id),
    FOREIGN KEY (room_id) REFERENCES Rooms (room_id),
    FOREIGN KEY (payment_method_id) REFERENCES PaymentMethods (payment_method_id)
);