# Library of Strigo init script snippets


## Suggested practices to write the scripts

### Write elementary script

A script should had a single ability/functionality (support of docker, installation of code_server and some extensions, install nvm, install pyenv+python+poetry).
Then, when creating a new script to initialize a new formation, one should simply concatenate the needed elementary scripts.

### Define optional variables at the beginning of the script

If your script allows some form of customization (version to install, extension names, etc.), one way to ease the integration of a script's code can be:

* to **define some variables at the beginning of the script**, like:

```sh
# code_server_version=3.7.2
# code_server_extensions="ms-azuretools.vscode-docker coenraads.bracket-pair-colorizer-2"
```

* to **write the remainder of the script without any form of customization** (just handling the cases where some variables are not defined, by using default values or skipping instructions), **so that it can be copy-pasted as is**:

```sh
# Install code-server (default values)
code_server_version=${code_server_version:-3.9.2}
curl -fsSLo /tmp/code-server.deb "https://github.com/cdr/code-server/releases/download/v${code_server_version}/code-server_${code_server_version}_amd64.deb"

# [...]

# Install extensions, if any (skips instruction if there are none)
if [[ $code_server_extensions && ${code_server_extensions-_} ]]; then
  code_server_extensions_array=($code_server_extensions)
  for code_server_extension in ${code_server_extensions_array[@]}; do
    sudo -iu ubuntu code-server code-server --install-extension ${code_server_extension}
  done
fi
```

### Tips, how-tos

* use `/home/ubuntu` explicitely instead of `$HOME` because the script is executed with the `root` user (value of `$HOME` is `/root`) whereas the trainees and trainers are connected to their VM as the `ubuntu` user

* create new file with multiline content (`cat << EOF >`):

```sh
cat << EOF > /home/ubuntu/.config/code-server/config.yaml
bind-addr: {{ .STRIGO_RESOURCE_DNS }}:9999
password: '{{ .STRIGO_WORKSPACE_ID }}'
EOF
```

* append multiline content to an existing file (`cat << EOF >>`:

```sh
cat << EOF >> /home/ubuntu/.config/code-server/config.yaml
auth: password
disable-telemetry: true
EOF
```

* append (or create a new file) content to a file **without interpretation of the $... commands** (`cat <<\EOF >`):

```sh
cat <<\EOF >> /home/ubuntu/.bashrc
export PATH="$HOME/.poetry/bin:$PATH"
EOF
```

Without the `\` in front of `EOF`, `$HOME` and `$PATH` would be interpreted before the addition of the content to `~/.bashrc`

* in your final strigo script, make sure to **install docker** (which adds the ubuntu user to the docker group) **before any other service bound to interact with docker**. For example: install `code-server` after `docker` if you plan to use an extension to manage `docker` repositories, images and containers; in this case the ubuntu user is already in the `docker` group when `code-server` is launched (and the extension works properly)

* the cloud-init output log files capture console outputs while the strigo labs VM initializes, so it can help debugging your initialization script following a launch if the instance does not behave the way you intended:

```sh
tail -n 20 /var/log/cloud-init-output.log
tail -n 20 /var/log/cloud-init.log
```
