# 🚗 CarRental System — JSP + MySQL

A full-stack car rental web application built with **Java Servlets**, **JSP**, and **MySQL**.

---

## 📁 Project Structure

```
CarRentalSystem/
├── WebContent/
│   ├── index.jsp               ← Home page (hero + search)
│   ├── cars.jsp                ← Car listing with filters
│   ├── booking.jsp             ← Booking form (login required)
│   ├── booking-success.jsp     ← Confirmation page
│   ├── my-bookings.jsp         ← User's booking history
│   ├── login.jsp               ← Login (user + admin tabs)
│   ├── register.jsp            ← User registration
│   ├── admin-register.jsp      ← Admin registration (auth code)
│   ├── feedback.jsp            ← Feedback / review form
│   ├── nav.jsp                 ← Shared navbar (include)
│   ├── css/style.css           ← Global styles
│   ├── js/common.js            ← Shared JS utilities
│   └── admin/
│       └── dashboard.jsp       ← Admin dashboard
│
├── src/com/carrental/
│   ├── model/
│   │   ├── User.java
│   │   ├── Car.java
│   │   └── Booking.java
│   ├── dao/
│   │   ├── UserDAO.java
│   │   ├── CarDAO.java
│   │   ├── BookingDAO.java
│   │   └── FeedbackDAO.java
│   ├── servlet/
│   │   ├── RegisterServlet.java
│   │   ├── LoginServlet.java
│   │   ├── LogoutServlet.java
│   │   ├── BookingServlet.java
│   │   ├── FeedbackServlet.java
│   │   └── UpdateBookingStatusServlet.java
│   └── util/
│       ├── DBConnection.java
│       └── PasswordUtil.java
│
└── database/
    └── schema.sql              ← MySQL schema + sample data
```

---

## ⚙️ Setup Instructions

### 1. Prerequisites
- **Java JDK 11+**
- **Apache Tomcat 9+**
- **MySQL 8+**
- **Eclipse IDE for Enterprise Java** (or IntelliJ IDEA Ultimate)

---

### 2. Database Setup

```sql
-- Open MySQL Workbench or run via terminal:
mysql -u root -p < database/schema.sql
```

Then open `src/com/carrental/util/DBConnection.java` and update:
```java
private static final String DB_URL  = "jdbc:mysql://localhost:3306/carrental_db";
private static final String DB_USER = "root";
private static final String DB_PASS = "your_mysql_password";
```

---

### 3. Add MySQL JDBC Driver

Download **mysql-connector-java-8.x.x.jar** from:
https://dev.mysql.com/downloads/connector/j/

Place it in: `WebContent/WEB-INF/lib/`

---

### 4. Import into Eclipse

1. File → Import → Existing Projects into Workspace
2. Select the `CarRentalSystem` folder
3. Right-click project → Build Path → Configure Build Path → Add JARs → select the MySQL connector
4. Right-click project → Properties → Project Facets → Enable "Dynamic Web Module" (4.0)

---

### 5. Deploy on Tomcat

1. Right-click project → Run As → Run on Server
2. Select your Tomcat installation
3. Open browser: `http://localhost:8080/CarRentalSystem/`

---

### 6. Create Admin Account

After running the schema, create a real admin using the registration page or manually insert via SQL:

```bash
# Run this small Java snippet to generate hash + salt for "Admin@1234":
# Or just register via: http://localhost:8080/CarRentalSystem/admin-register.jsp
# Auth code: ADMIN@2024SECRET  (change in RegisterServlet.java before deploying)
```

---

## 🔐 Default Credentials (after setup)

| Role  | Email                  | Password    |
|-------|------------------------|-------------|
| Admin | admin@carrental.com    | Admin@1234  |

> **Important:** Change the admin password and the `ADMIN_AUTH_CODE` in `RegisterServlet.java` before deploying!

---

## 🗺️ Page Flow

```
Home (index.jsp)
  └─ Search → Cars (cars.jsp)
               └─ Book Now → [Login required] → Booking (booking.jsp)
                                                    └─ Submit → BookingServlet
                                                                   └─ booking-success.jsp

Login (login.jsp) ←→ Register (register.jsp)
                  ←→ Admin Register (admin-register.jsp)

Admin Login → Admin Dashboard (admin/dashboard.jsp)
               ├─ Manage Cars
               ├─ Manage Bookings (update status)
               ├─ Manage Users
               └─ View Feedback

Feedback (feedback.jsp) → FeedbackServlet
```

---

## 💡 Additional Features You Can Add

| Feature | How |
|---------|-----|
| Email confirmation | Use JavaMail API + SMTP |
| Car image upload | Apache Commons FileUpload |
| Payment gateway | Razorpay / PayU Java SDK |
| PDF invoice | iText / Apache PDFBox |
| Forgot password | Token-based email reset |
| Car availability calendar | FullCalendar.js |
| Coupon / discount codes | Add `coupons` table + servlet |
| Google Maps pickup location | Google Maps JS API |

---

## 🛠️ Tech Stack

- **Frontend:** HTML5, CSS3, Vanilla JS, Google Fonts
- **Backend:** Java Servlets, JSP (Jakarta EE)
- **Database:** MySQL 8
- **Server:** Apache Tomcat 9
- **Security:** SHA-256 + salt password hashing, session management
