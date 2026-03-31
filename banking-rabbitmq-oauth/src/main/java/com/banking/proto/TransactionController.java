
package com.example.banking;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/tx")
public class TransactionController {
 private final RabbitTemplate rabbitTemplate;
 public TransactionController(RabbitTemplate rabbitTemplate) {
  this.rabbitTemplate = rabbitTemplate;
 }
 @PostMapping
 public String send(@RequestBody Transaction tx) {
  rabbitTemplate.convertAndSend(RabbitConfig.QUEUE, tx);
  return "Transaction queued";
 }
}
