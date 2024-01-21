#!/bin/bash
echo "Configuring runner..."
echo "INSECURE_REGISTRY: $INSECURE_REGISTRY"

DOCKER_CONFIG_FILE='/etc/docker/daemon.json'
if [ -z "$INSECURE_REGISTRY" ]; then
    echo "INSECURE_REGISTRY is empty."
else
    if [ ! -f "$DOCKER_CONFIG_FILE" ]; then
        # daemon.jsonが存在しない場合、新規にファイルを作成
        echo "{\"insecure-registries\": [\"$INSECURE_REGISTRY\"]}" > "$DOCKER_CONFIG_FILE"
    else
        # daemon.jsonが存在する場合
        # jqコマンドを使用して、設定を追加（jqがインストールされていない場合はインストールが必要）
        sudo jq ". + {\"insecure-registries\": [\"$INSECURE_REGISTRY\"]}" "$DOCKER_CONFIG_FILE" > tmp.json && mv tmp.json "$DOCKER_CONFIG_FILE"
    fi
    chmod 777 "$DOCKER_CONFIG_FILE"
fi
