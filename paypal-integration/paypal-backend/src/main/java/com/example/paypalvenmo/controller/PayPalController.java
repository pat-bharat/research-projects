package com.example.paypalvenmo.controller;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.paypalvenmo.service.PayPalService;

@RestController
public class PayPalController {

    private final PayPalService payPalService;

    public PayPalController(PayPalService payPalService) {
        this.payPalService = payPalService;
    }

    @PostMapping("/api/payouts/venmo")
    public ResponseEntity<?> payoutToVenmo(@RequestBody Map<String, Object> req) {
        String handle = (String) req.getOrDefault("handle", "@demo-user");
        String amount = req.getOrDefault("amount", "1.00").toString();
        String currency = req.getOrDefault("currency", "USD").toString();
        String note = req.getOrDefault("note", "Test payout").toString();

         Map<?,?>  resp = payPalService.sendPayout(handle, amount, currency, note);
        return ResponseEntity.ok(resp);
    }
}
