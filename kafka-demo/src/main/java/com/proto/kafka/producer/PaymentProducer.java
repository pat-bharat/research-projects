package com.example.kafka.producer;

import com.example.kafka.config.AppConfig;
import com.example.kafka.model.Payment;
import com.google.gson.Gson;
import org.apache.kafka.clients.producer.*;
import org.apache.kafka.common.serialization.StringSerializer;

import java.util.Properties;
import java.util.Random;
import java.util.UUID;

public class PaymentProducer {

    private static final String[] TOPICS = {
        "payments.inbound.credit",
        "payments.inbound.debit",
        "payments.outbound"
    };

    public static void main(String[] args) {
        Properties props = new Properties();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, AppConfig.BOOTSTRAP_SERVERS);
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());

        KafkaProducer<String, String> producer = new KafkaProducer<>(props);
        Gson gson = new Gson();
        Random rand = new Random();

        System.out.println("🚀 Sending payments...");

        while (true) {
            String type = switch (rand.nextInt(3)) {
                case 0 -> "CREDIT";
                case 1 -> "DEBIT";
                default -> "OUTBOUND";
            };
            String topic = switch (type) {
                case "CREDIT" -> TOPICS[0];
                case "DEBIT" -> TOPICS[1];
                default -> TOPICS[2];
            };

            Payment payment = new Payment(
                    UUID.randomUUID().toString(),
                    type,
                    rand.nextDouble() * 1000,
                    "ACCT-" + (1000 + rand.nextInt(9000)),
                    "ACCT-" + (1000 + rand.nextInt(9000))
            );

            ProducerRecord<String, String> record = new ProducerRecord<>(topic, payment.getId(), gson.toJson(payment));
            producer.send(record, (metadata, exception) -> {
                if (exception != null) exception.printStackTrace();
                else System.out.println("📤 Sent to " + topic + ": " + payment);
            });

            try { Thread.sleep(1000); } catch (InterruptedException ignored) {}
        }
    }
}
