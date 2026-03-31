# Research Projects

This repository contains multiple sub-projects related to financial technology, messaging systems, and payment integrations. Below is a summary of each project in this workspace:

---

## banking-rabbitmq-oauth
A Spring Boot prototype for banking transactions using RabbitMQ for messaging and OAuth2 for authentication (Java 17). Provides a REST API for posting transactions with bearer token authentication.

- **Tech:** Spring Boot, RabbitMQ, OAuth2, Java 17
- **How to run:**
  - `mvn spring-boot:run`
- **API:**
  - `POST /api/tx` (requires Bearer token)

---

## kafka-demo
A demonstration project for working with Apache Kafka, including scripts for starting Kafka, creating/deleting topics, and running consumers. Useful for learning and testing Kafka-based event streaming and messaging.

- **Tech:** Apache Kafka, Java
- **How to run:**
  - See `scripts/start.bat`
  - for setup Instructions for starting Kafka, formatting logs, and creating topics are in the project README

---

## paypal-integration
### paypal-backend
A backend service for PayPal and Venmo payouts. Exposes an API to send Venmo payments. Requires PayPal sandbox credentials.

- **Tech:** Java, Spring Boot
- **How to run:**
  - Set `PAYPAL_CLIENT_ID` and `PAYPAL_CLIENT_SECRET` environment variables (sandbox)
  - `mvn clean package`
  - `java -jar target/pay-pal-venmo-0.0.1-SNAPSHOT.jar`
- **API:**
  - `POST /api/payouts/venmo` (send Venmo payout)

### paypal-frontend
A simple frontend for interacting with the PayPal backend service.

- **Tech:** JavaScript, React
- **How to run:**
  - See `frontend/README.md` for details

---

For more details, see each project's README file.
