package com.example.paypalvenmo.controller;

import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Map;

import com.example.paypalvenmo.store.StateStore;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.server.ServerWebExchange;

@Controller
public class OAuthController {

    @Value("${paypal.client-id}")
    private String clientId;

    @Value("${paypal.client-secret}")
    private String clientSecret;

    @Value("${paypal.mode}")
    private String mode;

    @Value("${paypal.oauth-url}")
    private String oauthUrl;

    @Value("${paypal.payout-url}")
    private String payoutUrl;

    @Value("${paypal.redirect-uri:http://localhost:8080/api/oauth/callback}")
    private String redirectUri;

    private final StateStore stateStore;
    private final WebClient webClient = WebClient.create();

    public OAuthController(StateStore stateStore) {
        this.stateStore = stateStore;
    }

    @GetMapping("/api/oauth/login")
    public URI login(@RequestParam(value = "nonce", required = false) String nonce) {
        // Generate and store state
        String state = stateStore.createState(nonce == null ? "" : nonce);

        // PayPal authorize endpoint (sandbox/live selection via domain)
        String authorizeEndpoint = mode != null && mode.equalsIgnoreCase("sandbox")
                ? "https://www.sandbox.paypal.com/connect" 
                : "https://www.paypal.com/connect";

        // Example authorize URL - adjust scopes per your app
        String url = String.format("%s?client_id=%s&response_type=code&scope=%s&redirect_uri=%s&state=%s",
                authorizeEndpoint, clientId, "openid profile email", redirectUri, state);

        return URI.create(url);
    }

    @GetMapping("/api/oauth/callback")
    public String callback(@RequestParam(name = "code", required = false) String code,
                           @RequestParam(name = "state", required = false) String state,
                           @RequestParam(name = "error", required = false) String error,
                           ServerWebExchange exchange) {
        if (error != null) {
            exchange.getResponse().setStatusCode(org.springframework.http.HttpStatus.BAD_REQUEST);
            return "redirect:/static/error.html";
        }
        if (!StringUtils.hasText(state) || !stateStore.exists(state)) {
            exchange.getResponse().setStatusCode(org.springframework.http.HttpStatus.FORBIDDEN);
            return "redirect:/static/error.html";
        }

        // consume state
       // String nonce = stateStore.consumeState(state);

        // Exchange code for tokens
        String tokenEndpoint = oauthUrl; // usually https://api-m.sandbox.paypal.com/v1/identity/openidconnect/tokenservice
        String auth = clientId + ":" + clientSecret;
        String basic = Base64.getEncoder().encodeToString(auth.getBytes(StandardCharsets.UTF_8));

         Map<?,?>  body = webClient.post()
            .uri(tokenEndpoint)
            .header("Authorization", "Basic " + basic)
            .contentType(MediaType.APPLICATION_FORM_URLENCODED)
            .body(BodyInserters.fromFormData("grant_type", "authorization_code")
                .with("code", code)
                .with("redirect_uri", redirectUri))
            .retrieve()
            .bodyToMono(Map.class)
            .block();

        // For demo, just redirect to success page
        return "redirect:/static/success.html";
    }
}
