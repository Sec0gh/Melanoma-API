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

# Add NVIDIA package repository
RUN wget -O /etc/apt/trusted.gpg.d/nvidia-cuda.gpg https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
RUN echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64 /" >> /etc/apt/sources.list.d/nvidia-machine-learning.list


# Setup TensorRT and CUDA
RUN wget https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64/libnvinfer7_7.2.3-1+cuda11.4_amd64.deb
RUN wget https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64/libnvinfer-dev_7.2.3-1+cuda11.4_amd64.deb
RUN wget https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64/libnvinfer-plugin7_7.2.3-1+cuda11.4_amd64.deb
RUN dpkg -i libnvinfer*.deb
RUN apt-get update && apt-get install -y \
        tensorrt   

# Build TensorFlow from source
RUN git clone https://github.com/tensorflow/tensorflow \
RUN bazel build --config=opt --copt=-mavx2 --copt=-mavx --copt=-mfma --config=monolithic --define=using_avx=true tensorflow/tools/pip_package:build_pip_package

# Set working directory
WORKDIR /app

# Copy application files     
COPY . .

# Install Python dependencies       
RUN pip install -r requirements.txt

CMD ["python", "app.py"]
