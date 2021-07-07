FROM debian:bullseye-slim
MAINTAINER Spencer Bliven <spencer.bliven@gmail.com>
LABEL org.opencontainers.image.authors="spencer.bliven@gmail.com"

ENV DEFAULT_DOCKCROSS_IMAGE blivens/gaviewer

# supervisor-stdout 0.1.1 does not support python 3, so we install the latest from git
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git \
  libgl1-mesa-dri \
  menu \
  net-tools \
  openbox \
  sudo \
  supervisor \
  tint2 \
  x11-xserver-utils \
  x11vnc \
  xinit \
  xserver-xorg-video-dummy \
  websockify \
  x11-apps \
  libfltk1.3 libfltk-gl1.3 \
  mesa-utils \
  curl \
  unzip \
  procps \
  python3 \
  python3-pip && \
  update-alternatives --install /usr/bin/python python /usr/bin/python3 3 && \
  rm -f /usr/share/applications/x11vnc.desktop && \
  pip3 install git+https://github.com/coderanger/supervisor-stdout.git@973ba19967cdaf46d9c1634d1675fc65b9574f6e && \
  apt-get remove -y python3-pip && \
  apt-get autoremove -y && \
  apt-get -y clean autoclean && \
  rm -rf /var/lib/apt/lists/*

COPY etc/skel/.xinitrc /etc/skel/.xinitrc

RUN useradd -m -s /bin/bash user
USER user

RUN cp /etc/skel/.xinitrc /home/user/
USER root
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user

RUN git clone -bv1.2.0 https://github.com/kanaka/noVNC.git /opt/noVNC && \
  cd /opt/noVNC && \
  ln -s vnc.html index.html

RUN curl -o gaviewer.tar.gz 'https://geometricalgebra.org/downloads/gaviewer_linux_x64.tar.gz' && \
  tar xzf gaviewer.tar.gz && \
  rm gaviewer.tar.gz && \
  chmod +x gaviewer && \
  mv gaviewer /usr/bin/gaviewer

RUN cd /home/user/ && \
  curl -o figures.zip https://geometricalgebra.org/downloads/figures.zip && \
  unzip figures.zip && \
  rm figures.zip

# noVNC (http server) is on 6080, and the VNC server is on 5900
EXPOSE 6080 5900

COPY etc /etc
COPY usr /usr

ENV DISPLAY :0

WORKDIR /root

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

ENV APP "gaviewer"

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG IMAGE
ARG VCS_REF
ARG VCS_URL
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$IMAGE \
      org.label-schema.description="An image for running gaviewer in a graphical environment" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.schema-version="1.0"
