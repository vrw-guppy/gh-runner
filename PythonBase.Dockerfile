FROM python:3.12-alpine

WORKDIR /app

RUN apk add --no-cache gcc libc-dev git curl
ARG GH_TOKEN

RUN git config --global url."https://$GH_TOKEN:x-oauth-basic@github.com/".insteadOf "https://github.com/"

RUN pip install --upgrade pip && \
    pip install poetry
