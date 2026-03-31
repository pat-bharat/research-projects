# Backend - pay-pal-venmo

Run backend:
- Set PAYPAL_CLIENT_ID and PAYPAL_CLIENT_SECRET environment variables (sandbox)
- mvn clean package
- java -jar target/pay-pal-venmo-0.0.1-SNAPSHOT.jar

API:
- POST /api/payouts/venmo
  body: { "handle": "@recipient", "amount": "5.00", "currency": "USD", "note":"Thanks" }
