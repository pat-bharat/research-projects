package com.example.kafka.exporter;

import com.google.gson.Gson;

import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.*;

public class SummaryExporter {

    private static final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
    private static final Gson gson = new Gson();

    public static void start(Map<String, Double> totals) {
        Runnable exporter = () -> {
            try (FileWriter writer = new FileWriter("summary.json", false)) {
                Summary summary = new Summary(
                        LocalDateTime.now().toString(),
                        totals.getOrDefault("CREDIT", 0.0),
                        totals.getOrDefault("DEBIT", 0.0),
                        totals.getOrDefault("OUTBOUND", 0.0)
                );
                gson.toJson(summary, writer);
                System.out.println("📤 Summary exported to summary.json at " + summary.timestamp);
            } catch (IOException e) { e.printStackTrace(); }
        };

        scheduler.scheduleAtFixedRate(exporter, 0, 60, TimeUnit.SECONDS);
    }

    private static class Summary {
        String timestamp;
        double totalCredit;
        double totalDebit;
        double totalOutbound;
        double netBalance;

        public Summary(String timestamp, double totalCredit, double totalDebit, double totalOutbound) {
            this.timestamp = timestamp;
            this.totalCredit = totalCredit;
            this.totalDebit = totalDebit;
            this.totalOutbound = totalOutbound;
            this.netBalance = totalCredit - (totalDebit + totalOutbound);
        }
    }
}
