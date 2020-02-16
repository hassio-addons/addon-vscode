#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Visual Studio Code
# Pre-configures the MySQL clients, if the service is available
# ==============================================================================
declare host
declare password
declare port
declare username

host=$(bashio::services "mysql" "host")
if bashio::var.has_value "${host}"; then
  password=$(bashio::services "mysql" "password")
  port=$(bashio::services "mysql" "port")
  username=$(bashio::services "mysql" "username")

  mkdir -p /root/.config
  {
    echo "[client]"
    echo "host=${host}"
    echo "password=\"${password}\""
    echo "port=${port}"
    echo "user=\"${username}\""
  } > /etc/mysql/conf.d/service.cnf
else
  bashio::log.info "The above error can be ignored if you don't have MariaDB installed"
fi
