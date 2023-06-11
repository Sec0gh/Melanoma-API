FROM python:3.9-slim-buster
WORKDIR /app
COPY requirements.txt .
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*
RUN wget https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb http://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libedgetpu1-std \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libnvinfer7=7.x.x.x-1+cuda11.x \
    libnvinfer-dev=7.x.x.x-1+cuda11.x \
    libnvinfer-plugin7=7.x.x.x-1+cuda11.x && \
    rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:7406", "app:app"]
