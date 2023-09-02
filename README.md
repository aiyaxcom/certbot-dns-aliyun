# certbot-dns-aliyun

本项目主要通过Certbot集成阿里云CLI来自动化颁发SSL证书，为了最小化运维门槛，所以依赖及脚本都被打包到docker镜像中。

## 创建证书

创建证书只需执行如下命令，当然，该命令需要服务器已安装Docker。另外，需要替换下命令中的三个变量：
- ALIYUN_CLI_ACCESS_KEY_ID，如何获取参考[创建并授权ACCESS_KEY](README.md#创建并授权ACCESS_KEY)
- ALIYUN_CLI_ACCESS_KEY_SECRET，同上
- CERT_DOMAIN，需要获取证书的域名，比如`aiyax.com`或者`*.aiyax.com`
```
docker run -it --rm --name certbot-dns-aliyun \
            -v "/etc/letsencrypt:/etc/letsencrypt" \
            -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
	    -e ALIYUN_CLI_ACCESS_KEY_ID=<ALIYUN_CLI_ACCESS_KEY_ID> \
	    -e ALIYUN_CLI_ACCESS_KEY_SECRET=<ALIYUN_CLI_ACCESS_KEY_SECRET> \
            aiyax/certbot-dns-aliyun certonly \
              -d <CERT_DOMAIN> \
              --manual \
              --preferred-challenges dns \
	      --manual-auth-hook 'aliyun-dns' \
	      --manual-clean-hook 'aliyun-dns clean'
```

## 创建并授权ACCESS_KEY

