
package com.banking.proto;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

@Component
public class TransactionConsumer {
 @RabbitListener(queues = RabbitConfig.QUEUE)
 public void receive(Transaction tx) {
  System.out.println("Processed: " + tx.fromAccount + " -> " + tx.toAccount + " : " + tx.amount);
 }
}
