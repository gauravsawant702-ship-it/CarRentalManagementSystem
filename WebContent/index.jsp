<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("currentPage", "home"); %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CarRental – Luxury Cars on Rent</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<style>
  .hero {
    min-height: calc(100vh - 70px);
    display: flex; flex-direction: column;
    align-items: center; justify-content: center;
    padding: 60px 24px 0; position: relative; overflow: hidden;
  }
  .hero-badge {
    background: var(--blue-light); color: var(--blue);
    font-size: .8rem; font-weight: 700; letter-spacing: .08em;
    text-transform: uppercase; padding: 6px 16px; border-radius: 50px;
    margin-bottom: 20px; animation: fadeUp .5s ease both;
  }
  .hero h1 {
    font-family: 'Syne', sans-serif;
    font-size: clamp(2.4rem, 6vw, 4.2rem);
    font-weight: 800; text-align: center; line-height: 1.15;
    animation: fadeUp .6s .05s ease both;
  }
  .hero h1 span { color: var(--blue); }
  .hero-sub {
    color: var(--muted); font-size: 1.1rem; text-align: center;
    max-width: 480px; margin-top: 16px;
    animation: fadeUp .6s .1s ease both;
  }
  .search-widget {
    background: white; border-radius: 20px; padding: 24px 32px;
    display: flex; align-items: flex-end; gap: 28px;
    box-shadow: var(--card-shadow); margin-top: 36px;
    animation: fadeUp .6s .15s ease both;
  }
  .sw-field label {
    display: block; font-size: .72rem; font-weight: 700; color: var(--muted);
    text-transform: uppercase; letter-spacing: .07em; margin-bottom: 6px;
  }
  .sw-field select, .sw-field input[type="date"] {
    border: none; background: transparent; outline: none;
    font-family: 'DM Sans', sans-serif; font-size: 1rem;
    color: var(--text); cursor: pointer; min-width: 160px;
  }
  .sw-divider { width: 1px; height: 40px; background: #e5e7eb; flex-shrink: 0; }
  .btn-search {
    background: var(--blue); color: white; border: none;
    padding: 14px 28px; border-radius: 50px;
    font-family: 'DM Sans', sans-serif; font-weight: 600;
    font-size: 1rem; cursor: pointer; display: flex; align-items: center;
    gap: 8px; white-space: nowrap; transition: background .2s;
  }
  .btn-search:hover { background: var(--blue-dark); }

  .hero-car {
    width: min(720px, 90vw); margin-top: -20px;
    animation: fadeUp .8s .3s ease both;
    filter: drop-shadow(0 20px 40px rgba(0,0,0,0.12));
    border-radius: 24px; object-fit: cover; height: 340px;
  }

  /* Stats strip */
  .stats-strip {
    background: white; padding: 36px 48px;
    display: flex; justify-content: center; gap: 80px;
    box-shadow: 0 -1px 0 #e5e7eb;
  }
  .stat { text-align: center; }
  .stat-num {
    font-family: 'Syne', sans-serif; font-size: 2rem; font-weight: 800; color: var(--blue);
  }
  .stat-label { color: var(--muted); font-size: .85rem; margin-top: 4px; }
</style>
</head>
<body>

<%@ include file="nav.jsp" %>

<section class="hero">
  <div class="hero-badge">Premium Car Rental Service</div>
  <h1>Drive Your <span>Dream Car</span><br>Today</h1>
  <p class="hero-sub">Choose from our wide selection of luxury vehicles. Easy booking, transparent pricing.</p>

  <div class="search-widget">
    <div class="sw-field">
      <label>Pickup Location</label>
      <select id="pickup-location">
        <option value="">Select location</option>
        <option>Mumbai, MH</option>
        <option>Pune, MH</option>
        <option>Nashik, MH</option>
        <option>Aurangabad, MH</option>
        <option>Nagpur, MH</option>
        <option>New Delhi, DL</option>
        <option>Bangalore, KA</option>
      </select>
    </div>
    <div class="sw-divider"></div>
    <div class="sw-field">
      <label>Pick-up Date</label>
      <input type="date" id="pickup-date">
    </div>
    <div class="sw-divider"></div>
    <div class="sw-field">
      <label>Return Date</label>
      <input type="date" id="return-date">
    </div>
    <button class="btn-search" onclick="doSearch()">
      <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
      Search Cars
    </button>
  </div>

  <img class="hero-car"
    src="https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=900&q=85"
    alt="Luxury Car">
</section>

<div class="stats-strip">
  <div class="stat"><div class="stat-num">50+</div><div class="stat-label">Premium Cars</div></div>
  <div class="stat"><div class="stat-num">10K+</div><div class="stat-label">Happy Customers</div></div>
  <div class="stat"><div class="stat-num">15+</div><div class="stat-label">Cities Covered</div></div>
  <div class="stat"><div class="stat-num">24/7</div><div class="stat-label">Support</div></div>
</div>

<script src="js/common.js"></script>
<script>
function doSearch() {
  const loc = document.getElementById('pickup-location').value;
  const p   = document.getElementById('pickup-date').value;
  const r   = document.getElementById('return-date').value;
  if (!loc) { showToast('Please select a pickup location'); return; }
  if (!p)   { showToast('Please choose a pick-up date'); return; }
  if (!r)   { showToast('Please choose a return date'); return; }
  if (p >= r){ showToast('Return date must be after pickup'); return; }
  window.location.href = `cars.jsp?location=${encodeURIComponent(loc)}&pickup=${p}&returnDate=${r}`;
}
</script>
</body>
</html>
