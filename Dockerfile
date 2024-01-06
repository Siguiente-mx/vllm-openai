FROM nvidia/cuda:12.1.0-base-ubuntu22.04 AS vllm-base

# libnccl required for ray
RUN apt-get update -y \
    && apt-get install -y python3 python3-pip

WORKDIR /workspace
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

FROM vllm-base AS vllm-openai

# install additional dependencies for openai api server
RUN pip install accelerate
COPY vllm vllm

CMD ["python3", "-m", "vllm.entrypoints.openai.api_server"]
