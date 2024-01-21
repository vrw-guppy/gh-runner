#!/bin/bash -e

echo "Configuring runner..."
echo "URL: $URL"
echo "RUNNER_GROUP: $RUNNER_GROUP"
echo "RUNNER_LABELS: $RUNNER_LABELS"
echo "INSECURE_REGISTRY: $INSECURE_REGISTRY"

DOCKER_CONFIG_FILE='/etc/docker/daemon.json'
if [ ! -f "$DOCKER_CONFIG_FILE" ]; then
    # daemon.jsonが存在しない場合、新規にファイルを作成
    echo "{\"insecure-registries\": [\"$INSECURE_REGISTRY\"]}" > "$DOCKER_CONFIG_FILE"
else
    # daemon.jsonが存在する場合
    # jqコマンドを使用して、設定を追加（jqがインストールされていない場合はインストールが必要）
    jq ". + {\"insecure-registries\": [\"$INSECURE_REGISTRY\"]}" "$DOCKER_CONFIG_FILE" > tmp.json && mv tmp.json "$DOCKER_CONFIG_FILE"
fi

# dockerの再起動
sudo service docker restart

./config.sh \
    --unattended \
    --url $URL \
    --pat $PERSONAL_ACCESS_TOKEN \
    --runnergroup $RUNNER_GROUP \
    --labels $RUNNER_LABELS \
    --work $RUNNER_WORKDIR

echo "Starting runner..."
./run.sh
