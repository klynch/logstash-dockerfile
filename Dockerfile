# Logstash
#
# logstash is a tool for managing events and logs
#
# VERSION               1.4.1

FROM      ubuntu:14.04
MAINTAINER Kevin Lynch "klynch@drakontas.com"

ENV DEBIAN_FRONTEND noninteractive

# Number of elasticsearch workers
ENV ELASTICWORKERS 1

RUN apt-get update
RUN apt-get install -y curl openjdk-7-jre-headless
RUN curl https://download.elasticsearch.org/logstash/logstash/logstash-1.4.1.tar.gz | tar -zx -C /opt

ADD run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

RUN mkdir /opt/certs/
ADD certs/logstash-ca.crt /opt/certs/logstash-ca.crt
ADD certs/logstash.crt /opt/certs/logstash.crt
ADD certs/logstash.key /opt/certs/logstash.key

# Input: TCP
EXPOSE 5000

# Input: Lumberjack
EXPOSE 5043

# Kibana
EXPOSE 9292

# Elastic search
EXPOSE 9200
EXPOSE 9300

CMD /usr/local/bin/run.sh
