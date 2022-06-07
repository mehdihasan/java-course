FROM openjdk:17-jre
MAINTAINER mehdi <mail@mehdihasan.me>
ENTRYPOINT ["java", "-jar", "/usr/share/myapp/app.war"]
# Add Maven dependencies (not shaded into the artifact; Docker-cached)
# ADD target/lib           /usr/share/myapp/lib
# Add the service itself
ARG JAR_FILE
ADD ./target/${JAR_FILE} /usr/share/myapp/app.war