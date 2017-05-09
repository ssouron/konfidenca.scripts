#!/bin/bash

IP='192.168.0.87'

# configuration des interfaces réseau
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0"/' /etc/default/grub
update-grub
echo "auto eth0" > /etc/network/interfaces.d/99-vm-interfaces.cfg
echo "iface eth0 inet dhcp" >> /etc/network/interfaces.d/99-vm-interfaces.cfg
echo >> /etc/network/interfaces.d/99-vm-interfaces.cfg
echo "auto eth1" >> /etc/network/interfaces.d/99-vm-interfaces.cfg
echo "iface eth1 inet static" >> /etc/network/interfaces.d/99-vm-interfaces.cfg
echo "    address $IP" >> /etc/network/interfaces.d/99-vm-interfaces.cfg
echo "    netmask 255.0.0.0" >> /etc/network/interfaces.d/99-vm-interfaces.cfg

# changement d'utilisateur
useradd -m -U -s /bin/bash -p "se7/31E1XoQHo" stef
adduser stef sudo
echo "stef ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99-secretbox-users
cp -r /home/ubuntu/.ssh /home/stef/.ssh
chown -R stef:stef /home/stef/.ssh
deluser ubuntu

# ecriture du fqdn
host=$(hostname)
cat /etc/hosts | grep -v "localdomain" | tee /etc/hosts
echo -e "127.0.0.1\t\t$host.konfidenca.net\t\t$host" >> /etc/hosts
echo -e "127.0.1.1\t\t$host.localdomain\t\t$host" >> /etc/hosts
echo >> /etc/hosts

# clonage du depot git concerné
cd /home/stef
git clone https://github.com/ssouron/konfidenca.scripts.git
chown -R stef:stef /home/stef/konfidenca.scripts

# réglage des options de prompt
sed -i "s/\#force_color_prompt=.*$/force_color_prompt=yes/" /home/stef/.bashrc
sed -i "s/01;34m/01;36m/" /home/stef/.bashrc
sed -i "s/\#force_color_prompt=.*$/force_color_prompt=yes/" /root/.bashrc
sed -i "s/01;32m/01;31m/" /root/.bashrc
sed -i "s/01;34m/01;36m/" /root/.bashrc

# redemarrage du serveur
reboot

