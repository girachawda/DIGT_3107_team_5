-- 220329405 / Chawda / Gira / A
-- 220486114 / Dhawan / Komal / A
-- 219941855 / Carter / Toby / A

### Hotel Booking System
This system allows for the management of hotel bookings, payment methods, rooms, and guest information.

### Setup
1. Clone this repository locally
2. Navigate into SQLWorkbench on you LocalHost
3. Run phase4/create_table.sql to create table schemas
4. [OPTIONAL] - Run phase4/create_date.sql to populate
5. [OPTIONAL] - Run phase3/complex_queries.sql to run some test queries
6. Navigate to your favourite IDE, and open phase4/src/HotelBookingSystem.java
7. Run this file, and your terminal will open with a text based interface

### Troubleshooting
If you get any errors regarding user authentication when running the java file, alter the following lines to include your localhost username and password:
`private static final String DB_USER = "root";`
`private static final String DB_PASSWORD = "";`

### Application Interface
Once on the interface, you will see 8 options:
1. View All Rooms
2. Check Room Availability
3. Add New Booking
4. View All Bookings
5. Update Booking Discount
6. Cancel Booking
7. View Weekly Revenue Report
8. Exit

You may navigate through these options to perform the various actions we support.