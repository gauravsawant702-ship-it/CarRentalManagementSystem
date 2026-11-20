package com.carrental.dao;

import com.carrental.model.Car;
import com.carrental.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CarDAO {

    public List<Car> getAllCars() {
        List<Car> list = new ArrayList<>();
        String sql = "SELECT * FROM cars ORDER BY name";
        try (Connection conn = DBConnection.getConnection();
             Statement  st   = conn.createStatement();
             ResultSet  rs   = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Car getCarById(int carId) {
        String sql = "SELECT * FROM cars WHERE car_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, carId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public int getTotalCars() {
        String sql = "SELECT COUNT(*) FROM cars";
        try (Connection conn = DBConnection.getConnection();
             Statement  st   = conn.createStatement();
             ResultSet  rs   = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public boolean addCar(Car car) {
        String sql = "INSERT INTO cars (name, category, year, fuel_type, transmission, seats, " +
                     "price_per_day, available, image_url, description, color, license_plate) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString (1, car.getName());
            ps.setString (2, car.getCategory());
            ps.setInt    (3, car.getYear());
            ps.setString (4, car.getFuelType());
            ps.setString (5, car.getTransmission());
            ps.setInt    (6, car.getSeats());
            ps.setDouble (7, car.getPricePerDay());
            ps.setBoolean(8, car.isAvailable());
            ps.setString (9, car.getImageUrl());
            ps.setString (10, car.getDescription());
            ps.setString (11, car.getColor());
            ps.setString (12, car.getLicensePlate());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateAvailability(int carId, boolean available) {
        String sql = "UPDATE cars SET available = ? WHERE car_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, available);
            ps.setInt    (2, carId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteCar(int carId) {
        String sql = "DELETE FROM cars WHERE car_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, carId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Car mapRow(ResultSet rs) throws SQLException {
        Car c = new Car();
        c.setCarId       (rs.getInt    ("car_id"));
        c.setName        (rs.getString ("name"));
        c.setCategory    (rs.getString ("category"));
        c.setYear        (rs.getInt    ("year"));
        c.setFuelType    (rs.getString ("fuel_type"));
        c.setTransmission(rs.getString ("transmission"));
        c.setSeats       (rs.getInt    ("seats"));
        c.setPricePerDay (rs.getDouble ("price_per_day"));
        c.setAvailable   (rs.getBoolean("available"));
        c.setImageUrl    (rs.getString ("image_url"));
        c.setDescription (rs.getString ("description"));
        c.setColor       (rs.getString ("color"));
        c.setLicensePlate(rs.getString ("license_plate"));
        return c;
    }
}
