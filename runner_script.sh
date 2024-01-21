#!/bin/bash
set -e

echo "Configuring runner..."
echo "URL: $URL"
echo "RUNNER_GROUP: $RUNNER_GROUP"
echo "RUNNER_LABELS: $RUNNER_LABELS"

# dockerの再起動
echo "Starting docker..."
sudo service docker start

echo "Configuring runner..."
./config.sh \
    --unattended \
    --url $URL \
    --pat $PERSONAL_ACCESS_TOKEN \
    --runnergroup $RUNNER_GROUP \
    --labels $RUNNER_LABELS \
    --work $RUNNER_WORKDIR

echo "Starting runner..."
./run.sh
