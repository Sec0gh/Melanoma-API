FROM python:3.8-slim-buster

# Install system-level dependencies
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    build-essential \
    zlib1g-dev \
    libjpeg-dev \  
    libtiff5-dev \
    libjasper-dev \
    libpng12-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libffi-dev \   
    libopenblas-dev \
    liblapack-dev \
    libboost-all-dev   
 && rm -rf /var/lib/apt/lists/*    

# Setup TensorRT and CUDA
RUN wget https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/nvidia-machine-learning-repo-ubuntu1604_1.0.0-1_amd64.deb   
RUN dpkg -i nvidia*.deb
RUN apt-get update && apt-get install -y tensorrt   

# Build TensorFlow from source
RUN git clone https://github.com/tensorflow/tensorflow \
RUN bazel build --config=opt --copt=-mavx2 --copt=-mavx --copt=-mfma --config=monolithic --define=using_avx=true tensorflow/tools/pip_package:build_pip_package

# Set working directory
WORKDIR /app

# Copy application files     
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Start application 
CMD ["python", "app.py"]