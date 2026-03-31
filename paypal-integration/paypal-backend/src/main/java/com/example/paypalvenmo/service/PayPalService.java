package com.example.paypalvenmo.service;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Base64;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

@Service
public class PayPalService {

    @Value("${paypal.client-id}")
    private String clientId;

    @Value("${paypal.client-secret}")
    private String clientSecret;

    @Value("${paypal.oauth-url}")
    private String oauthUrl;

    @Value("${paypal.payout-url}")
    private String payoutUrl;

    private final WebClient webClient = WebClient.builder().build();

    private String cachedToken;
    private Instant tokenExpiry = Instant.EPOCH;

    public synchronized String getAccessToken() {
        if (cachedToken != null && Instant.now().isBefore(tokenExpiry.minusSeconds(30))) {
            return cachedToken;
        }
        String auth = clientId + ":" + clientSecret;
        String basic = Base64.getEncoder().encodeToString(auth.getBytes(StandardCharsets.UTF_8));

        Map<?,?> body = webClient.post()
                .uri(oauthUrl)
                .header("Authorization", "Basic " + basic)
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .body(BodyInserters.fromFormData("grant_type", "client_credentials"))
                .retrieve()
                .bodyToMono(Map.class)
                .block();

        if (body != null && body.get("access_token") != null) {
            cachedToken = body.get("access_token").toString();
            Object expiresInObj = body.getOrDefault("expires_in", 3300);
            int expiresIn;
            if (expiresInObj instanceof Integer) {
                expiresIn = (Integer) expiresInObj;
            } else if (expiresInObj instanceof String) {
                expiresIn = Integer.parseInt((String) expiresInObj);
            } else {
                expiresIn = 3300;
            }
            tokenExpiry = Instant.now().plusSeconds(expiresIn);
            return cachedToken;
        }
        throw new RuntimeException("Unable to acquire PayPal access token: " + body);
    }

    public Map sendPayout(String venmoHandle, String amount, String currency, String note) {
        String token = getAccessToken();

        Map payload = Map.of(
            "sender_batch_header", Map.of("sender_batch_id", "batch-" + System.currentTimeMillis()),
            "items", new Map[] {
                Map.of(
                    "recipient_type", "USER_HANDLE",
                    "receiver", venmoHandle,
                    "amount", Map.of("value", amount, "currency", currency),
                    "note", note,
                    "recipient_wallet", "VENMO"
                )
            }
        );

        Map<?, ?> response = webClient.post()
                .uri(payoutUrl)
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(payload)
                .retrieve()
                .bodyToMono(Map.class)
                .block();

        return response;
    }
}
