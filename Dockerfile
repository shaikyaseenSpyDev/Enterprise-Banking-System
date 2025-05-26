FROM eclipse-temurin:21-jdk as builder

WORKDIR /app

COPY pom.xml .
COPY */pom.xml ./
RUN mkdir -p banking-config-server/src/main/java \
    banking-service-registry/src/main/java \
    banking-api-gateway/src/main/java \
    banking-user-service/src/main/java \
    banking-fund-transfer-service/src/main/java \
    banking-utility-payment-service/src/main/java \
    banking-core-service/src/main/java
RUN mvn -B dependency:go-offline

COPY . .
RUN mvn -B clean package -DskipTests

FROM eclipse-temurin:21-jre

WORKDIR /app

COPY --from=builder /app/banking-config-server/target/*.jar /app/config-server.jar
COPY --from=builder /app/banking-service-registry/target/*.jar /app/service-registry.jar
COPY --from=builder /app/banking-api-gateway/target/*.jar /app/api-gateway.jar
COPY --from=builder /app/banking-user-service/target/*.jar /app/user-service.jar
COPY --from=builder /app/banking-fund-transfer-service/target/*.jar /app/fund-transfer-service.jar
COPY --from=builder /app/banking-utility-payment-service/target/*.jar /app/utility-payment-service.jar
COPY --from=builder /app/banking-core-service/target/*.jar /app/core-banking-service.jar

EXPOSE 8090 8081 8082 8083 8084 8085 8092

CMD ["java", "-jar", "/app/config-server.jar"]
