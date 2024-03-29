FROM python:3.12-slim

WORKDIR /app

ARG GH_TOKEN
ARG PYPI_USERNAME
ARG PYPI_PASSWORD

RUN git config --global url."https://$GH_TOKEN:x-oauth-basic@github.com/".insteadOf "https://github.com/"

RUN pip install --upgrade pip && \
    pip install poetry

RUN poetry config http-basic.guppylocal $PYPI_USERNAME:$PYPI_PASSWORD
