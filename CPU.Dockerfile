FROM ubuntu:22.04

ENV BINARY_URL=https://github.com/actions/runner/releases/download/v2.296.3/actions-runner-linux-x64-2.296.3.tar.gz

# Install Docker from Docker Inc. repositories.
RUN apt-get update && apt-get upgrade -y && \  
    apt-get install -y curl sudo jq zip
RUN curl -sSL https://get.docker.com/ | sh

# /etc/init.d/dockerの編集
RUN sed -i -e '/ulimit -Hn 524288/d' /etc/init.d/docker

# sudoersにrunnerを追加
RUN groupadd -g 1000 developer && \
    useradd  -g      developer -G sudo -m -s /bin/bash runner && \
    echo 'runner:runner' | chpasswd
RUN echo 'runner ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN usermod -aG docker runner

WORKDIR /actions-runner

# ファイルの権限設定
RUN mkdir /actions-runner/_work
RUN chown runner  -R /actions-runner
RUN chmod 777 -R /actions-runner

RUN curl -fsSL -o actions-runner.tar.gz -L $BINARY_URL && \
    tar xf actions-runner.tar.gz && \
    rm actions-runner.tar.gz

RUN ./bin/installdependencies.sh

# https://github.com/actions/runner-container-hooks
ARG RUNNER_CONTAINER_HOOKS_VERSION=0.3.2

RUN curl -fLo runner-container-hooks.zip https://github.com/actions/runner-container-hooks/releases/download/v${RUNNER_CONTAINER_HOOKS_VERSION}/actions-runner-hooks-docker-${RUNNER_CONTAINER_HOOKS_VERSION}.zip \
    && unzip ./runner-container-hooks.zip -d ./runner-container-hooks-docker \
    && rm -f runner-container-hooks.zip
ENV ACTIONS_RUNNER_CONTAINER_HOOKS="${RUNNER_DIR}/runner-container-hooks-docker/index.js"


ARG PERSONAL_ACCESS_TOKEN
ARG RUNNER_LABELS="self-hosted,Linux,X64"
ARG RUNNER_GROUP=Default
ARG URL=https://github.com/vrw-guppy
ARG INSECURE_REGISTRY
ARG GH_TOKEN

ENV RUNNER_GROUP=${RUNNER_GROUP} \
    RUNNER_LABELS=${RUNNER_LABELS} \
    RUNNER_WORKDIR=_work \
    PERSONAL_ACCESS_TOKEN=${PERSONAL_ACCESS_TOKEN} \
    URL=${URL} \
    INSECURE_REGISTRY=${INSECURE_REGISTRY}

# スクリプトの追加
COPY --chmod=777 ./scripts .

# daaemon.jsonの追加
RUN ./add_insecure.sh ${INSECURE_REGISTRY}

USER runner

# GITの設定
RUN git config --global url."https://$GH_TOKEN:x-oauth-basic@github.com/".insteadOf "https://github.com/"

# コンテナが起動したときにスクリプトを実行
CMD ["./runner_script.sh"]
