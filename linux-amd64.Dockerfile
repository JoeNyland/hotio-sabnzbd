FROM hotio/base@sha256:75b16518487eb5cf1b65f55132938dbee7f954d82b8c13d4b0175780ada14ff7

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 8080

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        software-properties-common && \
    add-apt-repository ppa:jcfp/sab-addons && \
    apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        par2-tbb \
        python3-pip python3-setuptools && \
# https://github.com/sabnzbd/sabnzbd/blob/develop/requirements.txt
    pip3 install --no-cache-dir --upgrade six sabyenc3 cheetah3 cryptography feedparser configobj cherrypy portend chardet gntp && \
# clean up
    apt purge -y software-properties-common python3-pip python3-setuptools && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG SABNZBD_VERSION=0662fd70e2d296e2ac33269345888e8d82e6e040

# install app
RUN curl -fsSL "https://github.com/sabnzbd/sabnzbd/archive/${SABNZBD_VERSION}.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    cd "${APP_DIR}" && python3 tools/make_mo.py && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
