FROM python:3.12.5-slim-bookworm@sha256:59c7332a4a24373861c4a5f0eec2c92b87e3efeb8ddef011744ef9a751b1d11c

WORKDIR /usr/local/ComfyUI

RUN pip install --no-cache torch torchvision torchaudio
RUN --mount=type=bind,source=ComfyUI/requirements.txt,target=/tmp/requirements.txt \
    pip install --no-cache --requirement /tmp/requirements.txt && \
    rm -rf /root/.cache

# RUN groupadd -r comfyui && useradd --no-log-init -r -g comfyui comfyui
# USER comfyui

COPY ./ComfyUI .

VOLUME /usr/local/ComfyUI/models /usr/local/ComfyUI/output

EXPOSE 8188

ENTRYPOINT ["python", "main.py"]
CMD ["--listen"]
