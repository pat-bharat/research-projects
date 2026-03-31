# pay-pal-venmo

This project contains a Spring Boot backend and a simple React frontend (Vite) for PayPal Sandbox Venmo payouts demo.

Backend:
  - Port: 8080
  - Endpoint: POST /api/payouts/venmo
  - Set env vars: PAYPAL_CLIENT_ID, PAYPAL_CLIENT_SECRET

Frontend:
  - Vite dev server (npm run dev)
  - Calls backend at /api/payouts/venmo

Notes:
- This is for sandbox/testing only. Do NOT use production credentials here.
- Ensure your PayPal sandbox app supports Payouts and Venmo recipient; some accounts may need special permissions.
