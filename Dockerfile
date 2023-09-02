FROM certbot/certbot:v2.6.0

LABEL maintainer="jason.wang@aiyax.com"

COPY aliyun-cli-linux-3.0.179-amd64.tgz /tmp/aliyun-cli-linux.tgz

RUN tar xzvf /tmp/aliyun-cli-linux.tgz -C /tmp \
    && cp /tmp/aliyun /usr/local/bin \
    && rm /tmp/aliyun-cli-linux.tgz

WORKDIR /app

COPY aliyun-dns.sh /usr/local/bin/aliyun-dns.sh

RUN chmod +x /usr/local/bin/aliyun-dns.sh \
    && ln -s /usr/local/bin/aliyun-dns.sh /usr/local/bin/aliyun-dns
