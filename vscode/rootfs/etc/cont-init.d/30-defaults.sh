#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Visual Studio Code
# Updates/installs build-in extensions and set up initial user configuration.
# ==============================================================================

# Ensure persistent data folder exists
if ! bashio::fs.directory_exists '/data/vscode'; then
    mkdir -p /data/vscode/extensions \
        || bashio::exit.nok "Could not create persistent storage folder."
fi

# Copy in the extensions we deliver
cp -R /root/.code-server/extensions/* /data/vscode/extensions

# Sets up default user settings on first start.
if ! bashio::fs.file_exists '/data/vscode/User/settings.json'; then
    mkdir -p /data/vscode/User \
        || bashio::exit.nok "Could not create persistent storage folder."

    cp -R /root/.code-server/settings.json /data/vscode/User/settings.json
fi

# Workaround workspace bug for code-server
# https://github.com/codercom/code-server/issues/121
if ! bashio::fs.file_exists '/data/vscode/Backups/workspace.json'; then
    mkdir -p /data/vscode/Backups \
        || bashio::exit.nok "Could not create persistent storage folder."
    touch /data/vscode/Backups/workspace.json
fi
