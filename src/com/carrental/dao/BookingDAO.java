package com.carrental.dao;

import com.carrental.model.Booking;
import com.carrental.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public int createBooking(Booking b) {
        String sql = "INSERT INTO bookings (user_id, car_id, first_name, last_name, phone, license_no, " +
                     "pickup_date, return_date, pickup_location, total_amount, status, special_requests) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt   (1,  b.getUserId());
            ps.setInt   (2,  b.getCarId());
            ps.setString(3,  b.getFirstName());
            ps.setString(4,  b.getLastName());
            ps.setString(5,  b.getPhone());
            ps.setString(6,  b.getLicenseNo());
            ps.setDate  (7,  b.getPickupDate());
            ps.setDate  (8,  b.getReturnDate());
            ps.setString(9,  b.getPickupLocation());
            ps.setDouble(10, b.getTotalAmount());
            ps.setString(11, "Pending");
            ps.setString(12, b.getSpecialRequests());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);

        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public List<Booking> getBookingsByUser(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name AS car_name, u.first_name AS u_first, u.last_name AS u_last, u.email AS u_email " +
                     "FROM bookings b " +
                     "JOIN cars c ON b.car_id = c.car_id " +
                     "JOIN users u ON b.user_id = u.user_id " +
                     "WHERE b.user_id = ? ORDER BY b.booked_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Booking> getRecentBookings(int limit) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name AS car_name, u.first_name AS u_first, u.last_name AS u_last, u.email AS u_email " +
                     "FROM bookings b " +
                     "JOIN cars c ON b.car_id = c.car_id " +
                     "JOIN users u ON b.user_id = u.user_id " +
                     "ORDER BY b.booked_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name AS car_name, u.first_name AS u_first, u.last_name AS u_last, u.email AS u_email " +
                     "FROM bookings b " +
                     "JOIN cars c ON b.car_id = c.car_id " +
                     "JOIN users u ON b.user_id = u.user_id " +
                     "ORDER BY b.booked_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement  st   = conn.createStatement();
             ResultSet  rs   = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateStatus(int bookingId, String status) {
        String sql = "UPDATE bookings SET status = ? WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt   (2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int getTotalBookings() {
        String sql = "SELECT COUNT(*) FROM bookings";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getActiveBookings() {
        String sql = "SELECT COUNT(*) FROM bookings WHERE status IN ('Pending','Confirmed')";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public double getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount),0) FROM bookings WHERE status != 'Cancelled'";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Booking mapRow(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setBookingId     (rs.getInt   ("booking_id"));
        b.setUserId        (rs.getInt   ("user_id"));
        b.setCarId         (rs.getInt   ("car_id"));
        b.setFirstName     (rs.getString("first_name"));
        b.setLastName      (rs.getString("last_name"));
        b.setPhone         (rs.getString("phone"));
        b.setLicenseNo     (rs.getString("license_no"));
        b.setPickupDate    (rs.getDate  ("pickup_date"));
        b.setReturnDate    (rs.getDate  ("return_date"));
        b.setPickupLocation(rs.getString("pickup_location"));
        b.setTotalAmount   (rs.getDouble("total_amount"));
        b.setStatus        (rs.getString("status"));
        b.setSpecialRequests(rs.getString("special_requests"));
        b.setBookedAt      (rs.getDate  ("booked_at"));
        // joined fields
        b.setCarName (rs.getString("car_name"));
        b.setUserName(rs.getString("u_first") + " " + rs.getString("u_last"));
        b.setUserEmail(rs.getString("u_email"));
        return b;
    }
}
