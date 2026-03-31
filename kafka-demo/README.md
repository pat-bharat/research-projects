# Kafka Demo

## 1️⃣ Start Kafka

### Generate a Cluster UUID

```
$ KAFKA_CLUSTER_ID="$(bin/kafka-storage.sh random-uuid)"
```

### Format Log Directories

```
$ bin/windows/kafka-storage.bat format --standalone -t $KAFKA_CLUSTER_ID -c ../../config/server.properties
```

### Start the Kafka Server

```
$ bin/kafka-server-start.bat ../../config/server.properties
```

Once the Kafka server has successfully launched, you will have a basic Kafka environment running and ready to use.

## 2️⃣ Create Topics

```
kafka-topics.bat --create --topic payments.inbound.credit --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
kafka-topics.bat --create --topic payments.inbound.debit --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
kafka-topics.bat --create --topic payments.outbound --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
kafka-topics.bat --create --topic payments.summary --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1

kafka-topics.bat --delete --topic payments.inbound.credit --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
kafka-topics.bat --delete --topic payments.inbound.debit --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
kafka-topics.bat --delete --topic payments.outbound --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
```

## 3️⃣ Run the Consumer (Dashboard)

```
mvn exec:java -Dexec.mainClass="com.example.kafka.consumer.PaymentConsumer"
```

## 4️⃣ Run the Producer

```
mvn exec:java -Dexec.mainClass="com.example.kafka.producer.PaymentProducer"
```

## Metrics Endpoint

[http://localhost:8080/metrics](http://localhost:8080/metrics)
