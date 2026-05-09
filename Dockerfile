# Stage 1: Build (Using an image that has Maven installed)
FROM maven:3.8.6-eclipse-temurin-8 AS build
WORKDIR /home/app
COPY . /home/app
RUN mvn -f /home/app/pom.xml clean package

# Stage 2: Run (Using the small JRE image for production)
FROM eclipse-temurin:8-jre-alpine
VOLUME /tmp
EXPOSE 8000
# Copy the jar from the "build" stage
COPY --from=build /home/app/target/*.jar app.jar
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar" ]
