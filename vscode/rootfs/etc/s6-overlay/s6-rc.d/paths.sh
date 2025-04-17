#!/usr/bin/env bash
# this file is to prevent spagetti paths
# shellcheck disable=SC2034

readonly DEFAULT_CONFIG_PATH="/data/vscode"
readonly DEFAULT_FILES_PATH="/var/lib/code-server/defaults"
readonly ROOT_CODE_SERVER_CONFIG_PATH="/root/.config/code-server/" # needed for code-server to cleanly
readonly CODE_SERVER_EXTENSIONS_INSTALL_PATH="$DEFAULT_CONFIG_PATH/extensions"
readonly CODE_SERVER_EXTENSIONS_LIST="$DEFAULT_CONFIG_PATH/vscode.extensions"
readonly CODE_SERVER_WORKSPACE_DIR="/data/workspace"
readonly CODE_SERVER_WORKSPACE_FILE="$CODE_SERVER_WORKSPACE_DIR/SERVER.code-workspace"
readonly CODE_SERVER_VSCODE_DIR="$CODE_SERVER_WORKSPACE_DIR/.vscode"
readonly CODE_SERVER_VSCODE_TASKS="$CODE_SERVER_VSCODE_DIR/tasks.json"

readonly CUSTOM_BASH_SCRIPTS_PATH="/data/vscode/custom_boot_scripts"
readonly -a DIRECTORIES=(backup homeassistant media share ssl)

readonly GIT_USER_PATH=/data/git
readonly SSH_USER_PATH=/data/.ssh
readonly ZSH_HISTORY_FILE=/root/.zsh_history
readonly ZSH_HISTORY_PERSISTANT_FILE=/data/.zsh_history

readonly USER_CUSTOM_DIR=$CUSTOM_BASH_SCRIPTS_PATH/storage
