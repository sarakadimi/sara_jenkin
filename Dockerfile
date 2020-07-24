FROM openjdk:11.0.5-jdk-slim as BUILDER
WORKDIR /petclinic
COPY .mvn /petclinic/.mvn
COPY pom.xml /petclinic/pom.xml
COPY mvnw /petclinic/mvnw
RUN chmod +x mvnw
RUN ./mvnw dependency:go-offline
COPY src /petclinic/src
RUN ./mvnw package -DskipTests
# Start with a base image containing Java runtime
FROM openjdk:11-jre-slim
COPY --from=BUILDER /petclinic/target/*.jar /spring-petclinic.jar
# Make port 8080 available to the world outside this container
EXPOSE 8082
# Run the jar file
ENTRYPOINT ["java","-jar","/spring-petclinic.jar"]
