package com.carrental.servlet;

import com.carrental.dao.BookingDAO;
import com.carrental.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/UpdateBookingStatusServlet")
public class UpdateBookingStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Admin guard
        HttpSession session = req.getSession(false);
        User admin = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (admin == null || !"admin".equals(admin.getRole())) {
            resp.sendRedirect("../login.jsp");
            return;
        }

        int    bookingId = 0;
        try { bookingId = Integer.parseInt(req.getParameter("bookingId")); } catch (Exception ignored) {}
        String status = req.getParameter("status");

        if (bookingId > 0 && status != null) {
            BookingDAO dao = new BookingDAO();
            dao.updateStatus(bookingId, status);
        }

        resp.sendRedirect("dashboard.jsp");
    }
}
