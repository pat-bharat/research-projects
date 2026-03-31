package com.example.paypalvenmo.store;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.UUID;

import org.springframework.stereotype.Component;

@Component
public class StateStore {

    private final Map<String, String> stateMap = new ConcurrentHashMap<>();

    public String createState(String nonce) {
        String state = UUID.randomUUID().toString();
        stateMap.put(state, nonce);
        return state;
    }

    public String consumeState(String state) {
        return stateMap.remove(state);
    }

    public boolean exists(String state) {
        return stateMap.containsKey(state);
    }
}
