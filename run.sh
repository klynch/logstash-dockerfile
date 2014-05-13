#!/bin/bash
ES_HOST=${ES_HOST:-127.0.0.1}
ES_PORT=${ES_PORT:-9300}
EMBEDDED="false"
WORKERS=${ELASTICWORKERS:-1}

if [ "$ES_HOST" = "127.0.0.1" ] ; then
    EMBEDDED="true"
fi

cat << EOF > /opt/logstash.conf
input {
  tcp {
    type => "dragonforce"
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
