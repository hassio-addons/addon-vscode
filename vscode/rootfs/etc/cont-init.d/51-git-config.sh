#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Visual Studio Code
# Sets up the users git global config to be persistent
# ==============================================================================
readonly GIT_USER_PATH=/data/git

if ! bashio::fs.directory_exists "${GIT_USER_PATH}"; then
    mkdir -p "${GIT_USER_PATH}" \
        || bashio::exit.nok 'Failed to create a persistent git folder'

    chmod 700 "${GIT_USER_PATH}" \
        || bashio::exit.nok \
            'Failed setting permissions on persistent git folder'
fi

if ! bashio::fs.file_exists "${GIT_USER_PATH}/.gitconfig"; then
    touch "${GIT_USER_PATH}/.gitconfig" \
        || bashio::exit.nok 'Failed to create .gitconfig'
fi

ln -s "${GIT_USER_PATH}/.gitconfig" ~/.gitconfig
