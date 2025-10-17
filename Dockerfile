# ---------- BASE ----------
FROM python:3.8-slim

# ---------- ENV ----------
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# ---------- SYSTEM DEPS (optional, slim clean) ----------
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    curl \
 && rm -rf /var/lib/apt/lists/*

# ---------- WORKDIR ----------
WORKDIR /app

# ---------- DEPENDENCIES ----------
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt gunicorn whitenoise

# ---------- COPY PROJECT ----------
COPY . .

# Collect static files
RUN python3 manage.py collectstatic --noinput

# На всякий случай убедимся, что скрипт инициализации исполняемый
RUN chmod +x /app/init.sh || true

# ---------- EXPOSE ----------
RUN mkdir -p /app/db

EXPOSE 8000

# ---------- HEALTHCHECK ----------
HEALTHCHECK --interval=5s --timeout=3s --start-period=10s --retries=12 \
  CMD curl -fsS http://127.0.0.1:8000/ >/dev/null || exit 1

# ---------- CMD ----------
# Прогоняем миграции и создаём суперпользователя (если его нет), затем — gunicorn
CMD ["/bin/sh", "-c", "./init.sh && gunicorn --bind 0.0.0.0:8000 mysite.wsgi:application"]
