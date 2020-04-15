ARG BUILD_FROM=hassioaddons/ubuntu-base:5.1.0
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

# Copy in extensions list
COPY vscode.extensions /root/vscode.extensions

# Setup base system
ARG BUILD_ARCH=amd64
# hadolint ignore=SC2181
RUN \
    apt-get update \
    \
    && apt-get install -y --no-install-recommends \
        ack=2.22-1 \
        bsdtar=3.2.2-3.1ubuntu0.6 \
        build-essential=12.4ubuntu1 \
        colordiff=1.0.18-1 \
        git=1:2.17.1-1ubuntu0.6 \
        iputils-ping=3:20161105-1ubuntu3 \
        locales=2.27-3ubuntu1 \
        mariadb-client=1:10.1.44-0ubuntu0.18.04.1 \
        mosquitto-clients=1.4.15-2ubuntu0.18.04.3 \
        net-tools=1.60+git20161116.90da8a0-1ubuntu1 \
        nmap=7.60-1ubuntu5 \
        openssh-client=1:7.6p1-4ubuntu0.3 \
        openssl=1.1.1-1ubuntu2.1~18.04.5 \
        python3-dev=3.6.7-1~18.04 \
        python3=3.6.7-1~18.04 \
        wget=1.19.4-1ubuntu2.2 \
        zsh=5.4.2-3ubuntu3.1 \
    \
    && curl https://bootstrap.pypa.io/get-pip.py | python3 \
    \
    && locale-gen en_US.UTF-8 \
    \
    && if [[ "${BUILD_ARCH}" = "aarch64" ]]; then ARCH="arm64"; fi \
    && if [[ "${BUILD_ARCH}" = "amd64" ]]; then ARCH="x86_64"; fi \
    && curl -J -L -o /tmp/code.tar.gz \
        "https://github.com/cdr/code-server/releases/download/3.1.1/code-server-3.1.1-linux-${ARCH}.tar.gz" \
    && mkdir -p /usr/local/lib/code-server \
    && tar zxvf \
        /tmp/code.tar.gz \
        --strip 1 -C /usr/local/lib/code-server \
    \
    && ln -s /usr/local/lib/code-server/code-server /usr/local/bin/code-server \
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
        sleep 60; \
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
    && find /usr/local/lib/python3.6/ -type d -name tests -depth -exec rm -rf {} \; \
    && find /usr/local/lib/python3.6/ -type d -name test -depth -exec rm -rf {} \; \
    && find /usr/local/lib/python3.6/ -name __pycache__ -depth -exec rm -rf {} \; \
    && find /usr/local/lib/python3.6/ -name "*.pyc" -depth -exec rm -f {} \; \
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
    io.hass.description="Visual Studio Code, accessible through the browser." \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="Visual Studio Code, accessible through the browser." \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Visual Studio Code" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/t/home-assistant-community-add-on-visual-studio-code/107863?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-vscode/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-vscode" \
    org.label-schema.vendor="Home Assistant Community Add-ons"
