#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Visual Studio Code
# Sets up the users .ssh folder to be persistent
# ==============================================================================
readonly SSH_USER_PATH=/data/.ssh

if ! bashio::fs.directory_exists "${SSH_USER_PATH}"; then
    mkdir -p "${SSH_USER_PATH}" \
        || bashio::exit.nok 'Failed to create a persistent .ssh folder'

    chmod 700 "${SSH_USER_PATH}" \
        || bashio::exit.nok \
            'Failed setting permissions on persistent .ssh folder'
fi

ln -s "${SSH_USER_PATH}" ~/.ssh
