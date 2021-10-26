FROM ubuntu:20.04

LABEL MAINTAINER ="guox <guox@goodrain.com>"

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    apt-get update && apt-get install -y unzip wget && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["docker-entrypoint.sh"]
