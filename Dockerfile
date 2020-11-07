FROM maven:3.6.3-jdk-8 AS build
WORKDIR /usr/src/app
COPY src ./src
COPY pom.xml .
RUN mvn clean package -DskipTests

FROM openjdk:8 AS deploy
WORKDIR /app
COPY --from=build /usr/src/app/target/java-training-*.war .
EXPOSE 8686
ENTRYPOINT ["java","-jar","/app/java-training-*.war"]
#CMD ["--spring.profiles.active=postgres"]



FROM openjdk:jre-alpine
VOLUME /tmp
ARG JAR_FILE
ENV _JAVA_OPTIONS "-Xms256m -Xmx512m -Djava.awt.headless=true"
COPY ${JAR_FILE} /opt/app.jar
RUN addgroup bootapp && \
    adduser -D -S -h /var/cache/bootapp -s /sbin/nologin -G bootapp bootapp
WORKDIR /opt
USER bootapp
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/opt/app.jar"]




FROM openjdk:8-jre
MAINTAINER mehdi <mail@mehdihasan.me>
ENTRYPOINT ["/usr/bin/java", "-jar", "/usr/share/myapp/app.war"]
# Add Maven dependencies (not shaded into the artifact; Docker-cached)
# ADD target/lib           /usr/share/myapp/lib
# Add the service itself
ARG JAR_FILE
ADD ${JAR_FILE} /usr/share/myapp/app.war