#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Visual Studio Code
# Persists user settings and installs custom user packages.
# ==============================================================================
readonly GIT_USER_PATH=/data/git
readonly SSH_USER_PATH=/data/.ssh

# Store SSH settings in add-on data folder
if ! bashio::fs.directory_exists "${SSH_USER_PATH}"; then
    mkdir -p "${SSH_USER_PATH}" \
        || bashio::exit.nok 'Failed to create a persistent .ssh folder'

    chmod 700 "${SSH_USER_PATH}" \
        || bashio::exit.nok \
            'Failed setting permissions on persistent .ssh folder'
fi
ln -s "${SSH_USER_PATH}" ~/.ssh

# Store user GIT settings in add-on data folder
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

# Install user configured/requested packages
if bashio::config.has_value 'packages'; then
    apt update \
        || bashio::exit.nok 'Failed updating Ubuntu packages repository indexes'

    for package in $(bashio::config 'packages'); do
        apt-get install -y "$package" \
            || bashio::exit.nok "Failed installing package ${package}"
    done
fi

# Executes user configured/requested commands on startup
if bashio::config.has_value 'init_commands'; then
    while read -r cmd; do
        eval "${cmd}" \
            || bashio::exit.nok "Failed executing init command: ${cmd}"
    done <<< "$(bashio::config 'init_commands')"
fi
