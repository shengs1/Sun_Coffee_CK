package com.cafe.util;

import java.text.NumberFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public class FormatUtil {
    public static String formatVND(double amount) {
        NumberFormat fmt = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
        return fmt.format(amount);
    }

    public static String formatDateTime(LocalDateTime dt) {
        if (dt == null) return "";
        return dt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

    public static String formatDate(LocalDateTime dt) {
        if (dt == null) return "";
        return dt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    public static String formatOrderCode(int orderId, LocalDateTime createdAt) {
        LocalDateTime date = createdAt == null ? LocalDateTime.now() : createdAt;
        return "SC-" + date.format(DateTimeFormatter.ofPattern("ddMMyyyy")) + "-" + String.format("%04d", orderId);
    }

    public static String truncate(String text, int maxLen) {
        if (text == null) return "";
        return text.length() <= maxLen ? text : text.substring(0, maxLen) + "...";
    }
}
