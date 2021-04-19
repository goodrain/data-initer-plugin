FROM alpine:3.9

LABEL MAINTAINER ="guox <guox@goodrain.com>"

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    apk add --no-cache bash 

ENTRYPOINT ["docker-entrypoint.sh"]