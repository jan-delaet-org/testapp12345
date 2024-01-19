FROM python:3.11-alpine AS build

RUN apk update && apk upgrade
RUN addgroup --gid 1001 app \
    && adduser -S -G app --uid 1001 app
USER 1001
WORKDIR /app
COPY --chown=app:app requirements.txt .
RUN python -m venv .venv
ENV PATH="/app/.venv/bin:${PATH}"
RUN pip install --no-cache-dir --upgrade -r requirements.txt

FROM python:3.11-alpine

RUN apk update && apk upgrade
RUN addgroup --gid 1001 app \
    && adduser -S -G app --uid 1001 app
USER 1001
WORKDIR /app
COPY --chown=app:app ./app ./app
COPY --from=build --chown=app:app /app/.venv .venv
ENV PATH="/app/.venv/bin:$PATH"
EXPOSE 8080
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]