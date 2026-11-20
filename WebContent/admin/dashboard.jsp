<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.carrental.model.User, com.carrental.dao.BookingDAO, com.carrental.dao.CarDAO, com.carrental.dao.UserDAO, java.util.List, com.carrental.model.Booking" %>
<%
  User loggedUser = (User) session.getAttribute("loggedUser");
  if (loggedUser == null || !"admin".equals(loggedUser.getRole())) {
    response.sendRedirect("../login.jsp");
    return;
  }
  request.setAttribute("currentPage", "admin");
  BookingDAO bookingDAO = new BookingDAO();
  CarDAO carDAO = new CarDAO();
  UserDAO userDAO = new UserDAO();
  int totalBookings  = bookingDAO.getTotalBookings();
  int activeBookings = bookingDAO.getActiveBookings();
  int totalCars      = carDAO.getTotalCars();
  int totalUsers     = userDAO.getTotalUsers();
  double totalRevenue = bookingDAO.getTotalRevenue();
  List<Booking> recentBookings = bookingDAO.getRecentBookings(10);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard – CarRental</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="../css/style.css">
<style>
  .admin-layout { display: flex; min-height: calc(100vh - 70px); }
  .sidebar {
    width: 240px; background: white; border-right: 1px solid #e5e7eb;
    padding: 28px 16px; flex-shrink: 0; position: sticky; top: 70px;
    height: calc(100vh - 70px); overflow-y: auto;
  }
  .sidebar-label { font-size: .7rem; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: .08em; padding: 0 12px; margin-bottom: 8px; margin-top: 20px; }
  .sidebar-link {
    display: flex; align-items: center; gap: 10px;
    padding: 10px 12px; border-radius: 10px; text-decoration: none;
    color: var(--text); font-size: .9rem; font-weight: 500; transition: all .2s;
    margin-bottom: 2px;
  }
  .sidebar-link:hover, .sidebar-link.active { background: var(--blue-light); color: var(--blue); }
  .main-content { flex: 1; padding: 40px 48px; }
  .welcome-bar { margin-bottom: 32px; }
  .welcome-bar h2 { font-family: 'Syne', sans-serif; font-size: 1.8rem; font-weight: 800; }
  .welcome-bar p { color: var(--muted); margin-top: 4px; }

  .stats-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px,1fr)); gap: 20px; margin-bottom: 36px; }
  .stat-card {
    background: white; border-radius: 16px; padding: 24px;
    box-shadow: var(--card-shadow); display: flex; align-items: center; gap: 16px;
  }
  .stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
  .stat-card .num { font-family: 'Syne', sans-serif; font-size: 1.7rem; font-weight: 800; }
  .stat-card .lbl { font-size: .82rem; color: var(--muted); margin-top: 2px; }

  .section-title { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 1.1rem; margin-bottom: 16px; }
  .data-table { width: 100%; border-collapse: collapse; background: white; border-radius: 16px; overflow: hidden; box-shadow: var(--card-shadow); }
  .data-table th { background: #f8faff; padding: 14px 18px; text-align: left; font-size: .78rem; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: .06em; border-bottom: 1px solid #f3f4f6; }
  .data-table td { padding: 14px 18px; font-size: .9rem; border-bottom: 1px solid #f9fafb; }
  .data-table tr:last-child td { border-bottom: none; }
  .data-table tr:hover td { background: #f8faff; }
  .status-badge { padding: 4px 12px; border-radius: 50px; font-size: .75rem; font-weight: 600; }
  .status-pending   { background: #fef3c7; color: #92400e; }
  .status-confirmed { background: #dcfce7; color: #166534; }
  .status-cancelled { background: #fee2e2; color: #991b1b; }
  .status-completed { background: #dbeafe; color: #1e40af; }
  @media(max-width:900px){ .sidebar{display:none;} .main-content{padding:24px 20px;} }
</style>
</head>
<body>

<%@ include file="../nav.jsp" %>

<div class="admin-layout">
  <!-- Sidebar -->
  <aside class="sidebar">
    <div class="sidebar-label">Main</div>
    <a href="dashboard.jsp" class="sidebar-link active">
      <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
      Dashboard
    </a>

    <div class="sidebar-label">Management</div>
    <a href="manage-cars.jsp" class="sidebar-link">
      <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24"><path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99z"/></svg>
      Manage Cars
    </a>
    <a href="manage-bookings.jsp" class="sidebar-link">
      <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
      Bookings
    </a>
    <a href="manage-users.jsp" class="sidebar-link">
      <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
      Users
    </a>
    <a href="view-feedback.jsp" class="sidebar-link">
      <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
      Feedback
    </a>

    <div class="sidebar-label">Account</div>
    <a href="../LogoutServlet" class="sidebar-link" style="color:var(--danger)">
      <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
      Logout
    </a>
  </aside>

  <!-- Main -->
  <main class="main-content">
    <div class="welcome-bar">
      <h2>Good day, <%= loggedUser.getFullName() %> 👋</h2>
      <p>Here's what's happening with CarRental today</p>
    </div>

    <!-- Stats -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon" style="background:#dbeafe">
          <svg width="22" height="22" fill="none" stroke="#2563eb" stroke-width="2" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/></svg>
        </div>
        <div><div class="num"><%= totalBookings %></div><div class="lbl">Total Bookings</div></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background:#dcfce7">
          <svg width="22" height="22" fill="none" stroke="#16a34a" stroke-width="2" viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
        </div>
        <div><div class="num"><%= activeBookings %></div><div class="lbl">Active Bookings</div></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background:#fef3c7">
          <svg width="22" height="22" fill="#f59e0b" viewBox="0 0 24 24"><path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99z"/></svg>
        </div>
        <div><div class="num"><%= totalCars %></div><div class="lbl">Total Cars</div></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background:#f3e8ff">
          <svg width="22" height="22" fill="none" stroke="#9333ea" stroke-width="2" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
        </div>
        <div><div class="num"><%= totalUsers %></div><div class="lbl">Registered Users</div></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background:#dcfce7">
          <svg width="22" height="22" fill="none" stroke="#16a34a" stroke-width="2" viewBox="0 0 24 24"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
        </div>
        <div>
          <div class="num">₹<%= String.format("%.0f", totalRevenue) %></div>
          <div class="lbl">Total Revenue</div>
        </div>
      </div>
    </div>

    <!-- Recent Bookings Table -->
    <div class="section-title">Recent Bookings</div>
    <table class="data-table">
      <thead>
        <tr>
          <th>#ID</th><th>Customer</th><th>Car</th><th>Pickup</th><th>Return</th><th>Amount</th><th>Status</th><th>Action</th>
        </tr>
      </thead>
      <tbody>
        <% if (recentBookings != null && !recentBookings.isEmpty()) {
             for (Booking b : recentBookings) { %>
        <tr>
          <td>#<%= b.getBookingId() %></td>
          <td><strong><%= b.getUserName() %></strong><br><span style="font-size:.78rem;color:var(--muted)"><%= b.getUserEmail() %></span></td>
          <td><%= b.getCarName() %></td>
          <td><%= b.getPickupDate() %></td>
          <td><%= b.getReturnDate() %></td>
          <td><strong>₹<%= b.getTotalAmount() %></strong></td>
          <td>
            <span class="status-badge status-<%= b.getStatus().toLowerCase() %>"><%= b.getStatus() %></span>
          </td>
          <td>
            <form action="UpdateBookingStatusServlet" method="post" style="display:inline">
              <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
              <select name="status" onchange="this.form.submit()" style="font-size:.8rem;padding:4px 8px;border:1px solid #e5e7eb;border-radius:6px;outline:none">
                <option value="Pending"   <%= "Pending".equals(b.getStatus())   ? "selected" : "" %>>Pending</option>
                <option value="Confirmed" <%= "Confirmed".equals(b.getStatus()) ? "selected" : "" %>>Confirmed</option>
                <option value="Completed" <%= "Completed".equals(b.getStatus()) ? "selected" : "" %>>Completed</option>
                <option value="Cancelled" <%= "Cancelled".equals(b.getStatus()) ? "selected" : "" %>>Cancelled</option>
              </select>
            </form>
          </td>
        </tr>
        <% } } else { %>
          <tr><td colspan="8" style="text-align:center;color:var(--muted);padding:32px">No bookings yet.</td></tr>
        <% } %>
      </tbody>
    </table>
  </main>
</div>

<script src="../js/common.js"></script>
</body>
</html>
