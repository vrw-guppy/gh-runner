#!/bin/bash
echo "Configuring runner..."
echo "URL: $URL"
echo "RUNNER_GROUP: $RUNNER_GROUP"
echo "RUNNER_LABELS: $RUNNER_LABELS"

./config.sh \
    --unattended \
    --url $URL \
    --pat $PERSONAL_ACCESS_TOKEN \
    --runnergroup $RUNNER_GROUP \
    --labels $RUNNER_LABELS \
    --work $RUNNER_WORKDIR

echo "Starting runner..."
./run.sh
