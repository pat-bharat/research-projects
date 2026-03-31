package com.proto.kafka.db;

import java.util.ArrayList;
import java.util.List;

import com.proto.kafka.model.Payment;
import com.proto.kafka.ui.Dashboard;

public class EventDatabase {
    private static final List<Payment> paymentRecords = new ArrayList<>();

    public static void save(Payment payment) {
    	 paymentRecords.add(payment);
         Dashboard.update(payment.getType(), payment.getAmount());
         EventLogger.log(payment);
         System.out.println("💾 Saved Payment: " + payment);
    }

    public static void printAll() {
        System.out.println("\n===== 🧾 DATABASE CONTENTS =====");
        for (Payment p : paymentRecords) System.out.println(p);
        System.out.println("=================================\n");
    }
}
