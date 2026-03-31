package com.example.paypalvenmo.controller;

import java.util.Collections;
import java.util.Map;

import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CsrfController {

    @GetMapping("/api/auth/csrf")
    public Map<String, String> csrf(CsrfToken token) {
        return Collections.singletonMap("token", token.getToken());
    }
}
