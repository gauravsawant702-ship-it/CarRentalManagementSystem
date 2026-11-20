<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.carrental.model.Car, com.carrental.dao.CarDAO" %>
<%
  request.setAttribute("currentPage", "cars");
  CarDAO carDAO = new CarDAO();
  List<Car> carList = carDAO.getAllCars();
  String location  = request.getParameter("location") != null ? request.getParameter("location") : "";
  String pickup    = request.getParameter("pickup")   != null ? request.getParameter("pickup")   : "";
  String returnDt  = request.getParameter("returnDate") != null ? request.getParameter("returnDate") : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Available Cars – CarRental</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<style>
  .cars-search {
    max-width: 600px; margin: 24px auto 0;
    display: flex; align-items: center;
    background: white; border-radius: 50px; padding: 12px 20px; gap: 10px;
    box-shadow: var(--card-shadow);
  }
  .cars-search input {
    flex: 1; border: none; background: transparent; outline: none;
    font-family: 'DM Sans', sans-serif; font-size: .95rem; color: var(--text);
  }
  .filter-bar {
    display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;
    padding: 20px 48px 0;
  }
  .filter-btn {
    background: white; border: 1.5px solid #e5e7eb;
    padding: 8px 18px; border-radius: 50px; cursor: pointer;
    font-family: 'DM Sans', sans-serif; font-weight: 500; font-size: .88rem;
    transition: all .2s; color: var(--text);
  }
  .filter-btn.active, .filter-btn:hover { background: var(--blue); color: white; border-color: var(--blue); }

  .cars-grid-wrap { padding: 32px 48px 80px; }
  .cars-count { font-weight: 600; margin-bottom: 24px; color: var(--muted); }
  .cars-grid {
    display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 28px;
  }
  .car-card {
    background: white; border-radius: var(--radius);
    overflow: hidden; box-shadow: var(--card-shadow);
    transition: transform .25s, box-shadow .25s; animation: fadeUp .5s ease both;
  }
  .car-card:hover { transform: translateY(-6px); box-shadow: 0 12px 40px rgba(0,0,0,0.13); }
  .car-img-wrap {
    position: relative; height: 210px; overflow: hidden;
    background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
  }
  .car-img-wrap img { width: 100%; height: 100%; object-fit: cover; transition: transform .4s; }
  .car-card:hover .car-img-wrap img { transform: scale(1.05); }
  .badge-available {
    position: absolute; top: 14px; left: 14px;
    background: var(--blue); color: white;
    font-size: .75rem; font-weight: 600; padding: 4px 12px; border-radius: 50px;
  }
  .badge-unavailable {
    position: absolute; top: 14px; left: 14px;
    background: #6b7280; color: white;
    font-size: .75rem; font-weight: 600; padding: 4px 12px; border-radius: 50px;
  }
  .price-tag {
    position: absolute; bottom: 14px; right: 14px;
    background: rgba(0,0,0,.75); color: white;
    font-family: 'Syne', sans-serif; font-weight: 700;
    font-size: 1rem; padding: 6px 14px; border-radius: 50px;
    backdrop-filter: blur(4px);
  }
  .price-tag span { font-size: .75rem; font-weight: 400; }
  .car-info { padding: 20px; }
  .car-name { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 1.15rem; }
  .car-sub { color: var(--muted); font-size: .85rem; margin-top: 2px; }
  .car-specs {
    display: flex; gap: 20px; margin-top: 14px;
    padding-top: 14px; border-top: 1px solid #f3f4f6;
  }
  .spec { display: flex; align-items: center; gap: 6px; font-size: .83rem; color: var(--muted); }
  .car-card-footer {
    padding: 0 20px 20px;
    display: flex; justify-content: space-between; align-items: center;
  }
  .btn-book {
    background: var(--blue); color: white; border: none;
    padding: 10px 22px; border-radius: 50px;
    font-family: 'DM Sans', sans-serif; font-weight: 600;
    font-size: .9rem; cursor: pointer; transition: background .2s;
    text-decoration: none;
  }
  .btn-book:hover { background: var(--blue-dark); }
  .btn-book:disabled { background: #d1d5db; cursor: not-allowed; }
  .no-results {
    grid-column: 1/-1; text-align: center;
    padding: 60px 0; color: var(--muted); font-size: 1.1rem;
  }
  @media(max-width:768px){ .cars-grid-wrap{padding:24px 20px 60px;} .filter-bar{padding:20px 20px 0;} }
</style>
</head>
<body>

<%@ include file="nav.jsp" %>

<div class="page-header">
  <h2>Available Cars</h2>
  <p>Browse our premium vehicles — transparent pricing, no hidden fees</p>
  <% if (!location.isEmpty()) { %>
    <div class="alert alert-info" style="max-width:500px;margin:16px auto 0">
      📍 Showing cars for <strong><%= location %></strong>
      <% if (!pickup.isEmpty()) { %> &nbsp;|&nbsp; 📅 <%= pickup %> → <%= returnDt %><% } %>
    </div>
  <% } %>
  <div class="cars-search">
    <svg width="18" height="18" fill="none" stroke="#9ca3af" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
    <input type="text" placeholder="Search by make, model, fuel type…" id="car-search-input" oninput="filterCars()">
  </div>
</div>

<div class="filter-bar">
  <button class="filter-btn active" onclick="setFilter('all', this)">All</button>
  <button class="filter-btn" onclick="setFilter('available', this)">Available</button>
  <button class="filter-btn" onclick="setFilter('Automatic', this)">Automatic</button>
  <button class="filter-btn" onclick="setFilter('Manual', this)">Manual</button>
  <button class="filter-btn" onclick="setFilter('Electric', this)">Electric</button>
  <button class="filter-btn" onclick="setFilter('Hybrid', this)">Hybrid</button>
</div>

<div class="cars-grid-wrap">
  <div class="cars-count" id="cars-count"></div>
  <div class="cars-grid" id="cars-grid">

    <%-- Render from DB --%>
    <% if (carList == null || carList.isEmpty()) { %>
      <div class="no-results">No cars available at the moment.</div>
    <% } else {
        for (Car car : carList) { %>
      <div class="car-card"
           data-name="<%= car.getName().toLowerCase() %>"
           data-fuel="<%= car.getFuelType().toLowerCase() %>"
           data-trans="<%= car.getTransmission().toLowerCase() %>"
           data-avail="<%= car.isAvailable() ? "available" : "unavailable" %>">
        <div class="car-img-wrap">
          <img src="<%= car.getImageUrl() %>" alt="<%= car.getName() %>"
               loading="lazy"
               onerror="this.src='https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=800&q=80'">
          <span class="<%= car.isAvailable() ? "badge-available" : "badge-unavailable" %>">
            <%= car.isAvailable() ? "Available Now" : "Unavailable" %>
          </span>
          <div class="price-tag">₹<%= car.getPricePerDay() %><span>/day</span></div>
        </div>
        <div class="car-info">
          <div class="car-name"><%= car.getName() %></div>
          <div class="car-sub"><%= car.getCategory() %> &bull; <%= car.getYear() %></div>
          <div class="car-specs">
            <div class="spec">
              <svg width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
              <%= car.getSeats() %> Seats
            </div>
            <div class="spec">
              <svg width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M3 3h2l.4 2M7 13h10l4-8H5.4"/></svg>
              <%= car.getFuelType() %>
            </div>
            <div class="spec">
              <svg width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
              <%= car.getTransmission() %>
            </div>
          </div>
        </div>
        <div class="car-card-footer">
          <span style="font-family:'Syne',sans-serif;font-weight:700;color:var(--blue);font-size:1.1rem">
            ₹<%= car.getPricePerDay() %><span style="font-weight:400;font-size:.8rem;color:var(--muted)">/day</span>
          </span>
          <% if (car.isAvailable()) { %>
            <a href="booking.jsp?carId=<%= car.getCarId() %>&pickup=<%= pickup %>&returnDate=<%= returnDt %>&location=<%= java.net.URLEncoder.encode(location,"UTF-8") %>"
               class="btn-book">Book Now</a>
          <% } else { %>
            <button class="btn-book" disabled>Unavailable</button>
          <% } %>
        </div>
      </div>
    <% } } %>

  </div>
</div>

<script src="js/common.js"></script>
<script>
let activeFilter = 'all';

function setFilter(f, el) {
  activeFilter = f;
  document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
  el.classList.add('active');
  applyFilters();
}

function filterCars() { applyFilters(); }

function applyFilters() {
  const q = document.getElementById('car-search-input').value.toLowerCase();
  const cards = document.querySelectorAll('.car-card');
  let visible = 0;
  cards.forEach(card => {
    const matchSearch = !q ||
      card.dataset.name.includes(q) ||
      card.dataset.fuel.includes(q) ||
      card.dataset.trans.includes(q);
    const matchFilter = activeFilter === 'all' ||
      card.dataset.avail === activeFilter ||
      card.dataset.fuel === activeFilter.toLowerCase() ||
      card.dataset.trans === activeFilter.toLowerCase();
    const show = matchSearch && matchFilter;
    card.style.display = show ? '' : 'none';
    if (show) visible++;
  });
  document.getElementById('cars-count').textContent = `Showing ${visible} Car${visible !== 1 ? 's' : ''}`;
}

// init count
document.addEventListener('DOMContentLoaded', () => {
  const total = document.querySelectorAll('.car-card').length;
  document.getElementById('cars-count').textContent = `Showing ${total} Cars`;
});
</script>
</body>
</html>
