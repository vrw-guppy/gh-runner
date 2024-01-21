FROM ubuntu:22.04

ARG PERSONAL_ACCESS_TOKEN
ARG RUNNER_LABELS="self-hosted,Linux,X64"
ARG RUNNER_NAME
ARG RUNNER_GROUP=Default
ARG URL=https://github.com/vrw-guppy
ARG INSECURE_REGISTRY

ENV BINARY_URL=https://github.com/actions/runner/releases/download/v2.296.3/actions-runner-linux-x64-2.296.3.tar.gz

ENV RUNNER_GROUP=${RUNNER_GROUP} \
    RUNNER_LABELS=${RUNNER_LABELS} \
    RUNNER_WORKDIR=_work \
    PERSONAL_ACCESS_TOKEN=${PERSONAL_ACCESS_TOKEN} \
    URL=${URL} \
    INSECURE_REGISTRY=${INSECURE_REGISTRY}

# Install Docker from Docker Inc. repositories.
RUN apt-get update && apt-get upgrade -y && \  
    apt-get install -y curl sudo jq
RUN curl -sSL https://get.docker.com/ | sh

# /etc/init.d/dockerの編集
RUN sed -i -e '/ulimit -Hn 524288/d' /etc/init.d/docker

# sudoersにrunnerを追加
# add sudo user
RUN groupadd -g 1000 developer && \
    useradd  -g      developer -G sudo -m -s /bin/bash runner && \
    echo 'runner:runner' | chpasswd
RUN echo 'runner ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN usermod -aG docker runner

WORKDIR /actions-runner
RUN chown runner /actions-runner

RUN curl -fsSL -o actions-runner.tar.gz -L $BINARY_URL && \
    tar xf actions-runner.tar.gz && \
    rm actions-runner.tar.gz

RUN ./bin/installdependencies.sh

# INSECURE_REGISTRYの設定
COPY add_insecure.sh .
RUN chmod +x ./add_insecure.sh
RUN ./add_insecure.sh

# スクリプトの追加
COPY runner_script.sh .

RUN chmod +x ./runner_script.sh

USER runner

# コンテナが起動したときにスクリプトを実行
CMD ["./runner_script.sh"]
