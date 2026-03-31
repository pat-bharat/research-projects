package com.proto.kafka.consumer;

import com.google.gson.Gson;
import com.proto.kafka.config.AppConfig;
import com.proto.kafka.db.EventDatabase;
import com.proto.kafka.model.Payment;

import org.apache.kafka.clients.consumer.*;
import org.apache.kafka.common.serialization.StringDeserializer;

import java.time.Duration;
import java.util.*;
import java.util.regex.Pattern;

public class PaymentDebitConsumer {
    public static void main(String[] args) {
        Properties props = new Properties();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, AppConfig.BOOTSTRAP_SERVERS);
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        props.put(ConsumerConfig.GROUP_ID_CONFIG, AppConfig.GROUP_ID);
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");

        KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);
        consumer.subscribe(Pattern.compile("payments.inbound.debit"));

        Gson gson = new Gson();
        System.out.println("👂 Listening on all payment debits...");

        while (true) {
            ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(1000));
            for (ConsumerRecord<String, String> record : records) {
                Payment payment = gson.fromJson(record.value(), Payment.class);
                System.out.printf("Received..[Topic: %s | Partition: %d | Offset: %d]%nKey: %s%nValue: %s%n%n",
                        record.topic(), record.partition(), record.offset(), record.key(), record.value());
                EventDatabase.save(payment);
            }
        }
    }
}
