# certbot-dns-aliyun
Create or renew Let's encrypt SSL certificate using certbot, dns authorization of aliyun, and in docker


```
docker run -it --rm --name certbot-dns-aliyun \
            -v "/etc/letsencrypt:/etc/letsencrypt" \
            -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
	    -e ALIYUN_CLI_ACCESS_KEY_ID=<ALIYUN_CLI_ACCESS_KEY_ID> \
	    -e ALIYUN_CLI_ACCESS_KEY_SECRET=<ALIYUN_CLI_ACCESS_KEY_SECRET> \
            aiyax/certbot-dns-aliyun certonly \
              -d <cert-domain> \
              --manual \
              --preferred-challenges dns \
	      --manual-auth-hook 'aliyun-dns' \
	      --manual-clean-hook 'aliyun-dns clean'
```
