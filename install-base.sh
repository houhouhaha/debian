#!/bin/bash
#
# install-base.sh

CWD=$(pwd)

# Configuration de Bash
echo ":: Configuration de Bash pour l'administrateur."
cat $CWD/../bash/root-bashrc > /root/.bashrc
chown root:root /root/.bashrc
chmod 0644 /root/.bashrc

echo ":: Configuration de Bash pour les utilisateurs."
cat $CWD/../bash/user-bash_aliases > /etc/skel/.bash_aliases
chown root:root /etc/skel/.bash_aliases
chmod 0644 /etc/skel/.bash_aliases

# Configuration de Vim
echo ":: Configuration de Vim."
cat $CWD/../vim/vimrc.local > /etc/vim/vimrc.local
chmod 0644 /etc/vim/vimrc.local

# Configurer APT
echo ":: Configuration de APT."
cat $CWD/../apt/sources.list > /etc/apt/sources.list
chmod 0644 /etc/apt/sources.list

# Installation de quelques outils en ligne de commande
echo ":: Installation de quelques outils en ligne de commande."
TOOLS=$(egrep -v '(^\#)|(^\s+$)' $CWD/../pkglists/paquets-base)
aptitude update
aptitude -y install $TOOLS

