FROM hotio/base@sha256:1e9d6c1a210c7c3f00efb9fde7f5c37047ca6cb024092ab5fa0d89a6cea26053
EXPOSE 8080

RUN apk add --no-cache unrar p7zip python3 py3-six py3-cryptography py3-chardet py3-feedparser py3-configobj py3-openssl && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing par2cmdline && \
    apk add --no-cache --virtual=build-dependencies py3-pip py3-setuptools gcc python3-dev musl-dev && \
    pip3 install --no-cache-dir --upgrade \
        sabyenc3 \
        cheetah3 \
        cherrypy \
        portend \
        notify2 && \
    apk del --purge build-dependencies

ARG VERSION
RUN curl -fsSL "https://github.com/sabnzbd/sabnzbd/archive/${VERSION}.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    cd "${APP_DIR}" && python3 tools/make_mo.py && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
