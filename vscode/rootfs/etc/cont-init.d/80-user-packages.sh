#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Visual Studio Code
# Install user configured/requested packages
# ==============================================================================
if bashio::config.has_value 'packages'; then
    apt update \
        || bashio::exit.nok 'Failed updating Ubuntu packages repository indexes'

    for package in $(bashio::config 'packages'); do
        apt add -y "$package" \
            || bashio::exit.nok "Failed installing package ${package}"
    done
fi
