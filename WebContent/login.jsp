<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  request.setAttribute("currentPage", "");
  String errorMsg   = (String) request.getAttribute("errorMsg");
  String successMsg = (String) request.getAttribute("successMsg");
  String redirect   = request.getParameter("redirect") != null ? request.getParameter("redirect") : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login – CarRental</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<style>
  .login-wrap {
    min-height: calc(100vh - 70px);
    display: grid; grid-template-columns: 1fr 1fr;
  }
  .login-left {
    background: linear-gradient(135deg, #1d4ed8 0%, #2563eb 50%, #3b82f6 100%);
    display: flex; flex-direction: column; align-items: center; justify-content: center;
    padding: 60px 48px; color: white;
  }
  .login-left h2 { font-family: 'Syne', sans-serif; font-size: 2.2rem; font-weight: 800; margin-top: 24px; }
  .login-left p  { opacity: .8; margin-top: 12px; font-size: 1rem; line-height: 1.6; }
  .feature-list  { list-style: none; margin-top: 32px; display: flex; flex-direction: column; gap: 14px; }
  .feature-list li { display: flex; align-items: center; gap: 12px; font-size: .95rem; }
  .feature-list li::before { content: '✓'; background: rgba(255,255,255,.2); width: 24px; height: 24px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: .8rem; flex-shrink: 0; }
  .login-right {
    display: flex; align-items: center; justify-content: center; padding: 40px 24px;
    background: var(--bg);
  }
  .tabs { display: flex; gap: 0; margin-bottom: 28px; border: 1.5px solid #e5e7eb; border-radius: 12px; overflow: hidden; }
  .tab-btn {
    flex: 1; padding: 11px; background: none; border: none; cursor: pointer;
    font-family: 'DM Sans', sans-serif; font-weight: 600; font-size: .9rem;
    color: var(--muted); transition: all .2s;
  }
  .tab-btn.active { background: var(--blue); color: white; }
  @media(max-width:768px){
    .login-wrap { grid-template-columns: 1fr; }
    .login-left { display: none; }
  }
</style>
</head>
<body>

<%@ include file="nav.jsp" %>

<div class="login-wrap">
  <!-- Left panel -->
  <div class="login-left">
    <svg width="56" height="56" viewBox="0 0 24 24" fill="rgba(255,255,255,.9)">
      <path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99z"/>
    </svg>
    <h2>Welcome Back!</h2>
    <p>Sign in to access your bookings,<br>manage reservations, and more.</p>
    <ul class="feature-list">
      <li>50+ premium vehicles</li>
      <li>Instant booking confirmation</li>
      <li>24/7 roadside assistance</li>
      <li>Flexible cancellation policy</li>
    </ul>
  </div>

  <!-- Right panel / form -->
  <div class="login-right">
    <div class="form-card fade-up" style="width:min(420px,100%)">
      <h2>Sign In</h2>
      <p class="sub">Enter your credentials to continue</p>

      <div class="tabs">
        <button class="tab-btn active" onclick="setRole('user', this)">User Login</button>
        <button class="tab-btn"       onclick="setRole('admin', this)">Admin Login</button>
      </div>

      <% if (errorMsg   != null) { %><div class="alert alert-error"><%= errorMsg %></div><% } %>
      <% if (successMsg != null) { %><div class="alert alert-success"><%= successMsg %></div><% } %>

      <form action="LoginServlet" method="post">
        <input type="hidden" name="role" id="login-role" value="user">
        <input type="hidden" name="redirect" value="<%= redirect %>">

        <div class="form-group">
          <label>Email Address</label>
          <input type="email" name="email" placeholder="your@email.com" required autofocus>
        </div>

        <div class="form-group">
          <label>Password</label>
          <input type="password" name="password" placeholder="Your password" required>
        </div>

        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px">
          <label style="display:flex;align-items:center;gap:8px;font-size:.88rem;cursor:pointer">
            <input type="checkbox" name="rememberMe"> Remember me
          </label>
          <a href="forgot-password.jsp" style="color:var(--blue);font-size:.88rem;text-decoration:none">Forgot password?</a>
        </div>

        <button type="submit" class="form-submit">Sign In →</button>
      </form>

      <div class="form-footer">
        Don't have an account? <a href="register.jsp">Register here</a>
      </div>
    </div>
  </div>
</div>

<script src="js/common.js"></script>
<script>
function setRole(role, el) {
  document.getElementById('login-role').value = role;
  document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
  el.classList.add('active');
}
</script>
</body>
</html>
