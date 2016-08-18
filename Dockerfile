FROM tomcat:8.5.4-jre8
RUN apt-get update
RUN apt-get install libcairo2-dev -y
RUN apt-get install libpng12-0 -y
RUN apt-get install libossp-uuid-dev -y
RUN apt-get install libfreerdp-dev -y
RUN apt-get install libpango1.0-dev -y
RUN apt-get install libssh2-1-dev -y
RUN apt-get install libtelnet-dev -y
RUN apt-get install libvncserver-dev -y
RUN apt-get install libpulse-dev -y
RUN apt-get install libssl-dev -y
RUN apt-get install libvorbis-dev -y
RUN apt-get install libwebp-dev -y
RUN apt-get install libjpeg62-turbo-dev -y
RUN apt-get install openjdk-8-jdk -y
RUN apt-get install maven git -y
RUN mkdir /compile && cd /compile && git clone https://github.com/apache/incubator-guacamole-client.git && cd /compile/incubator-guacamole-client && git checkout 414f4ca94280b8ceb6b45a8e0e06dd8c37077ee1 && mvn install
RUN mkdir -p /opt/guacamole/bin && cp /compile/incubator-guacamole-client/guacamole/target/guacamole-0.9.9-incubating.war /usr/local/tomcat/webapps/guacamole.war
RUN mkdir /opt/guacamole/mysql && mkdir /opt/guacamole/postgresql
RUN tar -xvzf /compile/incubator-guacamole-client/extensions/guacamole-auth-jdbc/target/guacamole-auth-jdbc-0.9.9-incubating.tar.gz -C /opt/guacamole/ --wildcards --no-anchored --strip-components=1 "*.sql"
RUN cp /compile/incubator-guacamole-client/extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-base/target/guacamole-auth-jdbc-base-0.9.9-incubating.jar /opt/guacamole
RUN cp /compile/incubator-guacamole-client/extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-mysql/target/guacamole-auth-jdbc-mysql-0.9.9-incubating.jar /opt/guacamole/mysql
RUN cp /compile/incubator-guacamole-client/extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-postgresql/target/guacamole-auth-jdbc-postgresql-0.9.9-incubating.jar /opt/guacamole/postgresql
RUN mkdir /opt/guacamole/ldap && cd /opt/guacamole/ldap && tar -xvz --wildcards --no-anchored --xform="s#.*/##" "*.jar" "*.ldif" -f /compile/incubator-guacamole-client/extensions/guacamole-auth-ldap/target/guacamole-auth-ldap-0.9.9-incubating.tar.gz -C /opt/guacamole/ldap
RUN cp /compile/incubator-guacamole-client/extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-mysql/target/guacamole-auth-jdbc-mysql-0.9.9-incubating.jar /opt/guacamole/mysql
COPY mysql-connector-java-5.1.35-bin.jar /opt/guacamole/mysql/
RUN cp /compile/incubator-guacamole-client/extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-postgresql/target/guacamole-auth-jdbc-postgresql-0.9.9-incubating.jar /opt/guacamole/postgresql
RUN curl -L "https://jdbc.postgresql.org/download/postgresql-9.4-1201.jdbc41.jar" > /opt/guacamole/postgresql/postgresql-9.4-1201.jdbc41.jar
RUN cp /compile/incubator-guacamole-client/guacamole-docker/bin/* /opt/guacamole/bin/
#ENV \
#    GUAC_VERSION=0.9.9      \
#    GUAC_JDBC_VERSION=0.9.9 \
#    GUAC_LDAP_VERSION=0.9.9
#RUN \
#    /opt/guacamole/bin/download-guacamole.sh "$GUAC_VERSION" /usr/local/tomcat/webapps && \
#    /opt/guacamole/bin/download-jdbc-auth.sh "$GUAC_JDBC_VERSION" /opt/guacamole       && \
#    /opt/guacamole/bin/download-ldap-auth.sh "$GUAC_LDAP_VERSION" /opt/guacamole
EXPOSE 8080
CMD ["/opt/guacamole/bin/start.sh" ]
