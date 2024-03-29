FROM python:3.12-slim

WORKDIR /app

ARG GH_TOKEN
ARG PYPI_USERNAME
ARG PYPI_PASSWORD

RUN apt-get update && apt-get install -y \
    curl \
    git \
    libc6-dev \
    gcc

RUN git config --global url."https://$GH_TOKEN:x-oauth-basic@github.com/".insteadOf "https://github.com/"

RUN pip install --upgrade pip && \
    pip install poetry

RUN poetry config http-basic.guppylocal $PYPI_USERNAME:$PYPI_PASSWORD
