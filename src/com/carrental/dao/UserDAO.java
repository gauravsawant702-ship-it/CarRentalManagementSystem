package com.carrental.dao;

import com.carrental.model.User;
import com.carrental.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    /** Insert a new user. Returns generated userId, or -1 on failure. */
    public int registerUser(User u) {
        String sql = "INSERT INTO users (first_name, last_name, email, phone, password_hash, password_salt, " +
                     "role, address, license_no, department, dob) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, u.getFirstName());
            ps.setString(2, u.getLastName());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getPhone());
            ps.setString(5, u.getPasswordHash());
            ps.setString(6, u.getPasswordSalt());
            ps.setString(7, u.getRole());
            ps.setString(8, u.getAddress());
            ps.setString(9, u.getLicenseNo());
            ps.setString(10, u.getDepartment());
            ps.setDate  (11, u.getDob());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /** Find user by email (for login). */
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Check if email already exists. */
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'user'";
        try (Connection conn = DBConnection.getConnection();
             Statement  st   = conn.createStatement();
             ResultSet  rs   = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'user' ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement  st   = conn.createStatement();
             ResultSet  rs   = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId      (rs.getInt   ("user_id"));
        u.setFirstName   (rs.getString("first_name"));
        u.setLastName    (rs.getString("last_name"));
        u.setEmail       (rs.getString("email"));
        u.setPhone       (rs.getString("phone"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setPasswordSalt(rs.getString("password_salt"));
        u.setRole        (rs.getString("role"));
        u.setAddress     (rs.getString("address"));
        u.setLicenseNo   (rs.getString("license_no"));
        u.setDepartment  (rs.getString("department"));
        u.setDob         (rs.getDate  ("dob"));
        u.setCreatedAt   (rs.getDate  ("created_at"));
        return u;
    }
}
