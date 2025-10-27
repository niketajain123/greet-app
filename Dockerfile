FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
ENV NEW_RELIC_LICENSE_KEY=57f07ca103e99c2f68094d3ade04e5fbFFFFNRAL
ENV NEW_RELIC_APP_NAME=greet-app
ENV NEW_RELIC_LOG_LEVEL=info
ENV NEW_RELIC_DISTRIBUTED_TRACING_ENABLED=true
COPY . .

EXPOSE 5000

CMD ["newrelic-admin", "run-program", "python", "app.py"]
