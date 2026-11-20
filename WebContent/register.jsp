<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  request.setAttribute("currentPage", "");
  String errorMsg   = (String) request.getAttribute("errorMsg");
  String successMsg = (String) request.getAttribute("successMsg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register – CarRental</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<style>
  .form-card { width: min(520px, 100%); }
  .strength-bar {
    height: 4px; border-radius: 4px; background: #e5e7eb;
    margin-top: 8px; overflow: hidden;
  }
  .strength-fill { height: 100%; border-radius: 4px; transition: width .3s, background .3s; width: 0; }
  .strength-label { font-size: .75rem; color: var(--muted); margin-top: 4px; }
</style>
</head>
<body>

<%@ include file="nav.jsp" %>

<div class="form-page">
  <div class="form-card fade-up">
    <h2>Create Account</h2>
    <p class="sub">Join CarRental – your first booking is waiting</p>

    <% if (errorMsg   != null) { %><div class="alert alert-error"><%= errorMsg %></div><% } %>
    <% if (successMsg != null) { %><div class="alert alert-success"><%= successMsg %></div><% } %>

    <form action="RegisterServlet" method="post" onsubmit="return validateRegister()">
      <input type="hidden" name="role" value="user">

      <div class="form-row">
        <div class="form-group">
          <label>First Name</label>
          <input type="text" name="firstName" placeholder="Rahul" required>
        </div>
        <div class="form-group">
          <label>Last Name</label>
          <input type="text" name="lastName" placeholder="Sharma" required>
        </div>
      </div>

      <div class="form-group">
        <label>Email Address</label>
        <input type="email" name="email" id="reg-email" placeholder="rahul@example.com" required>
      </div>

      <div class="form-group">
        <label>Phone Number</label>
        <input type="tel" name="phone" placeholder="10-digit mobile" maxlength="10" required>
      </div>

      <div class="form-group">
        <label>Date of Birth</label>
        <input type="date" name="dob" id="dob" required>
      </div>

      <div class="form-group">
        <label>Address</label>
        <textarea name="address" rows="2" placeholder="Your full address"></textarea>
      </div>

      <div class="form-group">
        <label>Driving License No.</label>
        <input type="text" name="licenseNo" placeholder="MH1220230012345">
      </div>

      <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" id="reg-pwd" placeholder="Min. 8 characters"
               required oninput="checkStrength(this.value)">
        <div class="strength-bar"><div class="strength-fill" id="strength-fill"></div></div>
        <div class="strength-label" id="strength-label"></div>
      </div>

      <div class="form-group">
        <label>Confirm Password</label>
        <input type="password" name="confirmPassword" id="reg-cpwd" placeholder="Re-enter password" required>
      </div>

      <button type="submit" class="form-submit">Create Account →</button>
    </form>

    <div class="form-footer">
      Already have an account? <a href="login.jsp">Sign in</a>
      &nbsp;|&nbsp; Are you an admin? <a href="admin-register.jsp">Admin Register</a>
    </div>
  </div>
</div>

<script src="js/common.js"></script>
<script>
function checkStrength(pwd) {
  const fill  = document.getElementById('strength-fill');
  const label = document.getElementById('strength-label');
  let score = 0;
  if (pwd.length >= 8)          score++;
  if (/[A-Z]/.test(pwd))        score++;
  if (/[0-9]/.test(pwd))        score++;
  if (/[^A-Za-z0-9]/.test(pwd)) score++;
  const levels = [
    { w:'0%',  bg:'#e5e7eb', lbl:'' },
    { w:'25%', bg:'#ef4444', lbl:'Weak' },
    { w:'50%', bg:'#f59e0b', lbl:'Fair' },
    { w:'75%', bg:'#3b82f6', lbl:'Good' },
    { w:'100%',bg:'#22c55e', lbl:'Strong' },
  ];
  fill.style.width      = levels[score].w;
  fill.style.background = levels[score].bg;
  label.textContent     = levels[score].lbl;
}

// max dob = 18 years ago
document.addEventListener('DOMContentLoaded', () => {
  const d = new Date();
  d.setFullYear(d.getFullYear() - 18);
  document.getElementById('dob').max = d.toISOString().split('T')[0];
});

function validateRegister() {
  const pwd  = document.getElementById('reg-pwd').value;
  const cpwd = document.getElementById('reg-cpwd').value;
  const phone = document.querySelector('[name="phone"]').value;
  if (pwd.length < 8)        { showToast('Password must be at least 8 characters'); return false; }
  if (pwd !== cpwd)          { showToast('Passwords do not match'); return false; }
  if (!/^[6-9]\d{9}$/.test(phone)) { showToast('Enter a valid 10-digit mobile number'); return false; }
  return true;
}
</script>
</body>
</html>
