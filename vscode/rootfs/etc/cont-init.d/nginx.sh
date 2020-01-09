#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Visual Studio Code
# Configures NGINX for use with code-server
# ==============================================================================
declare port
declare allow
declare certfile
declare hassio_dns
declare ingress_interface
declare ingress_port
declare keyfile

port=$(bashio::addon.port 80)
if bashio::var.has_value "${port}"; then
    bashio::config.require.ssl

    if bashio::config.true 'ssl'; then
        certfile=$(bashio::config 'certfile')
        keyfile=$(bashio::config 'keyfile')

        mv /etc/nginx/servers/direct-ssl.disabled /etc/nginx/servers/direct.conf
        sed -i "s#%%certfile%%#${certfile}#g" /etc/nginx/servers/direct.conf
        sed -i "s#%%keyfile%%#${keyfile}#g" /etc/nginx/servers/direct.conf

    else
        mv /etc/nginx/servers/direct.disabled /etc/nginx/servers/direct.conf
    fi
fi

ingress_port=$(bashio::addon.ingress_port)
ingress_interface=$(bashio::addon.ip_address)
allow=$(bashio::config 'allow')
sed -i "s/%%port%%/${ingress_port}/g" /etc/nginx/servers/ingress.conf
sed -i "s/%%interface%%/${ingress_interface}/g" /etc/nginx/servers/ingress.conf
sed -i "s/%%allow%%/${allow//\//\\/}/g" /etc/nginx/servers/ingress.conf

hassio_dns=$(bashio::dns.host)
sed -i "s/%%hassio_dns%%/${hassio_dns}/g" /etc/nginx/includes/resolver.conf
