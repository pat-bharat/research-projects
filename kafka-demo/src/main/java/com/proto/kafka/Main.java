package com.example.kafka;

import com.example.kafka.consumer.PaymentConsumer;
import com.example.kafka.consumer.PaymentCreditConsumer;
import com.example.kafka.consumer.PaymentDebitConsumer;
import com.example.kafka.consumer.PaymentOutboundConsumer;
import com.example.kafka.consumer.PaymentSummaryConsumer;
import com.example.kafka.producer.PaymentProducer;
import com.example.kafka.transform.EventTransformer;

public class Main {
    public static void main(String[] args) {
        new Thread(() -> PaymentCreditConsumer.main(args)).start();
        new Thread(() -> PaymentDebitConsumer.main(args)).start();
        new Thread(() -> PaymentOutboundConsumer.main(args)).start();
        new Thread(() -> PaymentSummaryConsumer.main(args)).start();
        new Thread(() -> EventTransformer.main(args)).start();        
        new Thread(() -> PaymentProducer.main(args)).start();
    }
}
