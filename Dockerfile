# Simple image to run hello.py
FROM python:3.11-slim

WORKDIR /app
COPY hello.py /app/

CMD ["python", "hello.py"]
