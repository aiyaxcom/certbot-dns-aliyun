#!/bin/sh

echo 'Start configuring Aliyun CLI'

aliyun configure set \
  --profile akProfile \
  --mode AK \
  --region cn-qingdao \
  --access-key-id $ALIYUN_CLI_ACCESS_KEY_ID \
  --access-key-secret $ALIYUN_CLI_ACCESS_KEY_SECRET

echo 'Complete Aliyun CLI configuration'
