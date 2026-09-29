FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy pom.xml trước để tận dụng Docker cache
COPY pom.xml .

# Tải dependency Maven
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build WAR
RUN mvn clean package -DskipTests


# ==============================
# Run Tomcat
# ==============================
FROM tomcat:11-jdk21-temurin

# Tạo thư mục chứa database H2
RUN mkdir -p /app/data

# Xóa các ứng dụng mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR sau khi Maven build xong
COPY --from=build /app/target/*.war \
     /usr/local/tomcat/webapps/ROOT.war

# Tomcat chạy port 8080
EXPOSE 8080

# Chạy Tomcat ở foreground
CMD ["catalina.sh", "run"]
