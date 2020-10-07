#!/bin/bash
clear
# Slowa wstepu
echo "Witaj w automatycznym kreatorze DHCP"
echo "Wybierz 1 jeśli chcesz zainstalować serwer DHCP"
# Wczytanie zmiennej What ktora odpowiada za instrukcje ktora wykona zaraz skrypt
read What
clear
if [ $What = 1 ]
then # Instrukcje dla uzytkownika
echo "Upewnij się, że masz wybrane 2 karty sieciowe!"
echo "Pierwsza kartą sieciowa ma byc NAT!"
echo "Druga kartą sieciową ma być sieć wewnętrzna!"
echo "Wpisz TAK jeśli masz dobrze wybrane sieciówki!"
read What1
if [ $What1 = "TAK" ]
then
clear
echo "KREATOR ROZPOCZYNA PRACE"
echo "KREATOR ROZPOCZYNA PRACE"
echo "KREATOR ROZPOCZYNA PRACE"
echo "Podaj adres IP serwera" #Wczytywanie wartosci dla pliku interfaces
read IpSerwera
echo "Podaj maske serwera"
read MaskaSerwera
echo "Podaj broadcast serwera"
read BroadcastSerwera
clear
# Edytowanie pliku interfaces
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
clear
echo "Restartowanie kart sieciowych"
systemctl restart networking #Restartowanie kart sieciowych
#Instalacja serwera DHCP
clear
echo "Instaluje serwer DHCP"
apt-get install isc-dhcp-server

echo "# Defaults for isc-dhcp-server initscript" >> /etc/default/isc-dhcp-server
echo "# sourced by /etc/init.d/isc-dhcp-server" >> /etc/default/isc-dhcp-server
echo "# installed at /etc/default/isc-dhcp-server by the maintainer scripts" >> /etc/default/isc-dhcp-server
echo "" >> /etc/default/isc-dhcp-server
echo "#" >> /etc/default/isc-dhcp-server
echo "# This is a POSIX shell fragment" >> /etc/default/isc-dhcp-server
echo "#" >> /etc/default/isc-dhcp-server
echo "" >> /etc/default/isc-dhcp-server
echo "# Path to dhcpd's config file (default: /etc/dhcp/dhcpd.conf)." >> /etc/default/isc-dhcp-server
echo "#DHCPD_CONF=/etc/dhcp/dhcpd.conf" >> /etc/default/isc-dhcp-server
echo "" >> /etc/default/isc-dhcp-server
echo "# Path to dhcpd's PID file (default: /var/run/dhcpd.pid)." >> /etc/default/isc-dhcp-server
echo "#DHCPD_PID=/var/run/dhcpd.pid" >> /etc/default/isc-dhcp-server
echo "" >> /etc/default/isc-dhcp-server
echo "# Additional options to start dhcpd with." >> /etc/default/isc-dhcp-server
echo "#       Don't use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead" >> /etc/default/isc-dhcp-server
echo "#OPTIONS=""" >> /etc/default/isc-dhcp-server
echo "" >> /etc/default/isc-dhcp-server
echo "# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?" >> /etc/default/isc-dhcp-server
echo "#       Separate multiple interfaces with spaces, e.g. "eth0 eth1"." >> /etc/default/isc-dhcp-server
echo "INTERFACES="enp0s8"" >> /etc/default/isc-dhcp-server


fi
fi 

