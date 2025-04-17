#!/usr/bin/env bash
# This file is a place to store exported functions for VS-Code tasks.

# shellcheck source=./PATHS.sh
source "/etc/s6-overlay/s6-rc.d/paths.sh"

show_vars() {
    # echos all env vars to the log
    bashio::log.info "ENV VARS:"
    set -o posix ; set | while IFS='' read -r line
    do
        echo "$line"
    done
}

export -f show_vars
