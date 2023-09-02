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
	      --manual-clean-hook 'aliyun-dns clean' \
              --non-interactive
```
注意，生成完证书后，需要配置并部署到相应的web服务器。

## 更新证书

Documentation in progressing

域名认证有效期是30天

配置Crontab

## 创建并授权ACCESS_KEY

首先，参考[阿里云的创建AccessKey](https://help.aliyun.com/zh/ram/user-guide/create-an-accesskey-pair)，建议为该AccessKey创建单独的RAM用户以进行更精细的云解析授权管理。

然后，为该用户授权，可以参考[授权RAM用户管理域名](https://help.aliyun.com/zh/dws/user-guide/authorize-a-ram-user-to-manage-domain-names)，注意，实际是授权RAM用户管理云解析，所以授权时选择`AliyunDNSFullAccess`而不是`AliyunDomainFullAccess`。

通过以上两步，我们就可以使用该RAM用户的AccessKey，通过Aliyun CLI来访问云解析了。



