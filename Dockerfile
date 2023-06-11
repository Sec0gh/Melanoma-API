FROM python:3.8-slim-buster

# Install system-level dependencies
RUN apt-get update \
    && apt-get install -y \
        apt-transport-https \
        software-properties-common \
        wget

RUN apt-get update && \
    apt-get install -y \
        libgl1-mesa-glx \
        libglib2.0-0 \
        build-essential \
        zlib1g-dev \
        libjpeg-dev \
        libtiff5-dev \
        libpng-dev \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libv4l-dev \
        libxvidcore-dev \
        libx264-dev \
        libffi-dev


# Set working directory
WORKDIR /app

# Copy application files     
COPY . .

# Install Python dependencies       
RUN pip install -r requirements.txt

CMD ["python", "app.py"]
