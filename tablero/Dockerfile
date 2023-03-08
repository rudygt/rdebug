FROM eclipse-temurin:17-jdk-focal as BUILDER

COPY ./ /app

COPY pom.xml /app

WORKDIR /app

RUN chmod +x ./mvnw && ./mvnw clean package -Pproduction

FROM eclipse-temurin:17-jre

COPY --from=BUILDER /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
