#!/bin/bash

HUGO_VERSION="0.134.0"
MAX_RETRIES=3
RETRY_DELAY=60

# 安装 Hugo
curl -L "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz" -o hugo.tar.gz
tar -xzf hugo.tar.gz

# 构建站点
./hugo

deploy_to_cloudflare() {
    local retry_count=0
    
    while [ $retry_count -lt $MAX_RETRIES ]; do
        if wrangler pages publish public; then
            echo "部署成功！"
            return 0
        else
            retry_count=$((retry_count + 1))
            if [ $retry_count -lt $MAX_RETRIES ]; then
                echo "部署失败，${RETRY_DELAY}秒后重试..."
                sleep $RETRY_DELAY
            fi
        fi
    done
    
    echo "达到最大重试次数，部署失败"
    return 1
}

# 执行部署
deploy_to_cloudflare
