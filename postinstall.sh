#!/bin/bash

IP='10.1.99.1'

sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0"/' /etc/default/grub
update-grub
echo "auto eth0" > /etc/network/interfaces.d/99-vm-interfaces.cfg
echo "iface eth0 inet dhcp" >> /etc/network/interfaces.d/99-vm-interfaces.cfg
echo >> /etc/network/interfaces.d/99-vm-interfaces.cfg
echo "auto eth1" >> /etc/network/interfaces.d/99-vm-interfaces.cfg
echo "iface eth1 inet static" >> /etc/network/interfaces.d/99-vm-interfaces.cfg
echo "    address $IP" >> /etc/network/interfaces.d/99-vm-interfaces.cfg
echo "    netmask 255.0.0.0" >> /etc/network/interfaces.d/99-vm-interfaces.cfg

useradd -m -U -s /bin/bash -p "se7/31E1XoQHo" stef
adduser stef sudo
echo "stef ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99-secretbox-users
cp -r /home/ubuntu/.ssh /home/stef/.ssh
chown -R stef:stef /home/stef/.ssh

deluser ubuntu

host=$(hostname)
cat /etc/hosts | grep -v "localdomain" | tee /etc/hosts
echo -e "127.0.0.1\t\t$host.secretbox.cloud\t\t$host" >> /etc/hosts
echo -e "127.0.1.1\t\t$host.localdomain\t\t$host" >> /etc/hosts
echo >> /etc/hosts

cd /home/stef
git clone https://github.com/ssouron/secretbox.cloud.git
chown -R stef:stef /home/stef/secretbox.cloud

reboot

