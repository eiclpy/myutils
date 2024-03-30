#!/bin/bash

INSTALL_PREFIX=/opt/miniconda3
CONDA_GROUP=${1:-conda}

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root!"
    exit 1
fi

echo "Installing Miniconda3 to $(INSTALL_PREFIX) for group $(CONDA_GROUP)"
echo "Please ensure that the group $(CONDA_GROUP) exists before running this script."
read -p "Press [Enter] to continue..."

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
bash /tmp/miniconda.sh -b -p $(INSTALL_PREFIX) -s
rm /tmp/miniconda.sh

chmod -R 770 $(INSTALL_PREFIX)
chgrp -R $(CONDA_GROUP) $(INSTALL_PREFIX)

echo <<EOF >> /opt/conda.sh
#!/bin/bash

source $(INSTALL_PREFIX)/etc/profile.d/conda.sh
conda activate \${1:-base}
EOF
chmod +x /opt/conda.sh
