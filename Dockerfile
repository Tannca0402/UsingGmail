FROM tomcat:10.1

# Xóa các ứng dụng mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Tạo thư mục lưu database H2
RUN mkdir -p /app/data

# Tắt shutdown port của Tomcat
RUN sed -i 's/port="8005" shutdown="SHUTDOWN"/port="-1" shutdown="SHUTDOWN"/' /usr/local/tomcat/conf/server.xml

# Copy WAR đã build sẵn
COPY SQL-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Render sử dụng port này
EXPOSE 8080

# Chạy Tomcat
CMD ["catalina.sh", "run"]
