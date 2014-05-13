# Logstash Dockerfile

Logstash 1.4.1 (with Kibana 3)


Clone the repo

    git clone https://github.com/denibertovic/logstash-dockerfile

Create OpenSSL certificates for secure communication with logstash-forwarder.
The build will fail if no certs are present.

    cd logstash-dockerfile && mkdir certs && cd certs

    openssl genrsa -out logstash-ca.key 4096
    openssl req -batch -new -x509 -days 3650 -key monitor-ca.key -out monitor-ca.crt
    openssl req -new -nodes -keyout logstash.key -out logstash.csr -days 3650
    openssl ca -days 3650 -cert logstash-ca.crt -keyfile monitor-ca.key -policy policy_anything -out logstash.crt -infiles logstash.csr

Build

    #Build the image
    docker build -t logstash .

    #Build the container
    docker run -p 5000:5000 -p 5043:5043 -p 9200:9200 -p 9292:9292 -d --name logstash logstash

Specify an external Elasticsearch server

    docker run -name logstash -e ES_HOST=1.2.3.4 -e ES_PORT=9300 -d -t logstash

Ports

    5000 (tcp)
    5043 (lumberjack)
    9292 (logstash ui)
    9200 (elasticsearch)
    9300 (elasticsearch)


### Other Evironment Variables in Dockerfile:

Number of elasticsearch workers:

    ELASTICWORKERS 1
