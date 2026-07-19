# Hugging Face Spaces (Docker SDK) requires the app to listen on port 7860
FROM python:3.11-slim

WORKDIR /app

# System deps needed by opencv/ultralytics under the hood
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY detect_live_endpoint.py .

# Fixed port so it's unambiguous what to enter as "Target Port" on hosts
# like Railway that ask for it explicitly (works the same on Hugging Face
# Spaces too, which also expects 7860 by default).
EXPOSE 7860
CMD ["uvicorn", "detect_live_endpoint:app", "--host", "0.0.0.0", "--port", "7860"]