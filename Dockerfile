FROM ghcr.io/selkies-project/selkies/base:latest-debiantrixie AS builder
ARG DEBIAN_FRONTEND="noninteractive"

# The base ships its setuid and setgid files owned by root, and dpkg replaces a
# file by hardlinking the old one aside first -- which the kernel denies uid
# 1000 on a setuid file it does not own. Released for the layers below, an
# archive update to util-linux, shadow, sudo, fuse3, or dbus is just another
# package; without this it fails the layer that takes it.
USER 0
SHELL ["/bin/sh", "-c"]
RUN selkies-privileged-files release
USER 1000
SHELL ["/usr/bin/fakeroot", "--", "/bin/sh", "-c"]

# Kill big stuff that we dont actually need
# RUN apt-get purge --allow-remove-essential -y \
#       fonts-noto-extra \
#       fonts-noto-cjk-extra \
#       fonts-noto-cjk \
#       fonts-noto-ui-extra \
#       fonts-urw-base35 \
#       fonts-freefont-ttf \
#       intel-media-va-driver-non-free \
#       intel-gpu-tools \
#       gcc-14-x86-64-linux-gnu \
#       cpp-14-x86-64-linux-gnu \
#       libgcc-14-dev \
#       binutils-common \
#       git \
#       vim-runtime \
#       '.*:i386' && \
#     apt-get autoremove -y --purge && \
#     dpkg --remove-architecture i386 || true

# USER 0
# SHELL ["/bin/sh", "-c"]
# # DPKG cant remove it on its own
# RUN rm -rf /lib32 /libx32
# USER 1000
# SHELL ["/usr/bin/fakeroot", "--", "/bin/sh", "-c"]

RUN curl -Lo starlight.deb https://github.com/ss14Starlight/Starlight.Launcher/releases/download/v2.3.4/Starlight.Launcher-linux-x64-2.3.4.deb && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      openbox \
      xfce4-terminal \
      ./starlight.deb \
      libwebkit2gtk-4.1-0 \
      yad && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && rm starlight.deb

SHELL ["/bin/sh", "-c"]
USER root
RUN selkies-privileged-files restore

COPY desktop-run.sh /etc/service/desktop/run
COPY prepare.sh /usr/local/bin/prepare.sh
RUN chown -R 1000:1000 /etc/service/desktop /usr/local/bin/prepare.sh && \
    chmod +x /etc/service/desktop/run /usr/local/bin/prepare.sh

USER 1000
