#!/bin/bash

apt-get install -y curl
workspace_archive_file_id="<ZIP_ID_FROM_GDRIVE>"
corrections_archive_file_id="<ZIP_ID_FROM_GDRIVE>"

# fetch from gdrive
# Archive must be in .tar.xz format

cd ~ubuntu
curl -fsSL "https://drive.google.com/uc?export=download&id=${workspace_archive_file_id}" | tar xJf -  # workspaces
curl -fsSL "https://drive.google.com/uc?export=download&id=${corrections_archive_file_id}" | tar xJf -  # corrections
chown -R ubuntu workspaces corrections

# hide corrections

mv corrections .corrections
