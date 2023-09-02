# 使用 certbot/certbot:v2.6.0 作为基础镜像
FROM certbot/certbot:v2.6.0

# 添加维护者信息
LABEL maintainer="jason.wang@aiyax.com"

# 复制 aliyun-cli-linux-3.0.179-amd64.tgz 到镜像
COPY aliyun-cli-linux-3.0.179-amd64.tgz /tmp/aliyun-cli-linux.tgz

# 安装 aliyun-cli
RUN tar xzvf /tmp/aliyun-cli-linux.tgz -C /tmp \
    && cp /tmp/aliyun /usr/local/bin \
    && rm /tmp/aliyun-cli-linux.tgz

# 定义工作目录
WORKDIR /app

# 拷贝 aliyun-dns.sh 文件到 /usr/local/bin
COPY aliyun-dns.sh /usr/local/bin/aliyun-dns.sh

# 拷贝 configure-aliyun-cli.sh 文件到 /usr/local/bin
COPY configure-aliyun-cli.sh /usr/local/bin/configure-aliyun-cli.sh

# 执行 aliyun-dns.sh
RUN chmod +x /usr/local/bin/aliyun-dns.sh \
    && ln -s /usr/local/bin/aliyun-dns.sh /usr/local/bin/aliyun-dns

# 设置 configure-aliyun-cli.sh 可执行权限
RUN chmod +x /usr/local/bin/configure-aliyun-cli.sh \
    && ln -s /usr/local/bin/configure-aliyun-cli.sh /usr/local/bin/configure-aliyun-cli
