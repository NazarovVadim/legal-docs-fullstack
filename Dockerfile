FROM python:3.10-slim

# Установим Node.js
RUN apt-get update && apt-get install -y curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Установим зависимости Python
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Скопируем всё приложение
COPY . .

# Собираем frontend
WORKDIR /app/frontend
RUN npm install && npm run build

# Копируем билд React в backend/static
RUN cp -r build ../backend/static/

# Запуск сервера
WORKDIR /app
CMD ["gunicorn", "-k", "uvicorn.workers.UvicornWorker", "backend.main:app", "--bind", "0.0.0.0:10000"]
