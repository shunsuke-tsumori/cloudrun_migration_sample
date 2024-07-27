FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y wget gnupg && rm -rf /var/lib/apt/lists/*

RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy && \
    chmod +x cloud_sql_proxy

COPY alembic.ini /app/
COPY alembic /app/alembic
COPY pyproject.toml .
COPY requirements.lock .

RUN python -m venv /venv
RUN /venv/bin/pip install --no-cache-dir -r requirements.lock

CMD ./cloud_sql_proxy -dir=/cloudsql -instances=[PROJECT_ID]:asia-northeast1:[DB_INSTANCE_NAME]=tcp:5432 & \
    sleep 10 && \
    /venv/bin/alembic upgrade head
