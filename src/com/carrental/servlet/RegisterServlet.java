package com.carrental.servlet;

import com.carrental.dao.UserDAO;
import com.carrental.model.User;
import com.carrental.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    // Change this secret before deploying!
    private static final String ADMIN_AUTH_CODE = "ADMIN@2024SECRET";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String role        = req.getParameter("role");          // "user" or "admin"
        String firstName   = req.getParameter("firstName");
        String lastName    = req.getParameter("lastName");
        String email       = req.getParameter("email");
        String phone       = req.getParameter("phone");
        String password    = req.getParameter("password");
        String confirmPwd  = req.getParameter("confirmPassword");
        String address     = req.getParameter("address");
        String licenseNo   = req.getParameter("licenseNo");
        String department  = req.getParameter("department");
        String dobStr      = req.getParameter("dob");
        String authCode    = req.getParameter("authCode");      // admin only

        String targetPage = "admin".equals(role) ? "admin-register.jsp" : "register.jsp";

        // ── Validation ────────────────────────────────────────────────────────
        if (firstName == null || firstName.trim().isEmpty()) {
            setError(req, "First name is required.");
            forward(req, resp, targetPage); return;
        }
        if (email == null || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            setError(req, "Please enter a valid email address.");
            forward(req, resp, targetPage); return;
        }
        if (phone == null || !phone.matches("^[6-9]\\d{9}$")) {
            setError(req, "Enter a valid 10-digit Indian mobile number.");
            forward(req, resp, targetPage); return;
        }
        if (password == null || password.length() < 8) {
            setError(req, "Password must be at least 8 characters.");
            forward(req, resp, targetPage); return;
        }
        if (!password.equals(confirmPwd)) {
            setError(req, "Passwords do not match.");
            forward(req, resp, targetPage); return;
        }

        // Admin-specific: check auth code
        if ("admin".equals(role)) {
            if (!ADMIN_AUTH_CODE.equals(authCode)) {
                setError(req, "Invalid admin authorization code.");
                forward(req, resp, targetPage); return;
            }
        }

        UserDAO userDAO = new UserDAO();

        // Check duplicate email
        if (userDAO.emailExists(email)) {
            setError(req, "An account with this email already exists. Please login.");
            forward(req, resp, targetPage); return;
        }

        // ── Build User ────────────────────────────────────────────────────────
        String salt = PasswordUtil.generateSalt();
        String hash = PasswordUtil.hashPassword(password, salt);

        User u = new User();
        u.setFirstName   (firstName.trim());
        u.setLastName    (lastName  != null ? lastName.trim() : "");
        u.setEmail       (email.trim().toLowerCase());
        u.setPhone       (phone.trim());
        u.setPasswordHash(hash);
        u.setPasswordSalt(salt);
        u.setRole        (role);
        u.setAddress     (address    != null ? address.trim()    : "");
        u.setLicenseNo   (licenseNo  != null ? licenseNo.trim()  : "");
        u.setDepartment  (department != null ? department.trim() : "");

        if (dobStr != null && !dobStr.isEmpty()) {
            try { u.setDob(Date.valueOf(dobStr)); } catch (Exception ignored) {}
        }

        int newId = userDAO.registerUser(u);
        if (newId > 0) {
            req.setAttribute("successMsg",
                "Account created successfully! You can now <a href='login.jsp'>login</a>.");
            forward(req, resp, targetPage);
        } else {
            setError(req, "Registration failed due to a server error. Please try again.");
            forward(req, resp, targetPage);
        }
    }

    private void setError(HttpServletRequest req, String msg) {
        req.setAttribute("errorMsg", msg);
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String page)
            throws ServletException, IOException {
        req.getRequestDispatcher(page).forward(req, resp);
    }
}
