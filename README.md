# Logstash Dockerfile

Logstash 1.4.1 (with Kibana 3)


Clone the repo

    git clone https://github.com/klynch/logstash-dockerfile

Create OpenSSL certificates for secure communication with logstash-forwarder.
The build will fail if no certs are present.

    cd logstash-dockerfile && mkdir certs && cd certs

    openssl genrsa -out logstash-ca.key 4096
    openssl req -batch -new -x509 -days 3650 -key monitor-ca.key -out monitor-ca.crt
    openssl req -new -nodes -keyout logstash.key -out logstash.csr -days 3650
    openssl ca -days 3650 -cert logstash-ca.crt -keyfile monitor-ca.key -policy policy_anything -out logstash.crt -infiles logstash.csr


Generate an SSH key for root login. The build will fail if no certs are present.

    ssh-keygen -N '' -f certs/logstash_rsa
    chmod 600 certs/logstash_rsa.pub

Build

    #Build the image
    docker build -t klynch/logstash .

    #Build the container
    docker run -p 127.0.0.1::22 -p 5000:5000 -p 5043:5043 -p 9200:9200 -p 9292:9292 -d --name logstash klynch/logstash

Ports

      22 (ssh)
    5000 (tcp)
    5043 (lumberjack)
    9292 (logstash ui)
    9200 (elasticsearch)
    9300 (elasticsearch)


### Dockerfile parameters:

Number of elasticsearch workers:

  * LOGSTASH_DEFAULT_TYPE The default type for unmarked logs (default: "default")
  * WORKERS The number of logstash workers (default: 1)
  * ES_HOST The Elasticache host (default: localhost)
  * ES_PORT The Elasticache port (default: 9300)


### Host configuration (Ubuntu):

  1. Copy `host-conf/upstart/logstash.conf` to `/etc/init/logstash.conf`
