RUN mvn dependency:go-offline

COPY src ./src

RUN mvn clean package -DskipTests


# =========================
# Stage 2: Run Tomcat 11
# =========================
FROM tomcat:11-jdk17-temurin

# Xóa web mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy file WAR vào Tomcat
COPY --from=build /app/target/SQL-1.0-SNAPSHOT.war \
    /usr/local/tomcat/webapps/ROOT.war

# Render sử dụng port 10000
RUN sed -i 's/port="8080"/port="10000"/' \
    /usr/local/tomcat/conf/server.xml

EXPOSE 10000

CMD ["catalina.sh", "run"]
