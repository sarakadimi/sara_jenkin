# Start with a base image containing Java runtime
FROM maven:3.5.2-jdk-8-alpine AS MAVEN_BUILD

COPY pom.xml /build/
COPY src /build/src/

WORKDIR /build/

RUN mvn package

FROM openjdk:8-jre-alpine


# Add Maintainer Info
LABEL maintainer="sara37@outlook.fr"

# Add a volume pointing to /tmp
VOLUME /tmp

# Make port 8080 available to the world outside this container
EXPOSE 8082

# The application's jar file
ARG JAR_FILE=/build/target/spring-petclinic-2.3.1.BUILD-SNAPSHOT.jar

# Add the application's jar to the container
ADD ${JAR_FILE} spring-petclinic-prod.jar

# Run the jar file
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/spring-petclinic-prod.jar"]
