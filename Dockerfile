FROM eclipse-temurin:11-jre
COPY target/bio*.jar app.jar
EXPOSE 8082
ENTRYPOINT ["java","-jar","app.jar"]