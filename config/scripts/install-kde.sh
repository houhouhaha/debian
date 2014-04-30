#!/bin/bash
#
# install-kde.sh
# 
# (c) Niki Kovacs, 2011

CWD=$(pwd)

# Configurer APT
echo ":: Configuration des dépôts supplémentaires pour APT."
for REPOSITORY in deb-multimedia; do
	cat $CWD/../apt/$REPOSITORY.list > /etc/apt/sources.list.d/$REPOSITORY.list
	chmod 0644 /etc/apt/sources.list.d/$REPOSITORY.list
done

# Recharger les informations et mettre à jour
# Apparemment seul apt-get permet d'éviter les demandes de confirmation
aptitude update
apt-get -q -y --force-yes install deb-multimedia-keyring
apt-get -q -y --force-yes dist-upgrade

# Installer les paquets supplémentaires
PAQUETS=$(egrep -v '(^\#)|(^\s+$)' $CWD/../pkglists/paquets-kde)
aptitude -y install $PAQUETS

# Activer les polices Bitmap
if [ -h /etc/fonts/conf.d/70-no-bitmaps.conf ]; then
	rm -f /etc/fonts/conf.d/70-no-bitmaps.conf
	ln -s /etc/fonts/conf.avail/70-yes-bitmaps.conf /etc/fonts/conf.d/
	dpkg-reconfigure fontconfig
fi

exit 1

# Configurer APT
#echo ":: Configuration des dépôts supplémentaires pour APT."
#for REPOSITORY in debian-multimedia virtualbox backports; do
#	cat $CWD/../apt/$REPOSITORY.list > /etc/apt/sources.list.d/$REPOSITORY.list
#	chmod 0644 /etc/apt/sources.list.d/$REPOSITORY.list
#done
#cat $CWD/../apt/preferences  > /etc/apt/preferences
#chmod 0644 /etc/apt/preferences

# Télécharger la clé publique d'Oracle :
wget -c http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc
apt-key add $CWD/oracle_vbox.asc
rm -f $CWD/oracle_vbox.asc

# Recharger les informations et mettre à jour
# Apparemment seul apt-get permet d'éviter les demandes de confirmation
aptitude update
apt-get -q -y --force-yes install debian-multimedia-keyring
apt-get -q -y --force-yes install pkg-mozilla-archive-keyring
apt-get -q -y --force-yes dist-upgrade

# Installer les paquets supplémentaires
PAQUETS=$(egrep -v '(^\#)|(^\s+$)' $CWD/paquets)
aptitude -y install $PAQUETS

# Ranger les fonds d'écran à leur place
echo ":: Installation des fonds d'écran supplémentaires."
if [ -d /usr/share/wallpapers ]; then
	cp -f $CWD/../wallpapers/* /usr/share/wallpapers/
fi

# Ranger les icônes à leur place
echo ":: Installation des icônes supplémentaires."
if [ -d /usr/share/pixmaps ]; then
	cp -f $CWD/../pixmaps/* /usr/share/pixmaps/
fi

# Installer le profil par défaut des utilisateurs
echo ":: Installation du profil par défaut des utilisateurs."
if [ ! -d /etc/skel/Desktop ]; then
  mkdir /etc/skel/Desktop
fi
cp -f $CWD/../gtk/.gtkrc-2.0-kde /etc/skel/
rm -rf /etc/skel/.kde
mkdir -p /etc/skel/.kde/share/config
cp -f $CWD/../kde/* /etc/skel/.kde/share/config/

# Installer le script 'cleanmenu' et les fichiers *.desktop, avec des
# permissions saines. 
echo ":: Installation des entrées de menu personnalisées."
rm -rf /usr/local/sbin/{cleanmenu,desktop}
if [ -d /usr/share/applications ]; then
	cp -Rf $CWD/../cleanmenu/* /usr/local/sbin/
	chmod 0700 /usr/local/sbin/cleanmenu
	chmod 0700 /usr/local/sbin/desktop
	chmod 0644 /usr/local/sbin/desktop/*.desktop
fi

# Faire le ménage dans les entrées de menu
/usr/local/sbin/cleanmenu

exit
