package com.carrental.model;

import java.sql.Date;

public class Booking {
    private int    bookingId;
    private int    userId;
    private int    carId;
    private String userName;
    private String userEmail;
    private String carName;
    private String firstName;
    private String lastName;
    private String phone;
    private String licenseNo;
    private Date   pickupDate;
    private Date   returnDate;
    private String pickupLocation;
    private double totalAmount;
    private String status;        // Pending, Confirmed, Completed, Cancelled
    private String specialRequests;
    private Date   bookedAt;

    // ── Helpers ───────────────────────────────────
    public String getFullName() {
        return firstName + (lastName != null ? " " + lastName : "");
    }

    public int getDays() {
        if (pickupDate == null || returnDate == null) return 0;
        long diff = returnDate.getTime() - pickupDate.getTime();
        return (int)(diff / (1000 * 60 * 60 * 24));
    }

    // ── Getters / Setters ─────────────────────────
    public int    getBookingId()         { return bookingId; }
    public void   setBookingId(int v)    { bookingId = v; }

    public int    getUserId()        { return userId; }
    public void   setUserId(int v)   { userId = v; }

    public int    getCarId()         { return carId; }
    public void   setCarId(int v)    { carId = v; }

    public String getUserName()          { return userName; }
    public void   setUserName(String v)  { userName = v; }

    public String getUserEmail()             { return userEmail; }
    public void   setUserEmail(String v)     { userEmail = v; }

    public String getCarName()           { return carName; }
    public void   setCarName(String v)   { carName = v; }

    public String getFirstName()             { return firstName; }
    public void   setFirstName(String v)     { firstName = v; }

    public String getLastName()          { return lastName; }
    public void   setLastName(String v)  { lastName = v; }

    public String getPhone()         { return phone; }
    public void   setPhone(String v) { phone = v; }

    public String getLicenseNo()             { return licenseNo; }
    public void   setLicenseNo(String v)     { licenseNo = v; }

    public Date   getPickupDate()        { return pickupDate; }
    public void   setPickupDate(Date v)  { pickupDate = v; }

    public Date   getReturnDate()        { return returnDate; }
    public void   setReturnDate(Date v)  { returnDate = v; }

    public String getPickupLocation()                { return pickupLocation; }
    public void   setPickupLocation(String v)        { pickupLocation = v; }

    public double getTotalAmount()           { return totalAmount; }
    public void   setTotalAmount(double v)   { totalAmount = v; }

    public String getStatus()            { return status; }
    public void   setStatus(String v)    { status = v; }

    public String getSpecialRequests()               { return specialRequests; }
    public void   setSpecialRequests(String v)       { specialRequests = v; }

    public Date   getBookedAt()          { return bookedAt; }
    public void   setBookedAt(Date v)    { bookedAt = v; }
}
