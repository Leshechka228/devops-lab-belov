FROM python:3.9-slim

# Метаданные
LABEL maintainer="belov"
LABEL description="DevOps Lab 4 - Feedback API"
LABEL version="1.0"
LABEL student="belov"

WORKDIR /app

# Устанавливаем зависимости
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install flask-cors

# Копируем код
COPY backend.py .

# Создаем volume директорию
RUN mkdir -p /app/data
VOLUME /app

# Запускаем приложение
CMD ["python", "-u", "backend.py"]
