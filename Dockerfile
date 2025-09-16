FROM tomcat:10.1.46-jdk21-temurin-noble

COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]