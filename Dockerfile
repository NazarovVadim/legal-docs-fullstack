FROM python:3.10-slim

WORKDIR /app
COPY . /app

RUN pip install --upgrade pip &&     pip install -r requirements.txt

WORKDIR /app/frontend
RUN apt-get update && apt-get install -y curl &&     curl -fsSL https://deb.nodesource.com/setup_18.x | bash - &&     apt-get install -y nodejs &&     npm install && npm run build

WORKDIR /app
CMD ["gunicorn", "-k", "uvicorn.workers.UvicornWorker", "backend.main:app", "--bind", "0.0.0.0:10000"]
