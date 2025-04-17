#!/usr/bin/env bash
# this file is to prevent spagetti paths
# shellcheck disable=SC2034

export DEFAULT_CONFIG_PATH="/data/vscode"
export  DEFAULT_FILES_PATH="/var/lib/code-server/defaults"
export ROOT_CODE_SERVER_CONFIG_PATH="/root/.config/code-server/" # needed for code-server to cleanly
export CODE_SERVER_EXTENSIONS_INSTALL_PATH="$DEFAULT_CONFIG_PATH/extensions"
export CODE_SERVER_EXTENSIONS_LIST="$DEFAULT_CONFIG_PATH/vscode.extensions"
export CODE_SERVER_WORKSPACE_DIR="/data/workspace"
export CODE_SERVER_WORKSPACE_FILE="$CODE_SERVER_WORKSPACE_DIR/SERVER.code-workspace"
export CODE_SERVER_VSCODE_DIR="$CODE_SERVER_WORKSPACE_DIR/.vscode"
export CODE_SERVER_VSCODE_TASKS="$CODE_SERVER_VSCODE_DIR/tasks.json"
export -a DIRECTORIES=(addons addon_configs backup config media share ssl)
