#!/bin/bash

LOGSTASH_DEFAULT_TYPE=${1:default}
WORKERS=${2:-1}
ES_HOST=${3:-127.0.0.1}
ES_PORT=${4:-9300}
EMBEDDED="false"

if [ "$ES_HOST" = "127.0.0.1" ] ; then
    EMBEDDED="true"
fi

service ssh start

cat << EOF > /opt/logstash.conf
input {
  tcp {
    type => "$LOGSTASH_DEFAULT_TYPE"
    port => 5000
    codec => json_lines

    ssl_enable => true
    ssl_cert => "/opt/certs/logstash.crt"
    ssl_key => "/opt/certs/logstash.key"

    ssl_cacert => "/opt/certs/monitor-ca.crt"
    ssl_verify => true
  }

  lumberjack {
    type => "system"
    port => 5043

    ssl_certificate => "/opt/certs/logstash.crt"
    ssl_key => "/opt/certs/logstash.key"
  }
}

output {
  stdout {
  }

  elasticsearch {
      embedded => $EMBEDDED
      host => "$ES_HOST"
      port => "$ES_PORT"
      workers => $WORKERS
  }
}
EOF

exec /opt/logstash-1.4.1/bin/logstash agent -f /opt/logstash.conf -- web
