# certbot-dns-aliyun

本项目主要通过Certbot集成阿里云CLI来一键创建、自动化更新SSL证书，为**域名解析部署在阿里云**的用户提供便利的证书生成和更新方式。为了最小化运维门槛，依赖及脚本都被打包到docker镜像中。

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
	      --manual-cleanup-hook 'aliyun-dns clean'
```
注意，生成完证书后，需要将其配置并部署到相应的web服务器。

## 更新证书

更新证书更加方便，因为Certbot会自动查找并续订已经存在的证书而无需指定域名。使用如下命令即可轻松检查并续订：

```
docker run -it --rm --name certbot-dns-aliyun \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    -e ALIYUN_CLI_ACCESS_KEY_ID=<ALIYUN_CLI_ACCESS_KEY_ID> \
    -e ALIYUN_CLI_ACCESS_KEY_SECRET=<ALIYUN_CLI_ACCESS_KEY_SECRET> \
    aiyax/certbot-dns-aliyun renew \
    --manual \
    --preferred-challenges dns \
    --manual-auth-hook 'aliyun-dns' \
    --manual-cleanup-hook 'aliyun-dns clean' \
    --non-interactive
```

同样的，需要重启web服务器才会使续订的证书生效。

当然，更佳的办法是配置Crontab，这样服务器可以定期检查并续订。

这是一个crontab的例子，其中需要提前配置环境变量`ALIYUN_CLI_ACCESS_KEY_ID`和`ALIYUN_CLI_ACCESS_KEY_SECRET`，可以将它们写入`/etc/environment`以防止服务器重启后丢失环境变量。与此同时，我们需要使用一个deploy-hook.sh脚本来重启web服务以使证书被部署生效。
**注意替换</path/to/deploy-hook.sh>**。
```
# 每5/15/25号3点执行certbot renew，注意替换</path/to/deploy-hook.sh>
0 3 5,15,25 * * docker run -it --rm --name certbot-dns-aliyun -v "/etc/letsencrypt:/etc/letsencrypt" -v "/var/lib/letsencrypt:/var/lib/letsencrypt" -e ALIYUN_CLI_ACCESS_KEY_ID="${ALIYUN_CLI_ACCESS_KEY_ID}" -e ALIYUN_CLI_ACCESS_KEY_SECRET="${ALIYUN_CLI_ACCESS_KEY_SECRET}" aiyax/certbot-dns-aliyun renew --manual --preferred-challenges dns --non-interactive | grep "Congratulations, all renewals succeeded" && </path/to/deploy-hook.sh>
```

以上的Crontab中的`5,15,25`可以根据需求自行调整，有两点需要考虑：
1. Let's encrypt证书只有达到一定时间才会renew，应该是最后30天。
2. 过于频繁的renew会被限制。

## 创建并授权ACCESS_KEY

首先，参考[阿里云的创建AccessKey](https://help.aliyun.com/zh/ram/user-guide/create-an-accesskey-pair)，建议为该AccessKey创建单独的RAM用户以进行更精细的云解析授权管理。

然后，为该用户授权，可以参考[授权RAM用户管理域名](https://help.aliyun.com/zh/dws/user-guide/authorize-a-ram-user-to-manage-domain-names)，注意，实际是授权RAM用户管理云解析，所以授权时选择`AliyunDNSFullAccess`而不是`AliyunDomainFullAccess`。

通过以上两步，我们就可以使用该RAM用户的AccessKey，通过Aliyun CLI来访问云解析了。

## 支持

关注微信公众号"e界书生"，获取更多有趣分享！

![e界书生](https://aiyax.com/images/ejieshusheng.jpg)

