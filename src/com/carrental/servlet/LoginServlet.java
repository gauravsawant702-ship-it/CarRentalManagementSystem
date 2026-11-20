package com.carrental.servlet;

import com.carrental.dao.UserDAO;
import com.carrental.model.User;
import com.carrental.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String role     = req.getParameter("role");     // "user" or "admin"
        String redirect = req.getParameter("redirect"); // optional post-login redirect

        // ── Basic validation ──────────────────────────────────────────────────
        if (email == null || email.trim().isEmpty() ||
            password == null || password.isEmpty()) {
            req.setAttribute("errorMsg", "Email and password are required.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email.trim().toLowerCase());

        // ── Check credentials ─────────────────────────────────────────────────
        if (user == null ||
            !PasswordUtil.verify(password, user.getPasswordHash(), user.getPasswordSalt())) {
            req.setAttribute("errorMsg", "Invalid email or password. Please try again.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        // ── Role mismatch check ───────────────────────────────────────────────
        if (role != null && !role.equals(user.getRole())) {
            req.setAttribute("errorMsg",
                "No " + role + " account found with this email. Try the other login tab.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        // ── Success: create session ───────────────────────────────────────────
        HttpSession session = req.getSession(true);
        session.setAttribute("loggedUser", user);
        session.setMaxInactiveInterval(60 * 60); // 1 hour

        // Remember-me cookie (optional, 7-day)
        String rememberMe = req.getParameter("rememberMe");
        if ("on".equals(rememberMe)) {
            Cookie cookie = new Cookie("carrental_email", email);
            cookie.setMaxAge(7 * 24 * 60 * 60);
            cookie.setPath("/");
            resp.addCookie(cookie);
        }

        // ── Redirect ──────────────────────────────────────────────────────────
        if ("admin".equals(user.getRole())) {
            resp.sendRedirect("admin/dashboard.jsp");
        } else if (redirect != null && !redirect.isEmpty()) {
            resp.sendRedirect(redirect + ".jsp");
        } else {
            resp.sendRedirect("index.jsp");
        }
    }
}
