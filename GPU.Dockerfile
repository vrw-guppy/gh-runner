FROM nvidia/cuda:12.3.1-base-ubuntu22.04

ARG PERSONAL_ACCESS_TOKEN
ARG RUNNER_LABELS="self-hosted,Linux,X64,nvidia"
ARG RUNNER_NAME
ARG RUNNER_GROUP=Default
ARG URL=https://github.com/vrw-guppy

ENV BINARY_URL=https://github.com/actions/runner/releases/download/v2.296.3/actions-runner-linux-x64-2.296.3.tar.gz

ENV RUNNER_GROUP=${RUNNER_GROUP} \
    RUNNER_LABELS=${RUNNER_LABELS} \
    RUNNER_WORKDIR=_work \
    PERSONAL_ACCESS_TOKEN=${PERSONAL_ACCESS_TOKEN} \
    URL=${URL}

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh

RUN apt-get update && \
    apt-get install -y curl sudo

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN useradd runner && \
    echo "runner:runner" | chpasswd && \
    chsh -s /usr/bin/bash runner && \
    usermod -aG sudo runner && \
    mkdir /actions-runner && \
    chown runner:runner /actions-runner

WORKDIR /actions-runner

RUN curl -fsSL -o actions-runner.tar.gz -L $BINARY_URL && \
    tar xf actions-runner.tar.gz && \
    rm actions-runner.tar.gz

RUN ./bin/installdependencies.sh

# スクリプトの追加
COPY runner_script.sh .

RUN chmod +x ./runner_script.sh

USER runner

# コンテナが起動したときにスクリプトを実行
CMD ["./runner_script.sh"]
