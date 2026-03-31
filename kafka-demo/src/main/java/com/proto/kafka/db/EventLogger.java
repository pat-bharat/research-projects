package com.proto.kafka.db;

import java.io.FileWriter;
import java.io.IOException;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.List;

import com.proto.kafka.model.Payment;

public class EventLogger {
    private static final String FILE_PATH = "events.log";

    public static synchronized void log(Payment payment) {
        try (FileWriter writer = new FileWriter(FILE_PATH, true)) {
            writer.write(payment.toString() + "\n");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static List<String> loadEvents() {
        List<String> events = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) events.add(line);
        } catch (IOException e) { e.printStackTrace(); }
        return events;
    }
}
