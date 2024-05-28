# Library of Strigo init script snippets

## Use of Strigo context

Strigo provides a way to inject some training session dependant variables through [Strigo context](http://help.strigo.io/en/articles/4242341-injecting-strigo-context-to-your-labs).

Those are not environment variables but a very simple templating mechanism (`{{ .STRIGO_XXX }}`) rendered when creating the machines.

Refer to [Variable Reference doc](http://help.strigo.io/en/articles/4242341-injecting-strigo-context-to-your-labs#variable-reference) to know the available variables and their meaning.

Some of the variables can be added as environment variables through the [`strigo.sh` script](scripts/strigo.sh) or [`strigo.ps1` Windows script](win_scripts/strigo.ps1).

Strigo interfaces buttons generate reverse proxies with a custom domain for each. This domain can be found by concatenating `.STRIGO_INSTANCE_ID` and `.STRIGO_RESOURCE_<x>_WEB_INTERFACE_<y>_ID` where `<x>` is the resource number and `<y>` is the webview number. Then you need to switch them to lowercase (Example: `https://kgqzbjtz2amdgnrsd-dthc88ohrtgnp76jd.rp.strigo.io/`).

For example, here is what is done in the Grafana training:
```shell
cat <<\EOF >> /etc/profile.d/00_strigo_context.sh
export GRAFANA_HOST=$(echo -n "{{ .STRIGO_INSTANCE_ID }}-{{ .STRIGO_RESOURCE_0_WEB_INTERFACE_2_ID }}.rp.strigo.io" | tr '[:upper:]' '[:lower:]')
EOF
```

## Windows machine

You need to start and end the init script in Strigo by `<powershell>` and `</powershell>` respectively. \
Or you can set `is_windows: true` in `strigo.json` if you use [`ztraining2strigo`](https://github.com/Zenika-Training/ztraining2strigo).

Use the script [`chocolatey.ps1`](win_scripts/chocolatey.ps1) to install chocolatey. \
You can then install any [available chocolatey package](https://community.chocolatey.org/packages) with the command `choco install <package_name>`. \
There are already available [`vscode.ps1`](win_scripts/vscode.ps1) for VSCode and [`intellijidea.ps1`](win_scripts/intellijidea.ps1) for IntelliJIDEA.

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

* the log files of the cloud-init capture outputs while the strigo labs VM initializes, so it can help debugging your initialization script following a launch if the instance does not behave the way you intended:

```sh
tail -n 20 /var/log/cloud-init-output.log
tail -n 20 /var/log/cloud-init.log
```

## Script customization

Please refer to the following documentation files for more details about how the scripts can be customized:

* [scripts/code-server.md](scripts/code-server.md)
* [scripts/projector.md](scripts/projector.md)
