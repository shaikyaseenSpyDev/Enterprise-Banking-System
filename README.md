MIT License

Copyright (c) 2024 Your Name

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

# My Enterprise Banking System

A robust enterprise banking platform built with Java Spring Boot microservices architecture. This system provides a comprehensive set of banking APIs for account management, fund transfers, and utility payments.

In this article series I’m going to explain using internet banking API concept with spring boot based microserices architecture. Initially I’ll develop the core API which will evolve as a full fledged REST API collection until deployments.

### Installation

1. Clone the repository:

```shell
$ git clone https://github.com/shaikyaseenSpyDev/Enterprise-Banking-System.git
```

2. Navigate to the docker-compose folder:

```shell
$ cd internet-banking-concept-microservices/docker-compose
```
3. Start application using docker-compose:

```shell
$ docker-compose up -d
```

#### Docker Containers

Container | IP | Port Mapping |
--- | --- | --- |
openzipkin_server | 172.25.0.12 | 9411
keycloak_web | 172.25.0.11 | 8080
keycloak_postgre_db | 172.25.0.10 | 5432(Closed Port)
mysql_javatodev_app | 172.25.0.9 | 3306
internet-banking-config-server | 172.25.0.8 | 8090
internet-banking-service-registry | 172.25.0.7 | 8081
internet-banking-api-gateway | 172.25.0.6 | 8082
internet-banking-user-service | 172.25.0.5 | 8083
internet-banking-fund-transfer-service | 172.25.0.4 | 8084
internet-banking-utility-payment-service | 172.25.0.3 | 8085
core-banking-service | 172.25.0.2 | 8092


#### Test Data

By default we have dummy accounts details with user details under core-banking-database. Also the keycloak instance will deployed with default dataset matched to the application with all the realm, client and user data sets.

Proceed the testings with `AUTHENTICATION` API request under BANKING_CORE_MICROSERVICES COLLECTION.

```
Test Credentials : im_admin@spydev.com / 5V7huE3G86uB
```

### Microservices Inside This Project

Here this project consist of mainly 6 microservices and those are,

- User service (banking-core-user-service) – This service includes all the operations under the User such as registrations and retrieval. Additionally, this API consumes keycloak REST API to register and manage the user base while using the local PostgreSQL database as well.
- Fund transfer service (banking-core-fund-transfer-service) – This is the service that handles all the fund transfers between accounts and this API will push messages to a centralized RabbitMQ queue to use from the Notification service.
- Payment service (banking-core-payments-service) – This service will include all the API endpoints to process Utility payments in this project and that will push notification messages to RabbitMQ as well.
- Notification service – This API is registered under the service registry but consumes all the messages from RabbitMQ and pushes necessary notifications to the end users. - PENDING Development
- Banking core service – This is the banking core service that acts as a dummy banking core with accounts, users, transaction details, and processors for banking transactions.

### Technology Stack

1. Java 21
2. Spring Boot 3.2.4
3. Spring Cloud 2023.0.0 
4. Netflix Eureka Service Registry
5. Netflix Eureka Service Client
6. Spring Cloud API Gateway
7. Spring Cloud Config Server
8. Zipkin
9. Spring Cloud Sleuth
10. Open Feign
11. RabbitMQ
12. Prometheus 
13. MySQL 
14. Keycloak 
15. Docker / Docker Compose 
16. Kubernetes 
17. Keycloak
<h1 align="center">Hi 👋, I'm Shaik Yaseen</h1>
<h3 align="center">A Passionate Java Fullstack Developer.</h3>