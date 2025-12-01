
import java.sql.*;
import java.util.Scanner;

public class HotelBookingSystem {

    // Jump-back exception
    private static class QuitToMenuException extends RuntimeException {
    }

    // Database Configuration
    private static final String DB_URL
            = "jdbc:mysql://localhost:3306/hotel_booking?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    private Connection conn;
    private Scanner scanner;

    public HotelBookingSystem() {
        this.scanner = new Scanner(System.in);
    }

    public static void main(String[] args) {
        HotelBookingSystem app = new HotelBookingSystem();
        app.run();
    }

    public void run() {
        if (!connectToDatabase()) {
            return;
        }

        try {
            showMainMenu();
        } finally {
            closeResources();
        }
    }

    private boolean connectToDatabase() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("✓ Connected to database successfully!\n");
            return true;
        } catch (ClassNotFoundException e) {
            System.err.println("✗ MySQL JDBC Driver not found!");
            e.printStackTrace();
            return false;
        } catch (SQLException e) {
            System.err.println("✗ Database connection failed!");
            e.printStackTrace();
            return false;
        }
    }

    private void closeResources() {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
                System.out.println("\n✓ Database connection closed.");
            }
            if (scanner != null) {
                scanner.close();
            }
        } catch (SQLException e) {
            System.err.println("Error closing connection: " + e.getMessage());
        }
    }

    // Main Menu
    private void showMainMenu() {
        boolean running = true;

        while (running) {
            printMenu();

            try {
                int choice = getIntInput("Enter choice: ");
                System.out.println();

                switch (choice) {
                    case 1:
                        viewAllRooms();
                        break;
                    case 2:
                        viewAvailableRooms();
                        break;
                    case 3:
                        addBooking();
                        break;
                    case 4:
                        viewAllBookings();
                        break;
                    case 5:
                        updateBookingDiscount();
                        break;
                    case 6:
                        cancelBooking();
                        break;
                    case 7:
                        viewWeeklyRevenue();
                        break;
                    case 8:
                        running = false;
                        System.out.println("Goodbye!");
                        break;
                    default:
                        System.out.println("Invalid choice! Please try again.");
                }

                if (running) {
                    System.out.println("\nPress Enter to continue...");
                    scanner.nextLine();
                }

            } catch (QuitToMenuException e) {
                System.out.println("\n↩ Returning to main menu...\n");
                // loop continues automatically
            }
        }
    }

    private void printMenu() {
        System.out.println("\n" + "=".repeat(40));
        System.out.println("    HOTEL BOOKING SYSTEM");
        System.out.println("=".repeat(40));
        System.out.println("1. View All Rooms");
        System.out.println("2. Check Room Availability");
        System.out.println("3. Add New Booking");
        System.out.println("4. View All Bookings");
        System.out.println("5. Update Booking Discount");
        System.out.println("6. Cancel Booking");
        System.out.println("7. View Weekly Revenue Report");
        System.out.println("8. Exit");
        System.out.println("=".repeat(40));
    }

    // Input Helpers
    private int getIntInput(String prompt) {
        while (true) {
            System.out.print(prompt);
            String raw = scanner.nextLine().trim();

            if (raw.equalsIgnoreCase("q")) {
                throw new QuitToMenuException();
            }

            try {
                return Integer.parseInt(raw);
            } catch (NumberFormatException e) {
                System.out.println("Invalid input. Try again or type 'q' to return to menu.");
            }
        }
    }

    private String getStringInput(String prompt) {
        System.out.print(prompt);
        String raw = scanner.nextLine().trim();

        if (raw.equalsIgnoreCase("q")) {
            throw new QuitToMenuException();
        }

        return raw;
    }

    // ===== DB OPERATIONS (MATCH OLD SCHEMA) =====
    private void viewAllRooms() {
        String sql = "SELECT r.room_id, r.room_number, rt.type_name, "
                + "rt.capacity, rt.nightly_price "
                + "FROM Rooms r "
                + "JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id "
                + "ORDER BY r.room_number";

        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {

            printTableHeader("ALL ROOMS",
                    "Room ID", "Room #", "Type", "Capacity", "Price/Night");

            while (rs.next()) {
                System.out.printf("%-10d %-10s %-15s %-10d $%-10.2f%n",
                        rs.getInt("room_id"),
                        rs.getString("room_number"),
                        rs.getString("type_name"),
                        rs.getInt("capacity"),
                        rs.getDouble("nightly_price"));
            }

        } catch (SQLException e) {
            handleSQLException("viewing rooms", e);
        }
    }

    private void viewAvailableRooms() {
        String date = getStringInput("Enter date (YYYY-MM-DD): ");

        String sql = "SELECT r.room_id, r.room_number, rt.type_name, "
                + "rt.capacity, rt.nightly_price "
                + "FROM Rooms r "
                + "JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id "
                + "WHERE r.room_id NOT IN ( "
                + "    SELECT room_id FROM Bookings "
                + "    WHERE is_cancelled = FALSE "
                + "    AND ? BETWEEN DATE(check_in) AND DATE(check_out) "
                + ") ORDER BY r.room_number";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, date);
            ResultSet rs = pstmt.executeQuery();

            printTableHeader("AVAILABLE ROOMS ON " + date,
                    "Room ID", "Room #", "Type", "Capacity", "Price/Night");

            boolean hasResults = false;
            while (rs.next()) {
                hasResults = true;
                System.out.printf("%-10d %-10s %-15s %-10d $%-10.2f%n",
                        rs.getInt("room_id"),
                        rs.getString("room_number"),
                        rs.getString("type_name"),
                        rs.getInt("capacity"),
                        rs.getDouble("nightly_price"));
            }

            if (!hasResults) {
                System.out.println("No rooms available on this date.");
            }

        } catch (SQLException e) {
            handleSQLException("checking availability", e);
        }
    }

    private void addBooking() {
        String guestName = getStringInput("Enter Guest Name (exactly as in DB): ");

        Integer guestId = findGuestIdByName(guestName);
        if (guestId == null) {
            int newId = createGuest(guestName);
            if (newId == -1) {
                System.out.println("✗ Could not create guest. Booking cancelled.");
                return;
            }
            guestId = newId;
            System.out.println("✓ Guest created with ID: " + guestId);
        }

        int roomId = getIntInput("Enter Room ID (1-5): ");
        int paymentMethodId = getIntInput("Enter Payment Method ID (1=Credit, 2=Debit, 3=Cash): ");
        String checkIn = getStringInput("Enter Check-in (YYYY-MM-DD HH:MM:SS): ");
        String checkOut = getStringInput("Enter Check-out (YYYY-MM-DD HH:MM:SS): ");

        String sql = "INSERT INTO Bookings (guest_id, room_id, payment_method_id, "
                + "booking_datetime, check_in, check_out, is_cancelled, discount_applied) "
                + "VALUES (?, ?, ?, NOW(), ?, ?, FALSE, FALSE)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, guestId);
            pstmt.setInt(2, roomId);
            pstmt.setInt(3, paymentMethodId);
            pstmt.setString(4, checkIn);
            pstmt.setString(5, checkOut);

            int rows = pstmt.executeUpdate();
            System.out.println(rows > 0 ? "✓ Booking added successfully!" : "✗ Failed to add booking.");

        } catch (SQLException e) {
            handleSQLException("adding booking", e);
        }
    }

    private void viewAllBookings() {
        String sql = "SELECT b.booking_id, g.name, r.room_number, "
                + "b.check_in, b.check_out, "
                + "CASE WHEN b.is_cancelled = TRUE THEN 'Cancelled' ELSE 'Active' END AS status "
                + "FROM Bookings b "
                + "JOIN Guests g ON b.guest_id = g.guest_id "
                + "JOIN Rooms r ON b.room_id = r.room_id "
                + "ORDER BY b.booking_datetime DESC LIMIT 20";

        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {

            printTableHeader("RECENT BOOKINGS (Last 20)",
                    "Booking ID", "Guest Name", "Room", "Check-in", "Check-out", "Status");

            while (rs.next()) {
                System.out.printf("%-12d %-25s %-8s %-20s %-20s %-10s%n",
                        rs.getInt("booking_id"),
                        rs.getString("name"),
                        rs.getString("room_number"),
                        rs.getString("check_in"),
                        rs.getString("check_out"),
                        rs.getString("status"));
            }

        } catch (SQLException e) {
            handleSQLException("viewing bookings", e);
        }
    }

    private void updateBookingDiscount() {
        int bookingId = getIntInput("Enter Booking ID: ");
        int choice = getIntInput("Apply discount? (1=Yes, 2=No): ");
        boolean applyDiscount = (choice == 1);

        String sql = "UPDATE Bookings SET discount_applied = ? WHERE booking_id = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setBoolean(1, applyDiscount);
            pstmt.setInt(2, bookingId);

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("✓ Booking updated! Discount: "
                        + (applyDiscount ? "Applied" : "Removed"));
            } else {
                System.out.println("✗ Booking ID not found.");
            }

        } catch (SQLException e) {
            handleSQLException("updating booking discount", e);
        }
    }

    private void cancelBooking() {
        int bookingId = getIntInput("Enter Booking ID to cancel: ");

        String sql = "UPDATE Bookings SET is_cancelled = TRUE WHERE booking_id = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, bookingId);

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                System.out.println("✓ Booking cancelled successfully!");
            } else {
                System.out.println("✗ Booking ID not found.");
            }

        } catch (SQLException e) {
            handleSQLException("cancelling booking", e);
        }
    }

    private void viewWeeklyRevenue() {
        String sql
                = "SELECT YEAR(b.check_in) AS year, WEEK(b.check_in) AS week, "
                + "SUM(DATEDIFF(b.check_out, b.check_in) * rt.nightly_price * "
                + "    (CASE "
                + "       WHEN g.is_staff = TRUE THEN 0.8 "
                + "       WHEN b.discount_applied = TRUE THEN 0.8 "
                + "       ELSE 1 "
                + "    END) "
                + ") AS revenue "
                + "FROM Bookings b "
                + "JOIN Rooms r ON b.room_id = r.room_id "
                + "JOIN RoomTypes rt ON r.room_type_id = rt.room_type_id "
                + "JOIN Guests g ON b.guest_id = g.guest_id "
                + "WHERE b.is_cancelled = FALSE "
                + "GROUP BY YEAR(b.check_in), WEEK(b.check_in) "
                + "ORDER BY revenue DESC LIMIT 10";

        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {

            printTableHeader("TOP 10 REVENUE WEEKS", "Year", "Week", "Revenue");

            while (rs.next()) {
                System.out.printf("%-8d %-8d $%-12.2f%n",
                        rs.getInt("year"),
                        rs.getInt("week"),
                        rs.getDouble("revenue"));
            }

        } catch (SQLException e) {
            handleSQLException("calculating revenue", e);
        }
    }

    // Utilities
    private void printTableHeader(String title, String... columns) {
        System.out.println("\n--- " + title + " ---");
        for (String col : columns) {
            System.out.printf("%-15s", col);
        }
        System.out.println();
        System.out.println("-".repeat(80));
    }

    private void handleSQLException(String operation, SQLException e) {
        System.err.println("✗ Error " + operation + ": " + e.getMessage());
        if (e.getMessage().contains("Duplicate entry")) {
            System.out.println("Hint: This record already exists.");
        } else if (e.getMessage().contains("foreign key constraint")) {
            System.out.println("Hint: Referenced ID does not exist.");
        }
    }

    private Integer findGuestIdByName(String name) {
        String sql = "SELECT guest_id FROM Guests WHERE name = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, name);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("guest_id");
            }
        } catch (SQLException e) {
            handleSQLException("finding guest", e);
        }
        return null;
    }

    private int createGuest(String name) {
        String contact = getStringInput("Guest not found. Enter contact email: ");
        int staffChoice = getIntInput("Is staff? (1=Yes, 2=No): ");
        boolean isStaff = (staffChoice == 1);

        String sql = "INSERT INTO Guests (name, contact_info, is_staff) VALUES (?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, name);
            pstmt.setString(2, contact);
            pstmt.setBoolean(3, isStaff);
            pstmt.executeUpdate();

            ResultSet keys = pstmt.getGeneratedKeys();
            if (keys.next()) {
                return keys.getInt(1);
            }
        } catch (SQLException e) {
            handleSQLException("creating guest", e);
        }

        return -1;
    }

}
