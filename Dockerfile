FROM maven:3.9.8-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml ./
COPY server/pom.xml server/pom.xml
RUN mvn -B -DskipTests -pl server -am dependency:go-offline
COPY . .
RUN mvn -B -DskipTests -pl server -am clean package

FROM crpi-wj9nu4mw74znjcbt.cn-shenzhen.personal.cr.aliyuncs.com/resource-pool/aireach-resource:file-preview-base4.4.0
COPY --from=build /app/server/target/kkFileView-*.tar.gz /opt/
RUN cd /opt && tar -zxvf kkFileView-*.tar.gz && rm -f kkFileView-*.tar.gz
ENV KKFILEVIEW_BIN_FOLDER=/opt/kkFileView-4.4.0/bin
ENTRYPOINT ["java","-Dfile.encoding=UTF-8","-Dspring.config.location=/opt/kkFileView-4.4.0/config/application.properties","-jar","/opt/kkFileView-4.4.0/bin/kkFileView-4.4.0.jar"]
