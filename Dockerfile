FROM apache/flink:2.2.1-java17

USER root


RUN mkdir -p /opt/flink-cdc/log


RUN wget -O /opt/flink/lib/fluss-flink-2.2-0.9.1-incubating.jar \
    https://repo1.maven.org/maven2/org/apache/fluss/fluss-flink-2.2/0.9.1-incubating/fluss-flink-2.2-0.9.1-incubating.jar


RUN wget -O /tmp/flink-cdc.tar.gz \
    https://dlcdn.apache.org/flink/flink-cdc-3.6.0/flink-cdc-3.6.0-2.2-bin.tar.gz \
    && tar -xzf /tmp/flink-cdc.tar.gz -C /opt/flink-cdc --strip-components=1 \
    && rm /tmp/flink-cdc.tar.gz


RUN wget -O /opt/flink-cdc/lib/flink-cdc-pipeline-connector-postgres-3.6.0-2.2.jar \
    https://repo1.maven.org/maven2/org/apache/flink/flink-cdc-pipeline-connector-postgres/3.6.0-2.2/flink-cdc-pipeline-connector-postgres-3.6.0-2.2.jar && \
    wget -O /opt/flink-cdc/lib/flink-cdc-pipeline-connector-fluss-3.6.0-2.2.jar \
    https://repo1.maven.org/maven2/org/apache/flink/flink-cdc-pipeline-connector-fluss/3.6.0-2.2/flink-cdc-pipeline-connector-fluss-3.6.0-2.2.jar


RUN wget -O /tmp/flink-shaded-guava.jar \
    https://repo1.maven.org/maven2/org/apache/flink/flink-shaded-guava/31.1-jre-17.0/flink-shaded-guava-31.1-jre-17.0.jar \
    && cp /tmp/flink-shaded-guava.jar /opt/flink/lib/ \
    && rm /tmp/flink-shaded-guava.jar


RUN chown -R flink:flink /opt/flink-cdc /opt/flink/lib


COPY postgres-to-fluss.yaml /opt/flink-cdc/

USER flink

WORKDIR /opt/flink-cdc