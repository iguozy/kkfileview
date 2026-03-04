FROM maven:3.9.8-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
# 预安装无法从远程仓库下载的依赖
RUN mvn install:install-file -Dfile=lib/aspose-cad-23.9.jar -DgroupId=com.aspose -DartifactId=aspose-cad -Dversion=23.9 -Dpackaging=jar && \
    mvn install:install-file -Dfile=lib/jai_core-1.1.3.jar -DgroupId=javax.media -DartifactId=jai_core -Dversion=1.1.3 -Dpackaging=jar && \
    mvn install:install-file -Dfile=lib/jai_codec-1.1.3.jar -DgroupId=javax.media -DartifactId=jai_codec -Dversion=1.1.3 -Dpackaging=jar
RUN mvn -B -DskipTests -pl server -am clean package -s .mvn/settings.xml

FROM crpi-wj9nu4mw74znjcbt.cn-shenzhen.personal.cr.aliyuncs.com/resource-pool/aireach-resource:file-preview-base4.4.0
COPY --from=build /app/server/target/kkFileView-*.tar.gz /opt/
RUN cd /opt && tar -zxvf kkFileView-*.tar.gz && rm -f kkFileView-*.tar.gz
ENV KKFILEVIEW_BIN_FOLDER=/opt/kkFileView-4.4.0/bin
ENTRYPOINT ["java","-Dfile.encoding=UTF-8","-Dspring.config.location=/opt/kkFileView-4.4.0/config/application.properties","-jar","/opt/kkFileView-4.4.0/bin/kkFileView-4.4.0.jar"]
