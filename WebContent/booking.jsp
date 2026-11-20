<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.carrental.model.Car, com.carrental.model.User, com.carrental.dao.CarDAO" %>
<%
  request.setAttribute("currentPage", "cars");
  User loggedUser = (User) session.getAttribute("loggedUser");
  if (loggedUser == null) {
    response.sendRedirect("login.jsp?redirect=booking");
    return;
  }

  int carId = 0;
  try { carId = Integer.parseInt(request.getParameter("carId")); } catch(Exception e) {}
  CarDAO carDAO = new CarDAO();
  Car car = carDAO.getCarById(carId);
  if (car == null) { response.sendRedirect("cars.jsp"); return; }

  String pickup   = request.getParameter("pickup")     != null ? request.getParameter("pickup")    : "";
  String returnDt = request.getParameter("returnDate") != null ? request.getParameter("returnDate"): "";
  String location = request.getParameter("location")   != null ? request.getParameter("location")  : "";
  String successMsg = (String) request.getAttribute("successMsg");
  String errorMsg   = (String) request.getAttribute("errorMsg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Book <%= car.getName() %> – CarRental</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<style>
  .booking-page {
    padding: 60px 24px 80px;
    display: flex; justify-content: center; gap: 40px; flex-wrap: wrap; align-items: flex-start;
  }
  .booking-card { background: white; border-radius: 24px; padding: 36px; width: min(520px, 100%); box-shadow: var(--card-shadow); }
  .car-summary {
    background: white; border-radius: 24px; padding: 28px; width: min(340px, 100%);
    box-shadow: var(--card-shadow); position: sticky; top: 90px;
  }
  .car-summary img { width: 100%; border-radius: 14px; object-fit: cover; height: 180px; }
  .car-summary h3 { font-family: 'Syne', sans-serif; font-weight: 800; font-size: 1.3rem; margin-top: 16px; }
  .cs-detail { display: flex; justify-content: space-between; margin-top: 12px; font-size: .9rem; }
  .cs-detail span { color: var(--muted); }
  .cs-detail strong { font-weight: 600; }
  .price-box {
    background: var(--blue-light); border-radius: 12px; padding: 16px;
    margin-top: 16px; display: flex; justify-content: space-between; align-items: center;
  }
  .price-box .label { font-weight: 600; color: var(--blue); font-size: .9rem; }
  .price-box .amount { font-family: 'Syne', sans-serif; font-size: 1.5rem; font-weight: 800; color: var(--blue); }
  .days-note { font-size: .8rem; color: var(--muted); text-align: center; margin-top: 8px; }
</style>
</head>
<body>

<%@ include file="nav.jsp" %>

<div style="padding:32px 48px 0">
  <a href="cars.jsp" style="color:var(--blue);text-decoration:none;font-weight:500;font-size:.9rem">← Back to Cars</a>
  <h2 style="font-family:'Syne',sans-serif;font-size:1.8rem;font-weight:800;margin-top:8px">Book Your Car</h2>
</div>

<% if (successMsg != null) { %><div class="alert alert-success" style="max-width:900px;margin:16px auto 0 48px"><%= successMsg %></div><% } %>
<% if (errorMsg   != null) { %><div class="alert alert-error"   style="max-width:900px;margin:16px auto 0 48px"><%= errorMsg   %></div><% } %>

<div class="booking-page">

  <!-- Booking Form -->
  <div class="booking-card fade-up">
    <h3 style="font-family:'Syne',sans-serif;font-size:1.3rem;font-weight:800;margin-bottom:6px">Booking Details</h3>
    <p style="color:var(--muted);font-size:.9rem;margin-bottom:24px">Fill in your details to confirm reservation</p>

    <form action="BookingServlet" method="post" onsubmit="return validateBooking()">
      <input type="hidden" name="carId" value="<%= car.getCarId() %>">
      <input type="hidden" name="userId" value="<%= loggedUser.getUserId() %>">

      <div class="form-row">
        <div class="form-group">
          <label>First Name</label>
          <input type="text" name="firstName" value="<%= loggedUser.getFullName().split(" ")[0] %>" required>
        </div>
        <div class="form-group">
          <label>Last Name</label>
          <input type="text" name="lastName"
            value="<%= loggedUser.getFullName().contains(" ") ? loggedUser.getFullName().substring(loggedUser.getFullName().indexOf(" ")+1) : "" %>" required>
        </div>
      </div>

      <div class="form-group">
        <label>Email Address</label>
        <input type="email" name="email" value="<%= loggedUser.getEmail() %>" required>
      </div>

      <div class="form-group">
        <label>Phone Number</label>
        <input type="tel" name="phone" placeholder="10-digit mobile number"
               value="<%= loggedUser.getPhone() != null ? loggedUser.getPhone() : "" %>" required>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>Pick-up Date</label>
          <input type="date" name="pickupDate" id="pickupDate" value="<%= pickup %>" required onchange="calcTotal()">
        </div>
        <div class="form-group">
          <label>Return Date</label>
          <input type="date" name="returnDate" id="returnDate" value="<%= returnDt %>" required onchange="calcTotal()">
        </div>
      </div>

      <div class="form-group">
        <label>Pickup Location</label>
        <select name="pickupLocation" required>
          <option value="">Select location</option>
          <% String[] locs = {"Mumbai, MH","Pune, MH","Nashik, MH","Aurangabad, MH","Nagpur, MH","New Delhi, DL","Bangalore, KA"};
             for (String l : locs) { %>
            <option value="<%= l %>" <%= l.equals(location) ? "selected" : "" %>><%= l %></option>
          <% } %>
        </select>
      </div>

      <div class="form-group">
        <label>Driving License Number</label>
        <input type="text" name="licenseNo" placeholder="e.g. MH1220230012345" required>
      </div>

      <div class="form-group">
        <label>Special Requests (Optional)</label>
        <textarea name="specialRequests" rows="3" placeholder="Child seat, GPS, etc."></textarea>
      </div>

      <div class="price-box" style="margin-bottom:16px">
        <span class="label">Estimated Total</span>
        <span class="amount" id="total-display">₹<%= car.getPricePerDay() %>/day</span>
      </div>

      <button type="submit" class="form-submit">Confirm Booking →</button>
    </form>
  </div>

  <!-- Car Summary -->
  <div class="car-summary fade-up">
    <img src="<%= car.getImageUrl() %>" alt="<%= car.getName() %>"
         onerror="this.src='https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=800&q=80'">
    <h3><%= car.getName() %></h3>
    <div class="cs-detail"><span>Category</span><strong><%= car.getCategory() %></strong></div>
    <div class="cs-detail"><span>Year</span><strong><%= car.getYear() %></strong></div>
    <div class="cs-detail"><span>Fuel</span><strong><%= car.getFuelType() %></strong></div>
    <div class="cs-detail"><span>Transmission</span><strong><%= car.getTransmission() %></strong></div>
    <div class="cs-detail"><span>Seats</span><strong><%= car.getSeats() %></strong></div>
    <div class="cs-detail"><span>Rate</span><strong>₹<%= car.getPricePerDay() %>/day</strong></div>
    <div class="price-box" style="margin-top:20px">
      <span class="label">Total Estimate</span>
      <span class="amount" id="summary-total">₹<%= car.getPricePerDay() %></span>
    </div>
    <div class="days-note" id="days-note">Select dates to see total</div>
  </div>

</div>

<script src="js/common.js"></script>
<script>
const pricePerDay = <%= car.getPricePerDay() %>;

function calcTotal() {
  const p = document.getElementById('pickupDate').value;
  const r = document.getElementById('returnDate').value;
  if (p && r && r > p) {
    const days = Math.round((new Date(r) - new Date(p)) / 86400000);
    const total = days * pricePerDay;
    document.getElementById('total-display').textContent = `₹${total.toLocaleString('en-IN')}`;
    document.getElementById('summary-total').textContent = `₹${total.toLocaleString('en-IN')}`;
    document.getElementById('days-note').textContent = `${days} day${days > 1 ? 's' : ''} × ₹${pricePerDay}/day`;
  }
}

function validateBooking() {
  const p = document.getElementById('pickupDate').value;
  const r = document.getElementById('returnDate').value;
  const phone = document.querySelector('[name="phone"]').value;
  if (!p || !r) { showToast('Please select both dates'); return false; }
  if (p >= r)   { showToast('Return date must be after pick-up'); return false; }
  if (!/^[6-9]\d{9}$/.test(phone)) { showToast('Enter a valid 10-digit phone number'); return false; }
  return true;
}

// init calc if dates pre-filled
window.addEventListener('DOMContentLoaded', calcTotal);
</script>
</body>
</html>
