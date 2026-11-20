package com.carrental.servlet;

import com.carrental.dao.FeedbackDAO;
import com.carrental.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String name      = req.getParameter("name");
        String email     = req.getParameter("email");
        String ratingStr = req.getParameter("rating");
        String category  = req.getParameter("category");
        String subject   = req.getParameter("subject");
        String message   = req.getParameter("message");
        String recommend = req.getParameter("recommend");

        // ── Validation ────────────────────────────────────────────────────────
        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("errorMsg", "Name is required.");
            req.getRequestDispatcher("feedback.jsp").forward(req, resp); return;
        }
        if (email == null || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            req.setAttribute("errorMsg", "Please enter a valid email.");
            req.getRequestDispatcher("feedback.jsp").forward(req, resp); return;
        }
        int rating = 0;
        try { rating = Integer.parseInt(ratingStr); } catch (Exception ignored) {}
        if (rating < 1 || rating > 5) {
            req.setAttribute("errorMsg", "Please select a star rating.");
            req.getRequestDispatcher("feedback.jsp").forward(req, resp); return;
        }
        if (message == null || message.trim().isEmpty()) {
            req.setAttribute("errorMsg", "Please enter your message.");
            req.getRequestDispatcher("feedback.jsp").forward(req, resp); return;
        }

        // ── Get logged-in user ID if available ────────────────────────────────
        HttpSession session = req.getSession(false);
        Integer userId = null;
        if (session != null) {
            User u = (User) session.getAttribute("loggedUser");
            if (u != null) userId = u.getUserId();
        }

        // ── Save ──────────────────────────────────────────────────────────────
        FeedbackDAO dao = new FeedbackDAO();
        boolean saved = dao.saveFeedback(
            name.trim(), email.trim(), rating,
            category  != null ? category.trim()  : "Other",
            subject   != null ? subject.trim()   : "",
            message.trim(),
            recommend != null ? recommend        : "",
            userId
        );

        if (saved) {
            req.setAttribute("successMsg",
                "✅ Thank you for your feedback, " + name.split(" ")[0] + "! We'll review it shortly.");
        } else {
            req.setAttribute("errorMsg", "Failed to submit feedback. Please try again.");
        }
        req.getRequestDispatcher("feedback.jsp").forward(req, resp);
    }
}
