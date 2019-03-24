#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Visual Studio Code
# Links some common directories to the user's home folder for convenience
# ==============================================================================
readonly -a directories=(addons backup config share ssl)

for dir in "${directories[@]}"; do
    ln -s "/${dir}" "${HOME}/${dir}" \
        || bashio::log.warning "Failed linking common directory: ${dir}"
done
