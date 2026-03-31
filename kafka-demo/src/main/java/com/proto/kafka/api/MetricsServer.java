package com.example.kafka.api;

import com.example.kafka.ui.Dashboard;
import com.google.gson.Gson;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.Map;

public class MetricsServer {

    private static HttpServer server;
    private static final Gson gson = new Gson();

    public static void startServer() {
        try {
            server = HttpServer.create(new InetSocketAddress(8080), 0);
            server.createContext("/metrics", new MetricsHandler());
            server.createContext("/dashboard", new DashboardHandler());
            server.setExecutor(null);
            server.start();
            System.out.println("🌐 Metrics server running at:");
            System.out.println("   ➤ http://localhost:8080/metrics");
            System.out.println("   ➤ http://localhost:8080/dashboard");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    static class MetricsHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            if ("GET".equals(exchange.getRequestMethod())) {
                Map<String, Double> totals = Dashboard.getTotals();
                double netBalance = totals.get("CREDIT") - (totals.get("DEBIT") + totals.get("OUTBOUND"));
                String json = gson.toJson(Map.of(
                        "totalCredit", totals.get("CREDIT"),
                        "totalDebit", totals.get("DEBIT"),
                        "totalOutbound", totals.get("OUTBOUND"),
                        "netBalance", netBalance
                ));

                exchange.getResponseHeaders().set("Content-Type", "application/json");
                exchange.sendResponseHeaders(200, json.getBytes().length);
                try (OutputStream os = exchange.getResponseBody()) { os.write(json.getBytes()); }
            } else { exchange.sendResponseHeaders(405, -1); }
        }
    }

    static class DashboardHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            String html = """
                    <!DOCTYPE html>
                    <html lang="en">
                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Real-Time Payment Dashboard</title>
                        <style>
                            body { font-family: Arial, sans-serif; background-color: #101820; color: #FEE715; text-align: center; }
                            h1 { color: #FEE715; }
                            .card { display: inline-block; margin: 1rem; padding: 1rem 2rem; background: #1a1f2b; border-radius: 12px; box-shadow: 0 0 10px #444; }
                            .value { font-size: 1.8em; margin-top: .5rem; color: #00ffcc; }
                            canvas { margin-top: 2rem; background: #fff; border-radius: 12px; }
                        </style>
                    </head>
                    <body>
                        <h1>💳 Real-Time Payment Dashboard</h1>
                        <div id="metrics">
                            <div class="card"><div>CREDIT</div><div id="credit" class="value">$0.00</div></div>
                            <div class="card"><div>DEBIT</div><div id="debit" class="value">$0.00</div></div>
                            <div class="card"><div>OUTBOUND</div><div id="outbound" class="value">$0.00</div></div>
                            <div class="card"><div>NET BALANCE</div><div id="net" class="value">$0.00</div></div>
                        </div>
                        <canvas id="chart" width="600" height="300"></canvas>
                        <script>
                            const ctx = document.getElementById('chart').getContext('2d');
                            const chartData = { labels: [], net: [] };
                            function drawChart() {
                                ctx.clearRect(0, 0, 600, 300);
                                ctx.beginPath();
                                ctx.moveTo(0, 150);
                                ctx.strokeStyle = '#00ffcc';
                                ctx.lineWidth = 2;
                                let maxLen = chartData.net.length;
                                let scaleX = 600 / Math.max(maxLen, 1);
                                let scaleY = 0.02;
                                for (let i = 0; i < maxLen; i++) {
                                    let y = 150 - chartData.net[i] * scaleY;
                                    ctx.lineTo(i * scaleX, y);
                                }
                                ctx.stroke();
                            }
                            async function fetchMetrics() {
                                const res = await fetch('/metrics');
                                const data = await res.json();
                                document.getElementById('credit').innerText = '$' + data.totalCredit.toFixed(2);
                                document.getElementById('debit').innerText = '$' + data.totalDebit.toFixed(2);
                                document.getElementById('outbound').innerText = '$' + data.totalOutbound.toFixed(2);
                                document.getElementById('net').innerText = '$' + data.netBalance.toFixed(2);
                                chartData.net.push(data.netBalance);
                                if (chartData.net.length > 100) chartData.net.shift();
                                drawChart();
                            }
                            setInterval(fetchMetrics, 2000);
                            fetchMetrics();
                        </script>
                    </body>
                    </html>
                    """;

            exchange.getResponseHeaders().set("Content-Type", "text/html; charset=UTF-8");
            byte[] bytes = html.getBytes(StandardCharsets.UTF_8);
            exchange.sendResponseHeaders(200, bytes.length);
            try (OutputStream os = exchange.getResponseBody()) { os.write(bytes); }
        }
    }
}
