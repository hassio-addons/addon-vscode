#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Visual Studio Code
# This files check if all user configuration requirements are met
# ==============================================================================
bashio::config.require.ssl

if ! bashio::config.true 'leave_front_door_open'; then
    if ! bashio::config.true 'i_like_to_be_pwned'; then
        bashio::config.require.safe_password
    else
        bashio::config.require.password
    fi
fi

if bashio::config.true 'leave_front_door_open' \
    && bashio::config.true 'ssl';
then
    bashio::log.fatal
    bashio::log.fatal "Due to a bug in code-server (which this add-on uses),"
    bashio::log.fatal "it is impossible to disable authentication while"
    bashio::log.fatal "using SSL."
    bashio::log.fatal
    bashio::log.fatal "Please enable authentication and set a password."
    bashio::log.fatal
    bashio::exit.nok
fi
