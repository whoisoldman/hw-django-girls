#!/usr/bin/env bash
set -euo pipefail

NAME="${1:-djgirls-ghcr}"
IMAGE="${2:-ghcr.io/whoisoldman/hw-django-girls:latest}"
PORT_OUT="${3:-8000}"
PORT_IN="8000"

# Чистим и запускаем
docker rm -f "$NAME" >/dev/null 2>&1 || true
docker run -d --rm -p "${PORT_OUT}:${PORT_IN}" --name "$NAME" "$IMAGE" >/dev/null

# Ждём готовности (до 60 сек): сначала health (если есть), иначе — curl к порту
for i in $(seq 1 60); do
  status="$(docker inspect -f '{{if .State.Health}}{{.State.Health.Status}}{{else}}no-health{{end}}' "$NAME" 2>/dev/null || echo not-running)"
  if [ "$status" = "healthy" ]; then
    echo "✅ container is healthy"; break
  fi
  if curl -fsS "http://127.0.0.1:${PORT_OUT}/" >/dev/null 2>&1; then
    echo "✅ HTTP is up"; break
  fi
  echo "⏳ waiting... ($i) status=${status}"
  sleep 1
done

# Итоговая проверка
echo "---- HEADERS / ----"
curl -I "http://127.0.0.1:${PORT_OUT}/" || true
echo "---- HEADERS /static/css/blog.css ----"
curl -I "http://127.0.0.1:${PORT_OUT}/static/css/blog.css" || true
