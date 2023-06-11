FROM python:3.8-slim-buster
FROM nvidia/cudagl:11.4.2-devel-ubuntu20.04

# Install system-level dependencies
RUN apt-get update \
    && apt-get install -y python3-pip \
    && pip3 install --no-cache-dir -r requirements.txt
    && apt-get install -y libgl1-mesa-glx \

RUN rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy application files
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Start application
CMD ["python", "app.py"]
