FROM registry.guppy.local/base-python:master

COPY pyproject.toml .

RUN poetry install --no-dev --no-interaction --no-ansi

COPY . .

ARG GIT_SHA
ARG VERSION
ENV GIT_SHA=$GIT_SHA
ENV VERSION=$VERSION

CMD [ "poetry", "run", "start", "server" ]
