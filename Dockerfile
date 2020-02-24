FROM java:8-jre

ADD ./target/auth-jwt.jar /app/
CMD ["java", "-Xmx200m", "-jar", "/app/auth-jwt.jar"]