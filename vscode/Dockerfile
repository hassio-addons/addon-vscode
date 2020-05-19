ARG BUILD_FROM=hassioaddons/debian-base:3.2.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Confiure locale
ENV \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy Python requirements file
COPY requirements.txt /tmp/requirements.txt

# Copy in extensions list
COPY vscode.extensions /root/vscode.extensions

# Setup base system
ARG BUILD_ARCH=amd64
# hadolint ignore=SC2181
RUN \
    apt-get update \
    \
    && apt-get install -y --no-install-recommends \
        ack=2.24-1 \
        bsdtar=3.3.3-4+deb10u1 \
        build-essential=12.6 \
        colordiff=1.0.18-1 \
        git=1:2.20.1-2+deb10u3 \
        iputils-ping=3:20180629-2+deb10u1 \
        locales=2.28-10 \
        mariadb-client=1:10.3.22-0+deb10u1 \
        mosquitto-clients=1.5.7-1+deb10u1 \
        net-tools=1.60+git20180626.aebd88e-1 \
        nmap=7.70+dfsg1-6 \
        openssh-client=1:7.9p1-10+deb10u2 \
        openssl=1.1.1d-0+deb10u3 \
        python3-dev=3.7.3-1 \
        python3=3.7.3-1 \
        wget=1.20.1-1.1 \
        zsh=5.7.1-1 \
    \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen \
    \
    && curl https://bootstrap.pypa.io/get-pip.py | python3 \
    \
    && if [[ "${BUILD_ARCH}" = "aarch64" ]]; then ARCH="arm64"; fi \
    && if [[ "${BUILD_ARCH}" = "amd64" ]]; then ARCH="amd64"; fi \
    && curl -J -L -o /tmp/code.tar.gz \
        "https://github.com/cdr/code-server/releases/download/v3.3.1/code-server-3.3.1-linux-${ARCH}.tar.gz" \
    && mkdir -p /usr/local/lib/code-server \
    && tar zxvf \
        /tmp/code.tar.gz \
        --strip 1 -C /usr/local/lib/code-server \
    \
    && ln -s /usr/local/lib/code-server/bin/code-server /usr/local/bin/code-server \
    \
    && mkdir -p /root/.code-server/extensions \
    && while read -r ext; do  \
        extention="${ext%%#*}" \
        vendor="${extention%%.*}"; \
        slug="${extention#*.}"; \
        version="${ext##*#}"; \
        \
        echo "Installing vscode extension: ${slug} by ${vendor} @ ${version} "; \
        \
        echo "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${vendor}/vsextensions/${slug}/${version}/vspackage"; \
        curl -JL --retry 5 -o "/tmp/${extention}-${version}.vsix" \
            -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36" \
            "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${vendor}/vsextensions/${slug}/${version}/vspackage"; \
        mkdir -p "/root/.code-server/extensions/${extention}-${version}"; \
        bsdtar --strip-components=1 -xf "/tmp/${extention}-${version}.vsix" \
                    -C "/root/.code-server/extensions/${extention}-${version}" extension; \
        [ $? -ne 0 ] && exit 1; \
        sleep 90; \
    done < /root/vscode.extensions \
    && ls -la /root/.code-server/extensions/ \
    \
    && curl -L -s -o /usr/bin/ha \
        "https://github.com/home-assistant/cli/releases/download/4.3.0/ha_${BUILD_ARCH}" \
    && chmod a+x /usr/bin/ha \
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
        bsdtar \
        build-essential \
        python3-dev \
    \
    && find /usr/local/lib/python3.7/ -type d -name tests -depth -exec rm -rf {} \; \
    && find /usr/local/lib/python3.7/ -type d -name test -depth -exec rm -rf {} \; \
    && find /usr/local/lib/python3.7/ -name __pycache__ -depth -exec rm -rf {} \; \
    && find /usr/local/lib/python3.7/ -name "*.pyc" -depth -exec rm -f {} \; \
    \
    && rm -fr \
        /tmp/* \
        /var/{cache,log}/* \
        /var/lib/apt/lists/*

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Visual Studio Code" \
    io.hass.description="Visual Studio Code, accessible through the browser" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.title="Visual Studio Code" \
    org.opencontainers.image.description="Visual Studio Code, accessible through the browser" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/hassio-addons/addon-vscode" \
    org.opencontainers.image.documentation="https://github.com/hassio-addons/addon-vscode/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
