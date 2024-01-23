FROM python:3.12-alpine

WORKDIR /app

RUN apk add --no-cache git
ARG GH_TOKEN

RUN git config --global url."https://$GH_TOKEN:x-oauth-basic@github.com/".insteadOf "https://github.com/"

RUN pip install --upgrade pip && \
    pip install poetry

