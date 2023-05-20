FROM alpine:edge

ARG MODS_VERSION="v3"
ARG PKG_INST_VERSION="v1"

RUN   apk add --no-cache \
    shadow  \
    bash \
    nano \
    curl \
    jq \
    shadow \
    s6 \
    s6-overlay \
    tzdata && \
    echo "**** create abc user and make our folders ****" && \
    useradd -u 6000 -U -d /config -s /bin/false abc && \
    mkdir -pv \
    /tftpboot \
    /config \
    /defaults \
    /lsiopy && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

ADD --chmod=744 "https://raw.githubusercontent.com/linuxserver/docker-mods/mod-scripts/docker-mods.${MODS_VERSION}" "/docker-mods"
ADD --chmod=744 "https://raw.githubusercontent.com/linuxserver/docker-mods/mod-scripts/package-install.${PKG_INST_VERSION}" "/etc/s6-overlay/s6-rc.d/init-mods-package-install/run"

ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
  HOME="/root" \
  TERM="xterm" \
  S6_CMD_WAIT_FOR_SERVICES_MAXTIME="0" \
  S6_VERBOSITY=1 \
  S6_STAGE2_HOOK=/docker-mods \
  VIRTUAL_ENV=/lsiopy \
  PATH="/lsiopy/bin:$PATH"

# add local files
COPY root/ /

ENTRYPOINT ["/init"] 
