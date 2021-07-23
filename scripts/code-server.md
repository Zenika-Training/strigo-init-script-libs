
## Code-server script documentation

The code-server installation and initialization script (see [code-server.sh](code-server.sh)) allows different levels of customization:

### Code-server version

Specify the **desired version of `code-server`** by defining the `code_server_version` variable.
Otherwise it installs the latest release.
Example:

```sh
code_server_version='3.10.2'
```

### Code-server extensions

Specify the **extensions you want to install** by defining the `code_server_extensions` variable.
Extension names are separated by the `space` character.

Note: a fix is still necessary (as of version 3.10.2, included) to make the `coenraads.bracket-pair-colorizer-2` extension work with code-server, it is included at the end of the code-server installation script

Example:

```sh
code_server_extensions="coenraads.bracket-pair-colorizer-2 ms-azuretools.vscode-docker jebbs.plantuml"
```

### User settings

Preset some **user settings** by defining the `code_server_settings` variable.
It is a JSON string which code-server will use as the [user settings](https://code.visualstudio.com/docs/getstarted/settings):

* you can set the dark theme by default (`'{"workbench.colorTheme":"Default Dark+"}'`)

* If you want to have access (as a trainer and as a trainee) to some command-line tools only available at the user level, you need to **make the code-server terminal a [login shell](https://code.visualstudio.com/docs/editor/integrated-terminal#_configuring-profiles)** so that profile files (`.bashrc` for example) are loaded.
The way to do this has changed across the code-server / vsCode versions:
  * 3.7, 3.8 (and 3.9?) versions: `code_server_settings='{"terminal.integrated.shellArgs.linux": ["-l"]}'`
  * 3.10 versions: `code_server_settings='{"terminal.integrated.defaultProfile.linux":"bash","terminal.integrated.profiles.linux":{"bash":{"path":"bash","args":["-l"]}}}'`

The JSON string assigned to `code_server_settings` can be long, you can format it and assign a multiline text, for readability sake:

```sh
code_server_settings='{
  "python.terminal.activateEnvironment": false,
  "terminal.integrated.fontSize": 13,
  "terminal.integrated.defaultProfile.linux": "bash",
  "terminal.integrated.profiles.linux": {
    "bash": {"path": "bash", "args": ["-l"]}
  },
  "workbench.colorTheme": "Default Dark+"
}'
```
