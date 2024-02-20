FROM nvidia/cuda:11.0.3-cudnn8-devel-ubuntu18.04

RUN apt-get clean && apt-get update && apt-get install -y \
    wget
# 创建 Anaconda 环境
RUN wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh && \
    chmod +x Anaconda3-2021.11-Linux-x86_64.sh && \
    bash Anaconda3-2021.11-Linux-x86_64.sh && \
    rm Anaconda3-2021.11-Linux-x86_64.sh \

ENV PATH /opt/conda/bin:$PATH
RUN conda create -n deformable_detr python=3.7 pip
SHELL ["conda", "run", "-n", "deformable_detr", "/bin/bash", "-c"]

# 激活环境并安装 PyTorch 和 torchvision
RUN conda install pytorch==1.7.0 torchvision==0.8.0 torchaudio==0.7.0 cudatoolkit=11.0 -c pytorch

# 其他依赖
COPY requirements.txt .
RUN pip install -r requirements.txt

# 编译 CUDA 运算符
WORKDIR /app/models/ops
COPY ./models/ops/make.sh .
COPY ./models/ops/test.py .
RUN sh ./make.sh && python test.py

# 设置工作目录
WORKDIR /app
