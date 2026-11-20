package com.carrental.model;

public class Car {
    private int     carId;
    private String  name;
    private String  category;   // Sedan, SUV, Coupe, etc.
    private int     year;
    private String  fuelType;   // Petrol, Diesel, Electric, Hybrid
    private String  transmission; // Automatic, Manual
    private int     seats;
    private double  pricePerDay;
    private boolean available;
    private String  imageUrl;
    private String  description;
    private String  color;
    private String  licensePlate;

    // ── Constructors ──────────────────────────────
    public Car() {}

    // ── Getters / Setters ─────────────────────────
    public int     getCarId()          { return carId; }
    public void    setCarId(int v)     { carId = v; }

    public String  getName()           { return name; }
    public void    setName(String v)   { name = v; }

    public String  getCategory()           { return category; }
    public void    setCategory(String v)   { category = v; }

    public int     getYear()           { return year; }
    public void    setYear(int v)      { year = v; }

    public String  getFuelType()           { return fuelType; }
    public void    setFuelType(String v)   { fuelType = v; }

    public String  getTransmission()           { return transmission; }
    public void    setTransmission(String v)   { transmission = v; }

    public int     getSeats()          { return seats; }
    public void    setSeats(int v)     { seats = v; }

    public double  getPricePerDay()          { return pricePerDay; }
    public void    setPricePerDay(double v)  { pricePerDay = v; }

    public boolean isAvailable()           { return available; }
    public void    setAvailable(boolean v) { available = v; }

    public String  getImageUrl()           { return imageUrl; }
    public void    setImageUrl(String v)   { imageUrl = v; }

    public String  getDescription()            { return description; }
    public void    setDescription(String v)    { description = v; }

    public String  getColor()          { return color; }
    public void    setColor(String v)  { color = v; }

    public String  getLicensePlate()           { return licensePlate; }
    public void    setLicensePlate(String v)   { licensePlate = v; }
}
