FROM python:3.10-slim

# Обновление системы и установка зависимостей Python и Node.js
RUN apt-get update && \
    apt-get install -y curl gnupg build-essential libpango-1.0-0 libpangocairo-1.0-0 libcairo2 libffi-dev libxml2 libgdk-pixbuf2.0-0 libjpeg-dev zlib1g-dev && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Установка Python-зависимостей
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Копируем всё приложение
COPY . .

# Установка и сборка frontend
WORKDIR /app/frontend
RUN npm install && npm run build

# Копируем билд React в backend/static
RUN cp -r build ../backend/static/

# Запуск FastAPI через gunicorn
WORKDIR /app
CMD ["gunicorn", "-k", "uvicorn.workers.UvicornWorker", "backend.main:app", "--bind", "0.0.0.0:10000"]
