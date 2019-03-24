#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Visual Studio Code
# This files check if all user configuration requirements are met
# ==============================================================================

# Ensure persistent data folder exists
if ! bashio::fs.directory_exists '/data/vscode'; then
    mkdir -p /data/vscode/extensions \
        || bashio::exit.nok "Could not create persistent storage folder."
fi

# Copy in the extensions we deliver
cp -R /root/.code-server/extensions/* /data/vscode/extensions
