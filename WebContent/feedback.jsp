<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.carrental.model.User" %>
<%
  request.setAttribute("currentPage", "feedback");
  User loggedUser = (User) session.getAttribute("loggedUser");
  String successMsg = (String) request.getAttribute("successMsg");
  String errorMsg   = (String) request.getAttribute("errorMsg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Feedback – CarRental</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<style>
  .feedback-page { padding: 60px 24px 80px; display: flex; justify-content: center; gap: 40px; flex-wrap: wrap; align-items: flex-start; }
  .feedback-form-card { background: white; border-radius: 24px; padding: 40px; width: min(560px, 100%); box-shadow: var(--card-shadow); }
  .feedback-info { width: min(300px, 100%); }

  .stars { display: flex; gap: 8px; margin-bottom: 8px; }
  .star {
    font-size: 2rem; cursor: pointer; color: #d1d5db; transition: color .2s;
    user-select: none;
  }
  .star.active, .star:hover { color: #f59e0b; }

  .category-chips { display: flex; gap: 10px; flex-wrap: wrap; }
  .chip {
    padding: 7px 16px; border: 1.5px solid #e5e7eb; border-radius: 50px;
    cursor: pointer; font-size: .85rem; font-weight: 500; transition: all .2s;
    user-select: none;
  }
  .chip.selected, .chip:hover { background: var(--blue); color: white; border-color: var(--blue); }

  .info-card {
    background: white; border-radius: 20px; padding: 28px;
    box-shadow: var(--card-shadow); margin-bottom: 20px;
  }
  .info-card h3 { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 1.1rem; margin-bottom: 12px; }
  .contact-item { display: flex; gap: 12px; margin-bottom: 14px; align-items: flex-start; }
  .contact-icon {
    width: 36px; height: 36px; background: var(--blue-light); border-radius: 10px;
    display: flex; align-items: center; justify-content: center; flex-shrink: 0;
  }
  .contact-icon svg { color: var(--blue); }
  .contact-label { font-size: .8rem; color: var(--muted); }
  .contact-val   { font-weight: 600; font-size: .9rem; }
</style>
</head>
<body>

<%@ include file="nav.jsp" %>

<div class="page-header">
  <h2>We'd Love Your Feedback</h2>
  <p>Help us improve — your opinion matters to us</p>
</div>

<div class="feedback-page">

  <!-- Form -->
  <div class="feedback-form-card fade-up">
    <% if (successMsg != null) { %><div class="alert alert-success"><%= successMsg %></div><% } %>
    <% if (errorMsg   != null) { %><div class="alert alert-error"><%= errorMsg %></div><% } %>

    <form action="FeedbackServlet" method="post" onsubmit="return validateFeedback()">
      <input type="hidden" name="rating" id="rating-val" value="0">
      <input type="hidden" name="category" id="category-val" value="">

      <div class="form-group">
        <label>Your Name</label>
        <input type="text" name="name"
               value="<%= loggedUser != null ? loggedUser.getFullName() : "" %>"
               placeholder="Full name" required>
      </div>

      <div class="form-group">
        <label>Email</label>
        <input type="email" name="email"
               value="<%= loggedUser != null ? loggedUser.getEmail() : "" %>"
               placeholder="your@email.com" required>
      </div>

      <div class="form-group">
        <label>Overall Rating</label>
        <div class="stars" id="stars">
          <span class="star" onclick="setRating(1)" data-val="1">★</span>
          <span class="star" onclick="setRating(2)" data-val="2">★</span>
          <span class="star" onclick="setRating(3)" data-val="3">★</span>
          <span class="star" onclick="setRating(4)" data-val="4">★</span>
          <span class="star" onclick="setRating(5)" data-val="5">★</span>
        </div>
        <div id="rating-label" style="font-size:.85rem;color:var(--muted)">Click to rate</div>
      </div>

      <div class="form-group">
        <label>Feedback Category</label>
        <div class="category-chips">
          <span class="chip" onclick="setCategory('Car Quality', this)">Car Quality</span>
          <span class="chip" onclick="setCategory('Booking Process', this)">Booking Process</span>
          <span class="chip" onclick="setCategory('Customer Service', this)">Customer Service</span>
          <span class="chip" onclick="setCategory('Pricing', this)">Pricing</span>
          <span class="chip" onclick="setCategory('App/Website', this)">App/Website</span>
          <span class="chip" onclick="setCategory('Other', this)">Other</span>
        </div>
      </div>

      <div class="form-group">
        <label>Subject</label>
        <input type="text" name="subject" placeholder="Brief subject of your feedback">
      </div>

      <div class="form-group">
        <label>Your Message</label>
        <textarea name="message" rows="5" placeholder="Tell us about your experience — what went well and what could be improved?" required></textarea>
      </div>

      <div class="form-group">
        <label>Would you recommend us?</label>
        <div style="display:flex;gap:16px;margin-top:4px">
          <label style="display:flex;align-items:center;gap:8px;cursor:pointer;font-size:.95rem">
            <input type="radio" name="recommend" value="yes" style="accent-color:var(--blue)"> Yes, definitely
          </label>
          <label style="display:flex;align-items:center;gap:8px;cursor:pointer;font-size:.95rem">
            <input type="radio" name="recommend" value="maybe"> Maybe
          </label>
          <label style="display:flex;align-items:center;gap:8px;cursor:pointer;font-size:.95rem">
            <input type="radio" name="recommend" value="no"> Not at this time
          </label>
        </div>
      </div>

      <button type="submit" class="form-submit">Submit Feedback →</button>
    </form>
  </div>

  <!-- Info sidebar -->
  <div class="feedback-info">
    <div class="info-card">
      <h3>Contact Us Directly</h3>
      <div class="contact-item">
        <div class="contact-icon">
          <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12 19.79 19.79 0 0 1 1.57 3.18 2 2 0 0 1 3.55 1h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.91 8.5a16 16 0 0 0 5.09 5.09l.86-.86a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 20.92 15z"/></svg>
        </div>
        <div>
          <div class="contact-label">Phone</div>
          <div class="contact-val">+91 98765 43210</div>
        </div>
      </div>
      <div class="contact-item">
        <div class="contact-icon">
          <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
        </div>
        <div>
          <div class="contact-label">Email</div>
          <div class="contact-val">support@carrental.in</div>
        </div>
      </div>
    </div>

    <div class="info-card">
      <h3>Response Time</h3>
      <p style="color:var(--muted);font-size:.9rem;line-height:1.6">
        We typically respond to feedback within <strong>24 hours</strong> on business days.
        For urgent issues, please call our support line.
      </p>
    </div>
  </div>

</div>

<script src="js/common.js"></script>
<script>
const ratingLabels = ['', 'Poor', 'Fair', 'Good', 'Very Good', 'Excellent'];

function setRating(val) {
  document.getElementById('rating-val').value = val;
  document.getElementById('rating-label').textContent = ratingLabels[val];
  document.querySelectorAll('.star').forEach((s, i) => {
    s.classList.toggle('active', i < val);
  });
}

function setCategory(cat, el) {
  document.getElementById('category-val').value = cat;
  document.querySelectorAll('.chip').forEach(c => c.classList.remove('selected'));
  el.classList.add('selected');
}

function validateFeedback() {
  const rating = parseInt(document.getElementById('rating-val').value);
  if (rating === 0) { showToast('Please select a rating'); return false; }
  return true;
}
</script>
</body>
</html>
