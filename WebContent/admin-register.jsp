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
<title>Admin Registration – CarRental</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<style>
  .admin-badge {
    display: inline-flex; align-items: center; gap: 8px;
    background: #fef3c7; color: #92400e; font-size: .8rem; font-weight: 700;
    padding: 6px 14px; border-radius: 50px; margin-bottom: 16px;
    letter-spacing: .05em; text-transform: uppercase;
  }
  .secret-note {
    background: #fffbeb; border: 1.5px solid #fde68a;
    border-radius: 10px; padding: 12px 16px; font-size: .85rem;
    color: #92400e; margin-bottom: 20px;
  }
</style>
</head>
<body>

<%@ include file="nav.jsp" %>

<div class="form-page">
  <div class="form-card fade-up">
    <div class="admin-badge">
      <svg width="14" height="14" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87L18.18 21 12 17.77 5.82 21 7 14.14l-5-4.87 6.91-1.01L12 2z"/></svg>
      Admin Portal
    </div>
    <h2>Admin Registration</h2>
    <p class="sub">Create an administrator account to manage the platform</p>

    <div class="secret-note">
      ⚠️ Admin registration requires an <strong>authorization code</strong> issued by the system owner.
    </div>

    <% if (errorMsg   != null) { %><div class="alert alert-error"><%= errorMsg %></div><% } %>
    <% if (successMsg != null) { %><div class="alert alert-success"><%= successMsg %></div><% } %>

    <form action="RegisterServlet" method="post" onsubmit="return validateAdminRegister()">
      <input type="hidden" name="role" value="admin">

      <div class="form-row">
        <div class="form-group">
          <label>First Name</label>
          <input type="text" name="firstName" placeholder="Admin" required>
        </div>
        <div class="form-group">
          <label>Last Name</label>
          <input type="text" name="lastName" placeholder="Name" required>
        </div>
      </div>

      <div class="form-group">
        <label>Official Email</label>
        <input type="email" name="email" placeholder="admin@carrental.com" required>
      </div>

      <div class="form-group">
        <label>Phone Number</label>
        <input type="tel" name="phone" placeholder="10-digit mobile" maxlength="10" required>
      </div>

      <div class="form-group">
        <label>Department / Role Title</label>
        <input type="text" name="department" placeholder="e.g. Operations Manager">
      </div>

      <div class="form-group">
        <label>Admin Authorization Code</label>
        <input type="password" name="authCode" placeholder="Provided by system owner" required>
        <small style="color:var(--muted);font-size:.78rem">Contact the system administrator to get this code.</small>
      </div>

      <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" id="admin-pwd" placeholder="Min. 8 characters" required>
      </div>

      <div class="form-group">
        <label>Confirm Password</label>
        <input type="password" name="confirmPassword" id="admin-cpwd" placeholder="Re-enter password" required>
      </div>

      <button type="submit" class="form-submit" style="background:#d97706">Register as Admin →</button>
    </form>

    <div class="form-footer">
      <a href="login.jsp">Back to Login</a>
      &nbsp;|&nbsp; <a href="register.jsp">User Registration</a>
    </div>
  </div>
</div>

<script src="js/common.js"></script>
<script>
function validateAdminRegister() {
  const pwd  = document.getElementById('admin-pwd').value;
  const cpwd = document.getElementById('admin-cpwd').value;
  const phone = document.querySelector('[name="phone"]').value;
  if (pwd.length < 8)               { showToast('Password must be at least 8 characters'); return false; }
  if (pwd !== cpwd)                  { showToast('Passwords do not match'); return false; }
  if (!/^[6-9]\d{9}$/.test(phone)) { showToast('Enter a valid 10-digit mobile number'); return false; }
  return true;
}
</script>
</body>
</html>
