#!/usr/bin/env bash

# shellcheck source=./PATHS.sh
source "/etc/s6-overlay/s6-rc.d/paths.sh"

# Vars
ENABLE=false
PULL=true
openMQTT_git=https://github.com/1technophile/OpenMQTTGateway.git
openmqtt_src_files="$USER_CUSTOM_DIR"/OpenMQTTGateway


run (){
    if [ "$ENABLE" = false ]; then
        exit 0
    fi

    git_src
    export -f mqtt_push
}

git_src() {
    if [ ! -d "$openmqtt_src_files" ]; then
        git clone "$openMQTT_git" "$openmqtt_src_files"|| bashio::log.warning "Failed to git clone"
    else
        if [ "$PULL" = true ]; then
            cd "$openmqtt_src_files" || bashio::log.warning "Failed to change dir to $openmqtt_src_files"
            git pull || bashio::log.warning "Failed to git pull"
            cd "$CUSTOM_BASH_SCRIPTS_PATH" || "Failed to change dir back to boot scripts root"
        fi

    fi
}

mqtt_push() {
    local reason=${1}

    if test "$#" -ne 1; then
        echo "Error: You must provide exactly 1 arguments."
        exit 1
    fi

    cd "$openmqtt_src_files" || bashio::log.warning "Failed to change dir to $openmqtt_src_files"

    git git add .
    git commit -m "$reason"
    git push

    cd "$CUSTOM_BASH_SCRIPTS_PATH" || "Failed to change dir back to boot scripts root"
}

show_vars() {
    # echos all env vars
    bashio::log.info "ENV VARS:"
    set -o posix ; set | while IFS='' read -r line
    do
        echo "$line"
    done
}

run
