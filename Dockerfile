FROM docker.io/gelbpunkt/python:gcc10
LABEL maintainer="https://github.com/Gelbpunkt/"

ENV PIP_NO_CACHE_DIR="off"
ENV PIP_INDEX_URL="https://pypi.python.org/simple"
ENV PIP_TRUSTED_HOST="127.0.0.1"
ENV VIRTUAL_ENV /env

# devpi user
RUN addgroup -S -g 1000 devpi \
    && adduser -S -u 1000 -h /data -s /sbin/nologin devpi devpi

RUN apk add --virtual .build --no-cache gcc musl-dev libffi-dev && \
    pip install --no-cache-dir \
        "devpi-client" \
        "devpi-web" \
        "devpi-server" && \
    apk del .build

EXPOSE 3141
VOLUME /data

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

USER devpi
ENV HOME /data
WORKDIR /data

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["devpi"]
