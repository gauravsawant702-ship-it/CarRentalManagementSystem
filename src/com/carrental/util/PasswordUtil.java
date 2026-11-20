package com.carrental.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Simple SHA-256 + salt password hasher.
 * For production, prefer BCrypt (add bcrypt jar to WEB-INF/lib).
 */
public class PasswordUtil {

    private static final SecureRandom RANDOM = new SecureRandom();

    /** Generate a random 16-byte salt encoded as Base64. */
    public static String generateSalt() {
        byte[] salt = new byte[16];
        RANDOM.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }

    /** Hash password with salt using SHA-256. Returns Base64-encoded hash. */
    public static String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(Base64.getDecoder().decode(salt));
            byte[] hashed = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hashed);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available", e);
        }
    }

    /** Verify a plain password against stored hash + salt. */
    public static boolean verify(String plainPassword, String storedHash, String salt) {
        return hashPassword(plainPassword, salt).equals(storedHash);
    }
}
