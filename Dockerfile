FROM nvidia/cuda:12.1.0-base-ubuntu22.04 AS vllm-base

# libnccl required for ray
RUN apt-get update -y \
    && apt-get install -y python3-pip

WORKDIR /workspace
COPY requirements.txt requirements.txt
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt

FROM vllm-base AS vllm-openai

# install additional dependencies for openai api server
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install accelerate

COPY --from=build /workspace/vllm/*.so /workspace/vllm/
COPY vllm vllm

ENTRYPOINT ["python3", "-m", "vllm.entrypoints.openai.api_server"]
