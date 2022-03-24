#!/bin/bash
## 调用飞书群机器人的webhooks接口将信息发送至群内
api=https://open.feishu.cn/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

curl -X POST \
  $api \
  -H 'Content-Type: application/json' \
  -d '{
    "msg_type": "post",
    "content": {
        "post": {
            "zh_cn": {
                "title": "Jenkins",
                "content": [
                    [
                        {
                            "tag": "text",
                            "un_escape": true,
                            "text": "'$1'"
                        }
                    ],
                    [

                    ]
                ]
            }
        }
    }
}'