ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:7.8.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Confiure locale
ENV \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    PIP_BREAK_SYSTEM_PACKAGES=1

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base system
ARG BUILD_ARCH=amd64
ARG CODE_SERVER_VERSION="4.98.2"
ARG HA_CLI_VERSION="4.37.0"

# Install packages
# TODO: If versions are set, will either run in devcontainers or HA but not both.
# TODO: Check if all are needed
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get full-upgrade -y \
    && apt-get install -y --no-install-recommends \
    ack \
    libarchive-tools  \
    colordiff \
    git \
    iputils-ping  \
    locales  \
    mariadb-client  \
    mosquitto-clients \
    net-tools \
    openssh-client  \
    openssl  \
    python3-dev  \
    python3 \
    zsh  \
    unzip \
    htop \
    nano \
    && rm -rf /var/lib/apt/lists/*

#System configuration
WORKDIR /data
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen && \
    update-locale LANG=en_US.UTF-8 && \
    curl https://bootstrap.pypa.io/get-pip.py | python3

# Install code-server
WORKDIR /tmp/
RUN curl -fsSL https://code-server.dev/install.sh | sh  -s -- --version ${CODE_SERVER_VERSION}

# Install Home Assistant CLI
WORKDIR /tmp/
# hadolint ignore=SC2086
RUN if [ "${BUILD_ARCH}" = "aarch64" ]; then HA_CLI_URL="https://github.com/home-assistant/cli/releases/download/${HA_CLI_VERSION}/ha_arm64";  \
    elif  [ "${BUILD_ARCH}" = "amd64" ]; then  HA_CLI_URL="https://github.com/home-assistant/cli/releases/download/${HA_CLI_VERSION}/ha_amd64";  fi \
    && curl  -J -L  -o ha  ${HA_CLI_URL} \
    && mv ./ha "/usr/bin/ha" \
    && chmod +x "/usr/bin/ha"

#Copy root file system
COPY rootfs /
RUN chown -R root:root /root \
    && chown -R root:root /etc/s6-overlay/s6-rc.d/ \
    && chmod 755 -R /etc/s6-overlay/s6-rc.d/

# Install Oh My ZSH
# hadolint ignore=SC2086
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"  \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && sed -i -e "s#bin/bash#bin/zsh#" /etc/passwd

WORKDIR /WORKDIR/


# Install Python packages
RUN  update-alternatives --install /usr/bin/python python /usr/bin/python3 10  && \
    pip3 install --no-cache-dir -r /usr/lib/code-server/defaults/requirements.txt

# Cleanup apt cache
RUN apt-get purge -y --auto-remove \
    libarchive-tools \
    python3-dev

# Cleanup files
RUN find /usr/local \
    \( -type d -a -name test -o -name tests -o -name '__pycache__' \) \
    -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
    -exec rm -rf '{}' + && \
    rm -fr /root/.cache /tmp/* /var/{cache,log}/* /var/lib/apt/lists/*

# Health check
HEALTHCHECK \
    CMD curl --fail http://127.0.0.1:1337/healthz || exit 1

# Build Final image
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
