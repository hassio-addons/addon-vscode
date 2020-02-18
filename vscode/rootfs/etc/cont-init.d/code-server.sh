#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Visual Studio Code
# Sets up code-server.
# ==============================================================================

# List of previous config hashes, to allow upgrade "default" configs.
readonly -a PREVIOUS_DEFAULT_CONFIG_HASHES=(
    86776df88391c3d94f79f62b430f9ff8538960628d5e04fb660165a5a46640d2e74f89cd68b3e6985dc59101ae2dda00a1e25aa48381acfd4736858c5f23878b
    2be4c50575c05711d30121c3a1320698d3dbb034523c481be3aad3b638af3e0a46113d8c3f8cfc1b0f01e4cc10f32da3a30feca161c31b5b27177aeb7231bf70
    d4745002643a0168f65bc5b465a9baff59af0fb4783b50553e1a4e8b3f1a569fc4905df19b7743f7f313a5809a5128d997fc4b5e0a0e5db0a01f47b3b7bec39d
    6ed36f832778926fa614fc12eec97b8f813bbb1a04f709769c9e5f54bc8e3cfc05a110155921a3b2ae47fc8389d24fa2bd385e4ce5a6c94850813791a6ac1c82
    944d9ba57968666353df7e9dc78ec5d94b9b052e1abf863b51bc1f372d9f35cb2d93259f153e9ab3b3dd1b520bfcd7bddb54803bcfd9eb65975ae8fb5553663c
    4ef960e3d6e795adda51d5cbeb18d309fee87ba5cd177292a21b5a70a71a4726ae7053c3793cddc6d63d3b4dacc180ad3ea12d005fc8d63a1bc4cb29f9a17f18
    c5b8acf06ef6d9a2435e9ddb92cb9fce7cfbfe4a2206b0e0c3c4ed514cc926f8d3c662e694a995d102b5ba939056f93201c220558e06e1cd0872bfb1995ba148
)

# Ensure persistent data folder exists.
if ! bashio::fs.directory_exists '/data/vscode'; then
    mkdir -p /data/vscode/extensions \
        || bashio::exit.nok "Could not create persistent storage folder."
fi

# Clean up copies of extensions we deliver from the persistent storage
while read -r ext; do
    extension="${ext%%#*}"
    # shellcheck disable=SC2086
    rm -f -r /data/vscode/extensions/${extension,,}*
done < /root/vscode.extensions

# Ensure user extensions folder exists
mkdir -p /data/vscode/extensions

# Sets up default user settings on first start.
if ! bashio::fs.file_exists '/data/vscode/User/settings.json'; then
    mkdir -p /data/vscode/User \
        || bashio::exit.nok "Could not create persistent storage folder."

    cp /root/.code-server/settings.json /data/vscode/User/settings.json
fi

# Upgrade settings.json is still default from previous version.
current=$(sha512sum /data/vscode/User/settings.json|cut -d " " -f 1)
if [[ " ${PREVIOUS_DEFAULT_CONFIG_HASHES[*]} " == *" ${current} "* ]]; then
    cp /root/.code-server/settings.json /data/vscode/User/settings.json
fi

# Workaround workspace bug for code-server.
# https://github.com/codercom/code-server/issues/121
if ! bashio::fs.file_exists '/data/vscode/Backups/workspaces.json'; then
    mkdir -p /data/vscode/Backups \
        || bashio::exit.nok "Could not create persistent storage folder."
    cp /root/.code-server/workspaces.json /data/vscode/Backups/workspaces.json
fi

# Workaround workspace bug for code-server (same as above, part 2).
# https://github.com/codercom/code-server/issues/121
if ! bashio::fs.file_exists '/data/vscode/User/workspaceStorage'; then
     mkdir -p /data/vscode/User/workspaceStorage \
         || bashio::exit.nok "Could not create persistent storage folder."
fi
