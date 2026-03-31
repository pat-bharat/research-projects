package com.example.kafka.transform;

import java.util.Properties;

import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.KafkaStreams;
import org.apache.kafka.streams.StreamsBuilder;
import org.apache.kafka.streams.StreamsConfig;
import org.apache.kafka.streams.kstream.KStream;
import org.apache.kafka.streams.kstream.Produced;

import com.example.kafka.config.AppConfig;

public class EventTransformer {

	
	public static void main(String[] args) {
		
		// Configuration properties
        Properties props = new Properties();
        props.put(StreamsConfig.APPLICATION_ID_CONFIG, AppConfig.APPLICATION_ID_CONFIG);
        props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, AppConfig.BOOTSTRAP_SERVERS);
        props.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass());
        props.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.String().getClass());
		 // Build the stream topology
        StreamsBuilder builder = new StreamsBuilder();
        
     // Step 1️⃣ Create KStreams for each topic
        KStream<String, String> creditStream = builder.stream("payments.inbound.credit");
        KStream<String, String> debitStream = builder.stream("payments.inbound.debit");
        KStream<String, String> outboundStream = builder.stream("payments.outbound");

        // Step 2️⃣ Add source info to each stream
        KStream<String, String> credits = creditStream.mapValues(v -> "{\"source\":\"credits\",\"data\":" + v + "}");
        KStream<String, String> debits = debitStream.mapValues(v -> "{\"source\":\"debits\",\"data\":" + v + "}");
        KStream<String, String> outbounds = outboundStream.mapValues(v -> "{\"source\":\"outbound\",\"data\":" + v + "}");

        // Step 3️⃣ Merge them into one stream
        KStream<String, String> mergedStream = credits
                .merge(debits)
                .merge(outbounds);

        // Step 4️⃣ Send merged data to unified topic
        mergedStream.to("payments.summary", Produced.with(Serdes.String(), Serdes.String()));
        System.out.println("Merged***************"+ Serdes.String().toString());
        // Step 5️⃣ Build & start stream
        KafkaStreams streams = new KafkaStreams(builder.build(), props);
        streams.start();

        // Add shutdown hook for graceful exit
        Runtime.getRuntime().addShutdownHook(new Thread(streams::close));

        
        System.out.println("✅ Kafka Streams App Started...");
        System.out.println("Writing transformed events to: " + "payments.summary");

   	}

}
