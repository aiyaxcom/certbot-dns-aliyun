#!/bin/bash

# 设置要执行的命令，注意替换</path/to/deploy-hook.sh>
command="docker run -it --rm --name certbot-dns-aliyun -v \"/etc/letsencrypt:/etc/letsencrypt\" -v \"/var/lib/letsencrypt:/var/lib/letsencrypt\" -e ALIYUN_CLI_ACCESS_KEY_ID=\"${ALIYUN_CLI_ACCESS_KEY_ID}\" -e ALIYUN_CLI_ACCESS_KEY_SECRET=\"${ALIYUN_CLI_ACCESS_KEY_SECRET}\" aiyax/certbot-dns-aliyun renew --manual --preferred-challenges dns --manual-auth-hook 'aliyun-dns' --manual-cleanup-hook 'aliyun-dns clean' --non-interactive| grep "Congratulations, all renewals succeeded" && </path/to/deploy-hook.sh>"

# 添加任务到crontab
(crontab -l ; echo "0 3 5,15,25 * * $command") | crontab -

echo "任务已成功添加到crontab。"
