

FROM java:7


MAINTAINER Wellington Marinho wpmarinho@globo.com

# Init ENV
ENV BISERVER_VERSION 5.3
ENV BISERVER_TAG 5.3.0.0-213

ENV PENTAHO_HOME /opt/pentaho

# Apply JAVA_HOME
RUN . /etc/environment
ENV PENTAHO_JAVA_HOME $JAVA_HOME

RUN apt-get update && \
	apt-get install wget unzip git postgresql-client-9.4 zip -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Download Pentaho BI Server
RUN /usr/bin/wget -nv  http://softlayer-dal.dl.sourceforge.net/project/pentaho/Business%20Intelligence%20Server/${BISERVER_VERSION}/biserver-ce-${BISERVER_TAG}.zip -O /tmp/biserver-ce-${BISERVER_TAG}.zip 

RUN /usr/bin/unzip -q /tmp/biserver-ce-${BISERVER_TAG}.zip -d  $PENTAHO_HOME && \
    rm -f /tmp/biserver-ce-${BISERVER_TAG}.zip $PENTAHO_HOME/biserver-ce/promptuser.sh && \
    sed -i -e 's/\(exec ".*"\) start/\1 run/' $PENTAHO_HOME/biserver-ce/tomcat/bin/startup.sh && \
    chmod +x $PENTAHO_HOME/biserver-ce/start-pentaho.sh

ENV PENTAHO_JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64
ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64

COPY config $PENTAHO_HOME/config
COPY scripts $PENTAHO_HOME/scripts
COPY scripts/run.sh /

EXPOSE 8080 
CMD ["/run.sh"]
