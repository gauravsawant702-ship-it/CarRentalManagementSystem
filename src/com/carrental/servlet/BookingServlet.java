package com.carrental.servlet;

import com.carrental.dao.BookingDAO;
import com.carrental.dao.CarDAO;
import com.carrental.model.Booking;
import com.carrental.model.Car;
import com.carrental.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // ── Session check ─────────────────────────────────────────────────────
        HttpSession session = req.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (loggedUser == null) {
            resp.sendRedirect("login.jsp?redirect=booking");
            return;
        }

        // ── Collect parameters ────────────────────────────────────────────────
        int    carId     = parseIntSafe(req.getParameter("carId"));
        int    userId    = loggedUser.getUserId();
        String firstName = req.getParameter("firstName");
        String lastName  = req.getParameter("lastName");
        String email     = req.getParameter("email");
        String phone     = req.getParameter("phone");
        String pickupStr = req.getParameter("pickupDate");
        String returnStr = req.getParameter("returnDate");
        String location  = req.getParameter("pickupLocation");
        String licenseNo = req.getParameter("licenseNo");
        String special   = req.getParameter("specialRequests");

        // ── Validate ──────────────────────────────────────────────────────────
        CarDAO carDAO = new CarDAO();
        Car car = carDAO.getCarById(carId);

        if (car == null || !car.isAvailable()) {
            req.setAttribute("errorMsg", "Selected car is not available.");
            req.getRequestDispatcher("booking.jsp?carId=" + carId).forward(req, resp);
            return;
        }
        if (firstName == null || firstName.trim().isEmpty()) {
            forwardWithError(req, resp, carId, "First name is required."); return;
        }
        if (phone == null || !phone.matches("^[6-9]\\d{9}$")) {
            forwardWithError(req, resp, carId, "Enter a valid 10-digit mobile number."); return;
        }
        if (licenseNo == null || licenseNo.trim().isEmpty()) {
            forwardWithError(req, resp, carId, "Driving license number is required."); return;
        }

        Date pickupDate, returnDate;
        try {
            pickupDate = Date.valueOf(pickupStr);
            returnDate = Date.valueOf(returnStr);
        } catch (Exception e) {
            forwardWithError(req, resp, carId, "Invalid date format."); return;
        }
        if (!returnDate.after(pickupDate)) {
            forwardWithError(req, resp, carId, "Return date must be after pickup date."); return;
        }

        // ── Calculate total ───────────────────────────────────────────────────
        long days  = (returnDate.getTime() - pickupDate.getTime()) / (1000L * 60 * 60 * 24);
        double total = days * car.getPricePerDay();

        // ── Build Booking ─────────────────────────────────────────────────────
        Booking booking = new Booking();
        booking.setUserId        (userId);
        booking.setCarId         (carId);
        booking.setFirstName     (firstName.trim());
        booking.setLastName      (lastName  != null ? lastName.trim()  : "");
        booking.setPhone         (phone.trim());
        booking.setLicenseNo     (licenseNo.trim());
        booking.setPickupDate    (pickupDate);
        booking.setReturnDate    (returnDate);
        booking.setPickupLocation(location);
        booking.setTotalAmount   (total);
        booking.setSpecialRequests(special != null ? special.trim() : "");

        // ── Persist ───────────────────────────────────────────────────────────
        BookingDAO bookingDAO = new BookingDAO();
        int bookingId = bookingDAO.createBooking(booking);

        if (bookingId > 0) {
            // Optionally mark car as unavailable during booking period
            // carDAO.updateAvailability(carId, false); // uncomment if needed

            req.setAttribute("successMsg",
                "🎉 Booking confirmed! Your Booking ID is <strong>#" + bookingId + "</strong>. " +
                "We'll send confirmation to " + email);
            req.getRequestDispatcher("booking-success.jsp").forward(req, resp);
        } else {
            forwardWithError(req, resp, carId, "Booking failed due to a server error. Please try again.");
        }
    }

    private void forwardWithError(HttpServletRequest req, HttpServletResponse resp,
                                   int carId, String msg)
            throws ServletException, IOException {
        req.setAttribute("errorMsg", msg);
        req.getRequestDispatcher("booking.jsp?carId=" + carId).forward(req, resp);
    }

    private int parseIntSafe(String s) {
        try { return Integer.parseInt(s); } catch (Exception e) { return 0; }
    }
}
