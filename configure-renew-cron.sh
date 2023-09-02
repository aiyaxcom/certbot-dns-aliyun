#!/bin/bash

# 设置要执行的命令
command="docker run -it --rm --name certbot-dns-aliyun -v \"/etc/letsencrypt:/etc/letsencrypt\" -v \"/var/lib/letsencrypt:/var/lib/letsencrypt\" -e ALIYUN_CLI_ACCESS_KEY_ID=\"your-access-key-id\" -e ALIYUN_CLI_ACCESS_KEY_SECRET=\"your-access-key-secret\" aiyax/certbot-dns-aliyun renew --manual --preferred-challenges dns --manual-auth-hook 'aliyun-dns' --manual-cleanup-hook 'aliyun-dns clean' --non-interactive"

# 添加任务到crontab
(crontab -l ; echo "0 3 5,15,25 * * $command") | crontab -

echo "任务已成功添加到crontab。"
