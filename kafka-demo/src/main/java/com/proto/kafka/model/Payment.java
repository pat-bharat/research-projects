package com.proto.kafka.model;

public class Payment {
    private String id;
    private String type; // CREDIT, DEBIT, OUTBOUND
    private double amount;
    private String fromAccount;
    private String toAccount;

    public Payment(String id, String type, double amount, String fromAccount, String toAccount) {
        this.id = id;
        this.type = type;
        this.amount = amount;
        this.fromAccount = fromAccount;
        this.toAccount = toAccount;
    }

    public String getId() { return id; }
    public String getType() { return type; }
    public double getAmount() { return amount; }
    public String getFromAccount() { return fromAccount; }
    public String getToAccount() { return toAccount; }

    @Override
    public String toString() {
        return String.format("[%s] %s %.2f USD from %s → %s", id, type, amount, fromAccount, toAccount);
    }
}
