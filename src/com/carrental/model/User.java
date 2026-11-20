package com.carrental.model;

import java.sql.Date;

public class User {
    private int    userId;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String passwordHash;
    private String passwordSalt;
    private String role;          // "user" or "admin"
    private String address;
    private String licenseNo;
    private String department;    // admin only
    private Date   dob;
    private Date   createdAt;

    // ── Constructors ──────────────────────────────
    public User() {}

    public User(String firstName, String lastName, String email,
                String phone, String passwordHash, String passwordSalt,
                String role) {
        this.firstName    = firstName;
        this.lastName     = lastName;
        this.email        = email;
        this.phone        = phone;
        this.passwordHash = passwordHash;
        this.passwordSalt = passwordSalt;
        this.role         = role;
    }

    // ── Helpers ───────────────────────────────────
    public String getFullName() {
        return firstName + (lastName != null && !lastName.isEmpty() ? " " + lastName : "");
    }

    // ── Getters / Setters ─────────────────────────
    public int    getUserId()       { return userId; }
    public void   setUserId(int v)  { userId = v; }

    public String getFirstName()         { return firstName; }
    public void   setFirstName(String v) { firstName = v; }

    public String getLastName()          { return lastName; }
    public void   setLastName(String v)  { lastName = v; }

    public String getEmail()         { return email; }
    public void   setEmail(String v) { email = v; }

    public String getPhone()         { return phone; }
    public void   setPhone(String v) { phone = v; }

    public String getPasswordHash()         { return passwordHash; }
    public void   setPasswordHash(String v) { passwordHash = v; }

    public String getPasswordSalt()         { return passwordSalt; }
    public void   setPasswordSalt(String v) { passwordSalt = v; }

    public String getRole()         { return role; }
    public void   setRole(String v) { role = v; }

    public String getAddress()         { return address; }
    public void   setAddress(String v) { address = v; }

    public String getLicenseNo()         { return licenseNo; }
    public void   setLicenseNo(String v) { licenseNo = v; }

    public String getDepartment()         { return department; }
    public void   setDepartment(String v) { department = v; }

    public Date getDob()         { return dob; }
    public void setDob(Date v)   { dob = v; }

    public Date getCreatedAt()       { return createdAt; }
    public void setCreatedAt(Date v) { createdAt = v; }
}
