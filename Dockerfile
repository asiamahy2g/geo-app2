FROM eclipse-temurin:11-jre

WORKDIR /app

# Run as an unprivileged user instead of root
RUN groupadd --system app && useradd --system --gid app --no-create-home app

COPY target/bio*.jar app.jar

USER app
EXPOSE 8082
ENTRYPOINT ["java", "-jar", "app.jar"]
