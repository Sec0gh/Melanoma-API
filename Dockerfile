FROM python:3.8-slim-buster

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6

# Set working directory
WORKDIR /app

# Copy requirements.txt to container
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files to container
COPY . .

# Expose port 6540
EXPOSE 6540

# Start application
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:6540"]
