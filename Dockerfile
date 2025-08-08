FROM python:3.10-slim

# Установка системных зависимостей
RUN apt-get update && \
    apt-get install -y curl gnupg build-essential libpango-1.0-0 libpangocairo-1.0-0 libcairo2 libffi-dev libxml2 libgdk-pixbuf2.0-0 libjpeg-dev zlib1g-dev && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Установка зависимостей Python
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Копируем всё приложение
COPY . .

# Сборка фронтенда
WORKDIR /app/frontend
RUN [ -f package.json ] && npm install && npm run build || echo "No frontend found, skipping build."

# Копируем билд React в backend/static, если он есть
RUN [ -d build ] && cp -r build ../backend/static || echo "No build to copy"

# Запуск бэкенда
WORKDIR /app
CMD ["gunicorn", "-k", "uvicorn.workers.UvicornWorker", "backend.main:app", "--bind", "0.0.0.0:10000"]
