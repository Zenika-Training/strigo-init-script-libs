
## Projector script documentation

The projector installation and initialization script (see [`projector.sh`](projector.sh)) allows different levels of customization:

### Projector IDE name

Specify the **Projector IDE you want to install** by defining the `projector_ide_name` variable.
Otherwise it wil be "`IntelliJ IDEA Community Edition 2020.3.4`" (latest projector-tested IntelliJ IDEA Community Edition).

Note: to get the list of available IDEs, launch `projector find`.

Example:

```sh
projector_ide_name="IntelliJ IDEA Community Edition 2020.3.4"
```

### Projector password

Specify the **Projector password you want to use** by defining the `projector_password` variable.
Otherwise, projector won't be protected by a password.

Note: this password **has** to be defined at Strigo's Class level as it's used in the projector URL
(so it cannot be random for each session, and cannot be fixed in this lib as it's public).

Example:

```sh
projector_password="class-specific-random-password"
```

### Projector TLS

Specify the **TLS certificate paths** by defining the variables:

- `projector_tls_key_path`: the path to the TLS key file
- `projector_tls_cert_path`: the path to the TLS certificate file
- `projector_tls_chain_path`: the path to the TLS chain file. Optional if the chain is already in the certificate file.

Examples:

```sh
projector_tls_key_path="/etc/letsencrypt/live/labs.strigo.io/privkey.pem"
projector_tls_cert_path="/etc/letsencrypt/live/labs.strigo.io/fullchain.pem"
```

```sh
projector_tls_key_path="/etc/letsencrypt/live/labs.strigo.io/privkey.pem"
projector_tls_cert_path="/etc/letsencrypt/live/labs.strigo.io/cert.pem"
projector_tls_chain_path="/etc/letsencrypt/live/labs.strigo.io/chain.pem"
```

## Projector config

The script create a projector config (i.e. runnable instance) named "strigo".

If necessary, you can edit it be launching:

```shell
projector config edit strigo  # interactive edit
projector config rebuild strigo  # rebuild the config (the config' `run.sh` script)
sudo systemctl restart projector@ubuntu.service  # restart projector instance
```

You are free to add other projector configs, see https://github.com/JetBrains/projector-installer/blob/master/COMMANDS.md#Config-commands

## Access URL

If you did set a password, you need to add the query parameter `token`: <http://instance.autolab.strigo.io:9999?token=password-value>

To avoid warning when opening projector in browser, best to add the query parameter `notSecureWarning=false`:
- <http://instance.autolab.strigo.io:9999?notSecureWarning=false>
- <http://instance.autolab.strigo.io:9999?notSecureWarning=false&token=password-value>

## Accept Privacy Policy in Strigo

On first access, IDEA prompt to accept Privacy Policy.
Unfortunately the button is under the Strigo reload button.
So to be able to validate, trainees have to press `<tab>` until "Continue" is selected, then `<space>` to validate.
