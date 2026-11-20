<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.carrental.model.User, com.carrental.model.Booking, com.carrental.dao.BookingDAO, java.util.List" %>
<%
  request.setAttribute("currentPage", "bookings");
  User loggedUser = (User) session.getAttribute("loggedUser");
  if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }

  BookingDAO bookingDAO = new BookingDAO();
  List<Booking> bookings = bookingDAO.getBookingsByUser(loggedUser.getUserId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Bookings – CarRental</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<style>
  .bookings-page { padding: 40px 48px 80px; max-width: 1000px; margin: 0 auto; }
  .booking-card {
    background: white; border-radius: 18px; padding: 24px 28px;
    box-shadow: var(--card-shadow); margin-bottom: 20px;
    display: grid; grid-template-columns: 1fr auto; gap: 16px; align-items: center;
    animation: fadeUp .4s ease both;
  }
  .booking-id   { font-size: .8rem; color: var(--muted); font-weight: 600; letter-spacing: .04em; }
  .booking-car  { font-family: 'Syne', sans-serif; font-size: 1.15rem; font-weight: 700; margin: 4px 0; }
  .booking-meta { display: flex; gap: 20px; flex-wrap: wrap; margin-top: 8px; }
  .meta-item    { display: flex; align-items: center; gap: 6px; font-size: .85rem; color: var(--muted); }
  .booking-amount { font-family: 'Syne', sans-serif; font-size: 1.3rem; font-weight: 800; color: var(--blue); text-align: right; }
  .status-badge { padding: 4px 12px; border-radius: 50px; font-size: .75rem; font-weight: 600; display: inline-block; margin-top: 6px; }
  .status-pending   { background: #fef3c7; color: #92400e; }
  .status-confirmed { background: #dcfce7; color: #166534; }
  .status-cancelled { background: #fee2e2; color: #991b1b; }
  .status-completed { background: #dbeafe; color: #1e40af; }
  .empty-state { text-align: center; padding: 80px 0; color: var(--muted); }
  .empty-state .icon { font-size: 3rem; margin-bottom: 16px; }
  @media(max-width:600px){ .bookings-page{padding:24px 16px 60px;} .booking-card{grid-template-columns:1fr;} }
</style>
</head>
<body>
<%@ include file="nav.jsp" %>

<div class="page-header">
  <h2>My Bookings</h2>
  <p>Track and manage all your car rental reservations</p>
</div>

<div class="bookings-page">
  <% if (bookings == null || bookings.isEmpty()) { %>
    <div class="empty-state">
      <div class="icon">🚗</div>
      <h3 style="font-family:'Syne',sans-serif;font-weight:700;margin-bottom:8px">No bookings yet</h3>
      <p>Looks like you haven't booked any cars. Browse our fleet to get started!</p>
      <a href="cars.jsp" class="btn-primary" style="margin-top:20px">Browse Cars</a>
    </div>
  <% } else {
       for (int i = 0; i < bookings.size(); i++) {
         Booking b = bookings.get(i);
         String statusClass = "status-" + b.getStatus().toLowerCase();
  %>
    <div class="booking-card" style="animation-delay:<%= i * 0.06 %>s">
      <div>
        <div class="booking-id">BOOKING #<%= b.getBookingId() %></div>
        <div class="booking-car"><%= b.getCarName() %></div>
        <div class="booking-meta">
          <div class="meta-item">
            <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
            <%= b.getPickupDate() %> → <%= b.getReturnDate() %>
          </div>
          <div class="meta-item">
            <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
            <%= b.getPickupLocation() %>
          </div>
          <div class="meta-item">
            <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
            <%= b.getDays() %> day<%= b.getDays() != 1 ? "s" : "" %>
          </div>
        </div>
      </div>
      <div style="text-align:right">
        <div class="booking-amount">₹<%= String.format("%.0f", b.getTotalAmount()) %></div>
        <span class="status-badge <%= statusClass %>"><%= b.getStatus() %></span>
      </div>
    </div>
  <% } } %>
</div>

<script src="js/common.js"></script>
</body>
</html>
