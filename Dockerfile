FROM python:3.12.5-slim-bookworm@sha256:59c7332a4a24373861c4a5f0eec2c92b87e3efeb8ddef011744ef9a751b1d11c

ENV USER=comfyui \
    GROUP=comfyui \
    PIP_USER=true
ENV APP_HOME=/app/$USER
ENV PATH=$APP_HOME/.local/bin:$PATH

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN groupadd -r --gid 999 $GROUP && \
    useradd --no-log-init -r --uid 999 -d $APP_HOME --create-home -g $GROUP $USER && \
    rm -rf /root/.cache

WORKDIR $APP_HOME

COPY --chown=comfyui:comfyui ./ComfyUI .

USER $USER

RUN pip install --no-cache -r requirements.txt && \
    rm -rf .cache

VOLUME $APP_HOME/custom_nodes $APP_HOME/models $APP_HOME/output
EXPOSE 8188

ENTRYPOINT ["python", "main.py"]
CMD ["--listen"]
