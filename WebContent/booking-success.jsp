<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  request.setAttribute("currentPage", "");
  String successMsg = (String) request.getAttribute("successMsg");
  if (successMsg == null) { response.sendRedirect("index.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Booking Confirmed – CarRental</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<style>
  .success-page {
    min-height: calc(100vh - 70px);
    display: flex; align-items: center; justify-content: center; padding: 40px 20px;
  }
  .success-card {
    background: white; border-radius: 24px; padding: 56px 44px;
    text-align: center; width: min(500px, 100%);
    box-shadow: var(--card-shadow); animation: scaleIn .4s ease;
  }
  @keyframes scaleIn { from{opacity:0;transform:scale(.95)} to{opacity:1;transform:scale(1)} }
  .check-circle {
    width: 80px; height: 80px; background: #dcfce7;
    border-radius: 50%; margin: 0 auto 24px;
    display: flex; align-items: center; justify-content: center;
    font-size: 2.2rem;
  }
  .success-card h2 { font-family: 'Syne', sans-serif; font-size: 2rem; font-weight: 800; margin-bottom: 12px; }
  .success-card p  { color: var(--muted); line-height: 1.7; font-size: .95rem; }
  .success-card p strong { color: var(--text); }
  .action-btns { display: flex; gap: 12px; justify-content: center; margin-top: 32px; flex-wrap: wrap; }
</style>
</head>
<body>
<%@ include file="nav.jsp" %>

<div class="success-page">
  <div class="success-card">
    <div class="check-circle">✅</div>
    <h2>Booking Confirmed!</h2>
    <p><%= successMsg %></p>
    <p style="margin-top:16px">Please carry a valid photo ID and your driving license at the time of pickup.</p>
    <div class="action-btns">
      <a href="my-bookings.jsp" class="btn-primary">View My Bookings</a>
      <a href="cars.jsp" class="btn-ghost">Browse More Cars</a>
    </div>
  </div>
</div>

<script src="js/common.js"></script>
</body>
</html>
