ARG BUILD_FROM=hassioaddons/ubuntu-base:3.1.2
###############################################################################
# Build container to get custom vscode extensions.
###############################################################################
# hadolint ignore=DL3006
FROM ${BUILD_FROM} as vscode

# Copy in extensions list
COPY vscode.extensions /root/vscode.extensions

# Install the actual VSCode to download configs and extensions
# hadolint ignore=DL3015
RUN \
    apt-get update \
    \
    && apt-get install -y --no-install-recommends \
        libx11-xcb1=2:1.6.4-3ubuntu0.2 \
        libasound2=1.1.3-5ubuntu0.2 \
    \
    && curl \
        -o vscode-amd64.deb \
        -L https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable \
    \
    && dpkg -i vscode-amd64.deb || true \
    && apt-get install -y -f \
    && rm -f vscode-amd64.deb \
    \
    && code -v --user-data-dir /root/.config/Code

RUN \
    while read -r ext; do \
        echo "Installing vscode extension: ${ext}"; \
        code \
            --user-data-dir /root/.config/Code \
            --install-extension "${ext%#*}"; \
    done < /root/vscode.extensions \
    && ls -la /root/.vscode/extensions

###############################################################################
# Build the actual add-on.
###############################################################################
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Confiure locale
ENV \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy Python requirements file
COPY requirements.txt /tmp/requirements.txt

# Setup base system
ARG BUILD_ARCH
RUN \
    apt-get update \
    \
    && apt-get install -y --no-install-recommends \
        build-essential=12.4ubuntu1 \
        colordiff=1.0.18-1 \
        git=1:2.17.1-1ubuntu0.4 \
        libnginx-mod-http-lua=1.14.0-0ubuntu1.2 \
        locales=2.27-3ubuntu1 \
        luarocks=2.4.2+dfsg-1 \
        mosquitto-clients=1.4.15-2ubuntu0.18.04.3 \
        net-tools=1.60+git20161116.90da8a0-1ubuntu1 \
        nginx=1.14.0-0ubuntu1.2 \
        nmap=7.60-1ubuntu5 \
        openssh-client=1:7.6p1-4ubuntu0.3 \
        openssl=1.1.0g-2ubuntu4.3 \
        python3-dev=3.6.7-1~18.04 \
        python3=3.6.7-1~18.04 \
        wget=1.19.4-1ubuntu2.2 \
        zsh=5.4.2-3ubuntu3.1 \
        ack=2.22-1 \
    \
    && luarocks install lua-resty-http 0.13-0 \
    \
    && curl https://bootstrap.pypa.io/get-pip.py | python3 \
    \
    && locale-gen en_US.UTF-8 \
    \
    && curl -J -L -o /tmp/code.tar.gz \
        "https://github.com/cdr/code-server/releases/download/1.1156-vsc1.33.1/code-server1.1156-vsc1.33.1-linux-x64.tar.gz" \
    && tar zxvf \
        /tmp/code.tar.gz \
        --strip 1 -C /tmp \
    \
    && mv /tmp/code-server /usr/local/bin/code-server \
    && chmod a+x /usr/local/bin/code-server  \
    \
    && curl -L -s -o /usr/bin/hassio \
        "https://github.com/home-assistant/hassio-cli/releases/download/2.2.0/hassio_${BUILD_ARCH}" \
    && chmod a+x /usr/bin/hassio \
    \
    && git clone --branch master --single-branch --depth 1 \
        "git://github.com/robbyrussell/oh-my-zsh.git" ~/.oh-my-zsh \
    \
    && git clone --branch master --single-branch --depth 1 \
        "git://github.com/zsh-users/zsh-autosuggestions" \
        ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
    && git clone --branch master --single-branch --depth 1 \
        "git://github.com/zsh-users/zsh-syntax-highlighting.git" \
        ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
    \
    && sed -i -e "s#bin/bash#bin/zsh#" /etc/passwd \
    \
    && update-alternatives \
        --install /usr/bin/python python /usr/bin/python3 10 \
    \
    && pip3 install --no-cache-dir -r /tmp/requirements.txt \
    \
    && apt-get purge -y --auto-remove \
        build-essential \
        luarocks \
        python3-dev \
    \
    && find /usr/local/lib/python3.6/ -type d -name tests -depth -exec rm -rf {} \; \
    && find /usr/local/lib/python3.6/ -type d -name test -depth -exec rm -rf {} \; \
    && find /usr/local/lib/python3.6/ -name __pycache__ -depth -exec rm -rf {} \; \
    && find /usr/local/lib/python3.6/ -name "*.pyc" -depth -exec rm -f {} \; \
    \
    && rm -fr \
        /tmp/* \
        /etc/nginx \
        /var/{cache,log}/* \
        /var/lib/apt/lists/* \
    \
    && mkdir -p /var/log/nginx \
    && touch /var/log/nginx/error.log

# Copy root filesystem
COPY rootfs /

# Get the custom extensions
COPY --from=vscode /root/.vscode/extensions /root/.code-server/extensions

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Visual Studio Code" \
    io.hass.description="Visual Studio Code, accessible through the browser." \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="Visual Studio Code, accessible through the browser." \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Visual Studio Code" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-vscode/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-vscode" \
    org.label-schema.vendor="Community Hass.io Add-ons"
