FROM hotio/base@sha256:ef43d87e8de045f3d6f4f4a8d38ede7ff1151992844227d0d0ed04c70b077852

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
        python3-pip python3-setuptools build-essential python3-all-dev libffi-dev libssl-dev && \
# https://github.com/sabnzbd/sabnzbd/blob/develop/requirements.txt
    pip3 install --no-cache-dir --upgrade six sabyenc3 cheetah3 cryptography feedparser configobj cherrypy portend chardet gntp && \
# clean up
    apt purge -y software-properties-common python3-pip python3-setuptools build-essential python3-all-dev libffi-dev libssl-dev && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG SABNZBD_VERSION=17719b1b5bfec074ec30bb633eb956d2a27c2d6c

# install app
RUN curl -fsSL "https://github.com/sabnzbd/sabnzbd/archive/${SABNZBD_VERSION}.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    cd "${APP_DIR}" && python3 tools/make_mo.py && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
