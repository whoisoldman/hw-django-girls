# 🐳 Django Girls — Dockerized Application

Учебный проект в рамках домашнего задания **«Упаковка приложений в Docker»**.
Проект Django Girls развёрнут в контейнере Docker, снабжён CI/CD пайплайном на GitHub Actions
и автоматически публикуется в GitHub Container Registry (GHCR).

---

## 🚀 Репозиторий
**GitHub:** [whoisoldman/hw-django-girls](https://github.com/whoisoldman/hw-django-girls)
**Docker image (GHCR):** [ghcr.io/whoisoldman/hw-django-girls](https://ghcr.io/whoisoldman/hw-django-girls)

![Build](https://github.com/whoisoldman/hw-django-girls/actions/workflows/docker.yml/badge.svg)

---

## 📦 Структура проекта

Файл `projecttree.txt` содержит полное дерево проекта, включая служебные папки.
Ключевые файлы:
```
Dockerfile
.dockerignore
.github/workflows/docker.yml
init.sh
requirements.txt
manage.py
mysite/
blog/
projecttree.txt
```

---

## ⚙️ Dockerfile (основные шаги)

- Базовый образ: `python:3.8-slim`
- Копирование зависимостей из `requirements.txt`
- Установка зависимостей и `gunicorn`
- Копирование проекта и выполнение миграций
- Подготовка статики (`collectstatic`)
- Запуск приложения:
  ```bash
  gunicorn --bind 0.0.0.0:8000 mysite.wsgi:application
  ```

---

## 🧩 Локальный запуск

```bash
# Клонировать репозиторий
git clone https://github.com/whoisoldman/hw-django-girls.git
cd hw-django-girls

# Сборка и запуск контейнера
docker build -t hw-django-girls:latest .
docker run --rm -p 8000:8000 --name djgirls hw-django-girls:latest

# Проверка
curl -I http://127.0.0.1:8000/
curl -I http://127.0.0.1:8000/static/css/blog.css
```

После сборки приложение доступно по адресу:
👉 [http://127.0.0.1:8000/](http://127.0.0.1:8000/)

---

## ☁️ Запуск из GitHub Container Registry

```bash
docker pull ghcr.io/whoisoldman/hw-django-girls:latest
docker run -d --rm -p 8000:8000 --name djgirls-ghcr ghcr.io/whoisoldman/hw-django-girls:latest
curl -I http://127.0.0.1:8000/
```

Образ автоматически обновляется при каждом `git push` в ветку `main`.
Теги формируются автоматически:
- `latest`
- `sha-<короткий хэш коммита>`

---

## 🔄 CI/CD пайплайн

**Workflow:** [`.github/workflows/docker.yml`](.github/workflows/docker.yml)

**Описание шагов:**
1. `checkout` — загрузка репозитория;
2. `docker/login-action` — авторизация в GHCR;
3. `docker/metadata-action` — генерация тегов;
4. `docker/build-push-action` — сборка и пуш образа.

Пример публикации в логе Actions:
```
pushing ghcr.io/whoisoldman/hw-django-girls:latest
pushing ghcr.io/whoisoldman/hw-django-girls:sha-82801fd
```

---

## 🧾 Применённые технологии

| Технология | Назначение |
|-------------|------------|
| **Python 3.8** | Интерпретатор |
| **Django 3.0.6** | Веб-фреймворк |
| **Gunicorn** | WSGI-сервер |
| **WhiteNoise** | Отдача статики |
| **Docker** | Контейнеризация |
| **GitHub Actions + GHCR** | CI/CD и реестр образов |

---

## 📂 Файл projecttree.txt

Полная структура проекта сохранена в [projecttree.txt](./projecttree.txt).
Пример (верхние уровни):

```
├── Dockerfile
├── .dockerignore
├── .github/workflows/docker.yml
├── blog/
│   ├── static/css/blog.css
│   ├── templates/blog/
│   └── ...
├── mysite/
│   ├── settings.py
│   └── wsgi.py
└── requirements.txt
```

---

## ✅ Проверка

После сборки и запуска контейнера:

```bash
curl -I http://127.0.0.1:8000/
# → HTTP/1.1 200 OK

curl -I http://127.0.0.1:8000/static/css/blog.css
# → HTTP/1.1 200 OK
```

---

## 📚 Автор
**whoisoldman**
Домашнее задание курса: *«Упаковка приложений в Docker» (Django Girls)*
MacOS 12 | Docker Desktop | VS Code | GitHub Actions
