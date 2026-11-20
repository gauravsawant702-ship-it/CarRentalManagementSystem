package com.carrental.dao;

import com.carrental.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public boolean saveFeedback(String name, String email, int rating,
                                 String category, String subject,
                                 String message, String recommend,
                                 Integer userId) {
        String sql = "INSERT INTO feedback (user_id, name, email, rating, category, subject, message, recommend) " +
                     "VALUES (?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (userId != null) ps.setInt(1, userId);
            else                ps.setNull(1, Types.INTEGER);

            ps.setString(2, name);
            ps.setString(3, email);
            ps.setInt   (4, rating);
            ps.setString(5, category);
            ps.setString(6, subject);
            ps.setString(7, message);
            ps.setString(8, recommend);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /** Returns all feedback rows as List of Object arrays for admin display. */
    public List<Object[]> getAllFeedback() {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT feedback_id, name, email, rating, category, subject, message, recommend, submitted_at " +
                     "FROM feedback ORDER BY submitted_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement  st   = conn.createStatement();
             ResultSet  rs   = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Object[]{
                    rs.getInt("feedback_id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getInt("rating"),
                    rs.getString("category"),
                    rs.getString("subject"),
                    rs.getString("message"),
                    rs.getString("recommend"),
                    rs.getTimestamp("submitted_at")
                });
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public double getAverageRating() {
        String sql = "SELECT AVG(rating) FROM feedback";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
