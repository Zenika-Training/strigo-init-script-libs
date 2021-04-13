#!/bin/bash -e

# Define these 2 variables if you want to customize the default installation,
# then copy-paste the remainder of the script:
# - the version of python to install
# python_version=3.8.6
# - the poetry version to install (if not specified, installs the last one)
# poetry_version=1.1.5
# - the path to the labs folder, where the python version will be activated
# labs_path=/home/ubuntu/labs_python

# PYENV
# - installs pyenv prerequisites (see https://github.com/pyenv/pyenv/wiki#suggested-build-environment)
apt-get update && apt-get install -y  --no-install-recommends \
    build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

git clone https://github.com/pyenv/pyenv.git /home/ubuntu/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git /home/ubuntu/.pyenv/plugins/pyenv-virtualenv

# - accelerates some pyenv commands
cd /home/ubuntu/.pyenv && src/configure && make -C src && cd ~/

# - activates pyenv in bash sessions (both root and ubuntu users)
cat <<\EOF > /etc/profile.d/bashrc_python.sh
#!/bin/sh

export PYENV_ROOT="/home/ubuntu/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi
EOF
chmod +x /etc/profile.d/bashrc_python.sh

# - updates the shell to account for pyenv
source /etc/profile.d/bashrc_python.sh

# Installs the PYTHON version system-wise (so that poetry will be installed with it)
python_version=${python_version:-3.8.6}
pyenv install ${python_version}
pyenv global ${python_version}
chown -R ubuntu:ubuntu /home/ubuntu/.pyenv/

# Creates the labs directory and activates the chosen Python version
labs_path=${labs_path:-/home/ubuntu/labs_python}
mkdir -p "${labs_path}"
cd "${labs_path}" && pyenv local ${python_version} && cd ~/
chown -R ubuntu:ubuntu "${labs_path}"

# Installs POETRY with the specified python version, if defined
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py > ~/get-poetry.py
if [[ ${poetry_version} && ${poetry_version-_} ]]; then
  POETRY_HOME=/home/ubuntu/.poetry python get-poetry.py -y --version $poetry_version
else
  POETRY_HOME=/home/ubuntu/.poetry python get-poetry.py -y
fi
# - activates poetry in bash sessions
cat <<\EOF >> /etc/profile.d/bashrc_python.sh
export PATH="/home/ubuntu/.poetry/bin:$PATH"
EOF
chown -R ubuntu: /home/ubuntu/.poetry

rm ~/get-poetry.py
# - updates the shell to account for poetry
source /etc/profile.d/bashrc_python.sh

# Restores the system python version (the one installed with pyenv will still be available locally, during the labs)
pyenv global system
