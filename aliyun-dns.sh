#!/bin/sh

echo 'Start configuring Aliyun CLI...'

aliyun configure set \
  --profile akProfile \
  --mode AK \
  --region cn-qingdao \
  --access-key-id $ALIYUN_CLI_ACCESS_KEY_ID \
  --access-key-secret $ALIYUN_CLI_ACCESS_KEY_SECRET

echo 'Completed Aliyun CLI configuration!'

DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')
SUB_DOMAIN=$(expr match "$CERTBOT_DOMAIN" '\(.*\)\..*\..*')
if [ -z $DOMAIN ]; then
    DOMAIN=$CERTBOT_DOMAIN
fi
if [ ! -z $SUB_DOMAIN ]; then
    SUB_DOMAIN=.$SUB_DOMAIN
fi

if [ $# -eq 0 ]; then
	aliyun alidns AddDomainRecord \
		--DomainName $DOMAIN \
		--RR "_acme-challenge"$SUB_DOMAIN \
		--Type "TXT" \
		--Value $CERTBOT_VALIDATION
	/bin/sleep 20
else
	RecordId=$(aliyun alidns DescribeDomainRecords \
		--DomainName $DOMAIN \
		--RRKeyWord "_acme-challenge"$SUB_DOMAIN \
		--Type "TXT" \
		--ValueKeyWord $CERTBOT_VALIDATION \
		| grep "RecordId" \
		| grep -Eo "[0-9]+")

	aliyun alidns DeleteDomainRecord \
		--RecordId $RecordId
fi
