# Logstash
#
# logstash is a tool for managing events and logs
#
# VERSION               1.4.1

FROM      ubuntu:14.04
MAINTAINER Kevin Lynch "klynch@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y curl openjdk-7-jre-headless openssh-server
RUN curl https://download.elasticsearch.org/logstash/logstash/logstash-1.4.1.tar.gz | tar -zx -C /opt

ADD run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

RUN mkdir /opt/certs/ /root/.ssh
ADD certs/monitor-ca.crt /opt/certs/monitor-ca.crt
ADD certs/logstash.crt /opt/certs/logstash.crt
ADD certs/logstash.key /opt/certs/logstash.key
ADD certs/logstash_rsa.pub /root/.ssh/authorized_keys

# SSH                 22
# Input: TCP        5000
# Input: Lumberjack 5043
# Kibana            9292
# Elasticsearch     9200 9300
EXPOSE 22 5000 5043 9292 9200 9300

ENTRYPOINT ["/usr/local/bin/run.sh"]
