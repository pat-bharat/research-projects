package com.proto.kafka.ui;

import com.google.common.util.concurrent.AtomicDouble;
import com.proto.kafka.api.MetricsServer;
import com.proto.kafka.exporter.SummaryExporter;

import java.util.HashMap;
import java.util.Map;


public class Dashboard {
    private static final AtomicDouble totalCredit = new AtomicDouble(0.0);
    private static final AtomicDouble totalDebit = new AtomicDouble(0.0);
    private static final AtomicDouble totalOutbound = new AtomicDouble(0.0);

    private static boolean exporterStarted = false;
    private static boolean apiStarted = false;

    public static synchronized void update(String type, double amount) {
        switch (type.toUpperCase()) {
            case "CREDIT" -> totalCredit.addAndGet(amount);
            case "DEBIT" -> totalDebit.addAndGet(amount);
            case "OUTBOUND" -> totalOutbound.addAndGet(amount);
        }

        if (!exporterStarted) {
            SummaryExporter.start(getTotals());
            exporterStarted = true;
        }

        if (!apiStarted) {
            MetricsServer.startServer();
            apiStarted = true;
        }

        render();
    }

    public static Map<String, Double> getTotals() {
        Map<String, Double> totals = new HashMap<>();
        totals.put("CREDIT", totalCredit.get());
        totals.put("DEBIT", totalDebit.get());
        totals.put("OUTBOUND", totalOutbound.get());
        return totals;
    }

    public static void render() {
        System.out.print("\033[H\033[2J");
        System.out.flush();
        System.out.println("==========================================");
        System.out.println("         💳 REAL-TIME PAYMENT DASHBOARD    ");
        System.out.println("==========================================");
        System.out.printf("Total CREDIT   : $%,.2f%n", totalCredit.get());
        System.out.printf("Total DEBIT    : $%,.2f%n", totalDebit.get());
        System.out.printf("Total OUTBOUND : $%,.2f%n", totalOutbound.get());
        System.out.println("------------------------------------------");
        System.out.printf("NET BALANCE    : $%,.2f%n",
                totalCredit.get() - (totalDebit.get() + totalOutbound.get()));
        System.out.println("==========================================\n");
    }
}
