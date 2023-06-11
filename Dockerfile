FROM python:3.8-slim-buster

# Install system-level dependencies
RUN apt-get update \
    && apt-get install -y \
        apt-transport-https \
        software-properties-common \

RUN apt-get update && \
    apt-get install -y \
        libgl1-mesa-glx \

# Set working directory
WORKDIR /app

# Copy application files     
COPY . .

# Install Python dependencies       
RUN pip install -r requirements.txt

CMD ["python", "app.py"]
