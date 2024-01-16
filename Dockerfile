FROM openjdk:11-jre

WORKDIR /root/
COPY /target/app.jar .

EXPOSE 8123
ENTRYPOINT ["java", "-jar", "./app.jar"]
