#!/usr/bin/env bash
ENABLE=false
# shellcheck source=../paths.sh
source "/etc/s6-overlay/s6-rc.d/paths.sh"

if [ "$ENABLE" = true ]; then
    echo "Custom Script"
fi
