# syntax=docker/dockerfile:1
# DevOps Project Generator CLI
#
#   docker run --rm -v "$PWD:/work" <image> init --no-interactive --name my-app
#
# Templates are resolved relative to the source tree, so the source stays
# in /app and generated projects are written to the mounted /work directory.

FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONPATH=/app

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY cli ./cli
COPY generator ./generator
COPY templates ./templates

RUN useradd --create-home --uid 1000 devops \
    && mkdir /work && chown devops:devops /work
USER devops
WORKDIR /work

ENTRYPOINT ["python", "-m", "cli"]
CMD ["--help"]
