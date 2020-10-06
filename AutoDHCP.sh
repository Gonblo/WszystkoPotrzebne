#!/bin/bash

echo "Witaj w automatycznym kreatorze DHCP"
echo "Wybierz 1 jeśli chcesz zainstalować serwer DHCP"

read What
if [ $What = 1 ]
then 
echo "Upewnij się, że masz wybrane 2 karty sieciowe!"
echo "Pierwsza kartą sieciowa ma byc NAT!"
echo "Druga kartą sieciową ma być sieć wewnętrzna!"
echo "Wpisz tak jeśli masz dobrze wybrane sieciówki!"
read What1
if [ What1 = "tak" ]
then
echo "Podaj adres IP serwera"
read IpSerwera
echo "Podaj maske serwera"
read MaskaSerwera
echo "Podaj broadcast serwera"
read BroadcastSerwera

rm /etc/network/interfaces
touch /etc/network/interfaces

echo "# This file describes the network interfaces available on your system" >> /etc/network/interfaces
echo "# and how to activate them. For more information, see interfaces(5)." >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "source /etc/network/interfaces.d/*" >> /etc/network/interfaces 
echo "" >> /etc/network/interfaces
echo "# The loopback network interface" >> /etc/network/interfaces
echo "auto lo" >> /etc/network/interfaces
echo "iface lo inet loopback" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "# Pierwsza karta sieciowa - do sieci zewnetrznej" >> /etc/network/interfaces 
echo "auto enp0s3" >> /etc/network/interfaces
echo "allow-hotplug enp0s3" >> /etc/network/interfaces 
echo "iface enp0s3 inet dhcp" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "# Druga karta sieciowa - intnet" >> /etc/network/interfaces
echo "auto enp0s8" >> /etc/network/interfaces 
echo "allow-hotplug enp0s8" >> /etc/network/interfaces 
echo "iface enp0s8 inet static" >> /etc/network/interfaces
echo "	address $IpSerwera" >> /etc/network/interfaces 
echo "	netmask $MaskaSerwera" >> /etc/network/interfaces 
echo "	broadcast $BroadcastSerwera" >> /etc/network/interfaces 
systemctl restart networking
