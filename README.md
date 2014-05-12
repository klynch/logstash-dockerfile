# Logstash Dockerfile

Logstash 1.4.1 (with Kibana 3)


Clone the repo

    git clone https://github.com/denibertovic/logstash-dockerfile

Create OpenSSL certificates for secure communication with logstash-forwarder.
The build will fail if no certs are present.

    cd logstash-dockerfile && mkdir certs && cd certs

    openssl genrsa -out logstash-ca.key 4096
    openssl req -batch -new -x509 -days 3650 -key logstash-ca.key -out logstash-ca.crt
    openssl req -new -nodes -keyout logstash.key -out logstash.csr -days 3650
    openssl ca -days 3650 -cert logstash-ca.crt -keyfile logstash-ca.key -policy policy_anything -out logstash.crt -infiles logstash.csr

Build

    docker build -t logstash .

Test it:

    docker run -p 5043:5043 -p 514:514 -p 9200:9200 -p 9292:9292 -p 9300:9300 -i -t logstash
    netcat localhost 514
        > test
        > test
        > CTRL+C
    # You should see the messages show up on logstash

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
