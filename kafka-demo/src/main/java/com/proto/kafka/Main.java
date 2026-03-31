package com.proto.kafka;

import com.proto.kafka.consumer.PaymentCreditConsumer;
import com.proto.kafka.consumer.PaymentDebitConsumer;
import com.proto.kafka.consumer.PaymentOutboundConsumer;
import com.proto.kafka.consumer.PaymentSummaryConsumer;
import com.proto.kafka.producer.PaymentProducer;
import com.proto.kafka.transform.EventTransformer;

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
