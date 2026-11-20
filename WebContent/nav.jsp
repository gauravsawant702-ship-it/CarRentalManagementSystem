<%-- nav.jsp — include this on every page --%>
<%@ page import="com.carrental.model.User" %>
<%
  User loggedUser = (User) session.getAttribute("loggedUser");
  String role = (loggedUser != null) ? loggedUser.getRole() : "";
  String currentPage = (String) request.getAttribute("currentPage");
%>
<nav>
  <a href="index.jsp" class="logo">
    <div class="logo-icon">
      <svg viewBox="0 0 24 24"><path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.85 7h10.29l1.08 3.11H5.77L6.85 7zM19 17H5v-5h14v5zm-2-2c0-.55-.45-1-1-1s-1 .45-1 1 .45 1 1 1 1-.45 1-1zm-8 0c0-.55-.45-1-1-1s-1 .45-1 1 .45 1 1 1 1-.45 1-1z"/></svg>
    </div>
    CarRental
  </a>

  <ul class="nav-links">
    <li><a href="index.jsp" class="<%= "home".equals(currentPage) ? "active" : "" %>">Home</a></li>
    <li><a href="cars.jsp" class="<%= "cars".equals(currentPage) ? "active" : "" %>">Cars</a></li>
    <% if (loggedUser != null) { %>
      <li><a href="my-bookings.jsp" class="<%= "bookings".equals(currentPage) ? "active" : "" %>">My Bookings</a></li>
    <% } %>
    <li><a href="feedback.jsp" class="<%= "feedback".equals(currentPage) ? "active" : "" %>">Feedback</a></li>
    <% if ("admin".equals(role)) { %>
      <li><a href="admin/dashboard.jsp" class="<%= "admin".equals(currentPage) ? "active" : "" %>">Admin</a></li>
    <% } %>
  </ul>

  <div class="nav-right">
    <% if (loggedUser != null) { %>
      <span style="font-size:.9rem;color:var(--muted)">Hello, <strong><%= loggedUser.getFullName() %></strong></span>
      <a href="LogoutServlet" class="btn-ghost">Logout</a>
    <% } else { %>
      <a href="login.jsp" class="btn-ghost">Login</a>
      <a href="register.jsp" class="btn-primary">Register</a>
    <% } %>
  </div>
</nav>
<div id="toast"></div>
