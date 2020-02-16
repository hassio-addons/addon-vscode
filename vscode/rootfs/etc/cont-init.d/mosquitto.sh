#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Visual Studio Code
# Pre-configures the Mosquitto clients, if the service is available
# ==============================================================================
declare host
declare password
declare port
declare username

host=$(bashio::services "mqtt" "host")
if bashio::var.has_value "${host}"; then
  password=$(bashio::services "mqtt" "password")
  port=$(bashio::services "mqtt" "port")
  username=$(bashio::services "mqtt" "username")

  mkdir -p /root/.config
  {
    echo "-h ${host}"
    echo "--pw ${password}"
    echo "--port ${port}"
    echo "--username ${username}"
  } > /root/.config/mosquitto_sub

  ln -s /root/.config/mosquitto_sub /root/.config/mosquitto_pub
  ln -s /root/.config/mosquitto_sub /root/.config/mosquitto_rr
else
  bashio::log.info "The above error can be ignored if you don't have Mosquitto installed"
fi
