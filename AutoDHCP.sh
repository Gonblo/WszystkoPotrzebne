#!/bin/bash
clear
# Slowa wstepu
echo "Witaj w automatycznym kreatorze DHCP"
echo "Wybierz 1 jeśli chcesz zainstalować serwer DHCP"
echo "Wybierz 2 jeśli chcesz skonfigurować ponownie serwer DHCP (bez ponownej instalacji)"
echo "Wybierz 3 jeśli chcesz uruchomić serwer DHCP"
echo "Wybierz 4 jeśli chcesz zrestartować serwer DHCP"
echo "Wybierz 5 jeśli chcesz wyłączyć serwer DHCP"
echo "Wybierz 6 jeśli chcesz sprawdzić status usługi"
echo "Wybierz 7 jeśli chcesz odinstalować serwer DHCP"
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

# PODMIENIANIE PLIKU /ETC/NETWORK/INTERFACES

echo "KREATOR ROZPOCZYNA PRACE"
echo "KONFIGURUJESZ PLIK /ETC/NETWORK/INTERFACES !"
echo "KONFIGUROWANA JEST KARTA enp0s8 (SIEC WEWNETRZNA)"
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

# PODMIENIANIE PLIKU /ETC/DEFAULT/ISC-DHCP-SERVER

clear
echo "Podmieniam plik isc-dhcp-server"
rm /etc/default/isc-dhcp-server
touch /etc/default/isc-dhcp-server
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

#POLECENIA DO EDYCJI PLIKU DHCPD.CONF

clear
echo "Podaj nazwe domeny! (option domain-name-servers) "
read NazwaDomeny
echo "Podaj IP domeny! (option domain-name) "
read IpDomeny
echo "Podaj Subnet (subnet ...)"
read Subnet
echo "Podaj maske podsieci (netmask ...)"
read MaskSub
echo "Podaj zakres OD którego DHCP ma przydzielać (range ...)"
read OIP
echo "Podaj zakres DO którego DHCP ma przydzielać (range ... ...)"
read DIP
echo "Options routers podaj ip (option routers)"
read OptionR
echo "Podaj Broadcast (option broadcast-address)"
read BroadcastX
rm /etc/dhcp/dhcpd.conf
touch /etc/dhcp/dhcpd.conf

#EDYTOWANIE PLIKU DHCPD.CONF

echo "#" >> /etc/dhcp/dhcpd.conf
echo "# Sample configuration file for ISC dhcpd for Debian" >> /etc/dhcp/dhcpd.conf
echo "#" >> /etc/dhcp/dhcpd.conf
echo "# Attention: If /etc/ltsp/dhcpd.conf exists, that will be used as" >> /etc/dhcp/dhcpd.conf
echo "# configuration file instead of this file." >> /etc/dhcp/dhcpd.conf
echo "#" >> /etc/dhcp/dhcpd.conf
echo "#" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# The ddns-updates-style parameter controls whether or not the server will" >> /etc/dhcp/dhcpd.conf
echo "# attempt to do a DNS update when a lease is confirmed. We default to the" >> /etc/dhcp/dhcpd.conf
echo "# behavior of the version 2 packages ('none', since DHCP v2 didn't" >> /etc/dhcp/dhcpd.conf
echo "# have support for DDNS.)" >> /etc/dhcp/dhcpd.conf
echo "ddns-update-style none;" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# option definitions common to all supported networks..." >> /etc/dhcp/dhcpd.conf
echo "option domain-name "$NazwaDomeny";">> /etc/dhcp/dhcpd.conf
echo "option domain-name-servers $IpDomeny;" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "default-lease-time 600;" >> /etc/dhcp/dhcpd.conf
echo "max-lease-time 7200;" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# If this DHCP server is the official DHCP server for the local" >> /etc/dhcp/dhcpd.conf
echo "# network, the authoritative directive should be uncommented." >> /etc/dhcp/dhcpd.conf
echo "authoritative;" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# Use this to send dhcp log messages to a different log file (you also" >> /etc/dhcp/dhcpd.conf
echo "# have to hack syslog.conf to complete the redirection)." >> /etc/dhcp/dhcpd.conf
echo "log-facility local7;" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# No service will be given on this subnet, but declaring it helps the" >> /etc/dhcp/dhcpd.conf
echo "# DHCP server to understand the network topology." >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "#subnet 10.152.187.0 netmask 255.255.255.0 {" >> /etc/dhcp/dhcpd.conf
echo "#}" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# This is a very basic subnet declaration." >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "#subnet 10.254.239.0 netmask 255.255.255.224 {" >> /etc/dhcp/dhcpd.conf
echo "#  range 10.254.239.10 10.254.239.20;" >> /etc/dhcp/dhcpd.conf
echo "#  option routers rtr-239-0-1.example.org, rtr-239-0-2.example.org;" >> /etc/dhcp/dhcpd.conf
echo "#}" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# This declaration allows BOOTP clients to get dynamic addresses," >> /etc/dhcp/dhcpd.conf
echo "# which we don't really recommend." >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "#subnet 10.254.239.32 netmask 255.255.255.224 {" >> /etc/dhcp/dhcpd.conf
echo "#  range dynamic-bootp 10.254.239.40 10.254.239.60;" >> /etc/dhcp/dhcpd.conf
echo "#  option broadcast-address 10.254.239.31;" >> /etc/dhcp/dhcpd.conf
echo "#  option routers rtr-239-32-1.example.org;" >> /etc/dhcp/dhcpd.conf
echo "#}" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# A slightly different configuration for an internal subnet." >> /etc/dhcp/dhcpd.conf
echo "subnet $Subnet netmask $MaskSub {" >> /etc/dhcp/dhcpd.conf
echo "  range $OIP $DIP;" >> /etc/dhcp/dhcpd.conf
echo "  option domain-name-servers $IpDomeny;" >> /etc/dhcp/dhcpd.conf
echo "  option domain-name "$NazwaDomeny";" >> /etc/dhcp/dhcpd.conf
echo "  option subnet-mask $MaskSub;" >> /etc/dhcp/dhcpd.conf
echo "  option routers $OptionR;" >> /etc/dhcp/dhcpd.conf
echo "  option broadcast-address $BroadcastX;" >> /etc/dhcp/dhcpd.conf
echo "  default-lease-time 600;" >> /etc/dhcp/dhcpd.conf
echo "  max-lease-time 7200;" >> /etc/dhcp/dhcpd.conf
echo "}" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# Hosts which require special configuration options can be listed in" >> /etc/dhcp/dhcpd.conf
echo "# host statements.   If no address is specified, the address will be" >> /etc/dhcp/dhcpd.conf
echo "# allocated dynamically (if possible), but the host-specific information" >> /etc/dhcp/dhcpd.conf
echo "# will still come from the host declaration." >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "#host passacaglia {" >> /etc/dhcp/dhcpd.conf
echo "#  hardware ethernet 0:0:c0:5d:bd:95;" >> /etc/dhcp/dhcpd.conf
echo "#  filename "vmunix.passacaglia";" >> /etc/dhcp/dhcpd.conf
echo "#  server-name "toccata.fugue.com";" >> /etc/dhcp/dhcpd.conf
echo "#}" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# Fixed IP addresses can also be specified for hosts.   These addresses" >> /etc/dhcp/dhcpd.conf
echo "# should not also be listed as being available for dynamic assignment." >> /etc/dhcp/dhcpd.conf
echo "# Hosts for which fixed IP addresses have been specified can boot using" >> /etc/dhcp/dhcpd.conf
echo "# BOOTP or DHCP.   Hosts for which no fixed address is specified can only" >> /etc/dhcp/dhcpd.conf
echo "# be booted with DHCP, unless there is an address range on the subnet" >> /etc/dhcp/dhcpd.conf
echo "# to which a BOOTP client is connected which has the dynamic-bootp flag" >> /etc/dhcp/dhcpd.conf
echo "# set." >> /etc/dhcp/dhcpd.conf
echo "#host fantasia {" >> /etc/dhcp/dhcpd.conf
echo "#  hardware ethernet 08:00:07:26:c0:a5;" >> /etc/dhcp/dhcpd.conf
echo "#  fixed-address fantasia.fugue.com;" >> /etc/dhcp/dhcpd.conf
echo "#}" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# You can declare a class of clients and then do address allocation" >> /etc/dhcp/dhcpd.conf
echo "# based on that.   The example below shows a case where all clients" >> /etc/dhcp/dhcpd.conf
echo "# in a certain class get addresses on the 10.17.224/24 subnet, and all" >> /etc/dhcp/dhcpd.conf
echo "# other clients get addresses on the 10.0.29/24 subnet." >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "#class "foo" {" >> /etc/dhcp/dhcpd.conf
echo "#  match if substring (option vendor-class-identifier, 0, 4) = "SUNW";" >> /etc/dhcp/dhcpd.conf
echo "#}" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "#shared-network 224-29 {" >> /etc/dhcp/dhcpd.conf
echo "#  subnet 10.17.224.0 netmask 255.255.255.0 {" >> /etc/dhcp/dhcpd.conf
echo "#    option routers rtr-224.example.org;" >> /etc/dhcp/dhcpd.conf
echo "#  }" >> /etc/dhcp/dhcpd.conf
echo "#  subnet 10.0.29.0 netmask 255.255.255.0 {" >> /etc/dhcp/dhcpd.conf
echo "#    option routers rtr-29.example.org;" >> /etc/dhcp/dhcpd.conf
echo "#  }" >> /etc/dhcp/dhcpd.conf
echo "#  pool {" >> /etc/dhcp/dhcpd.conf
echo "#    allow members of "foo";" >> /etc/dhcp/dhcpd.conf
echo "#    range 10.17.224.10 10.17.224.250;" >> /etc/dhcp/dhcpd.conf
echo "#  }" >> /etc/dhcp/dhcpd.conf
echo "#  pool {" >> /etc/dhcp/dhcpd.conf
echo "#    deny members of "foo";" >> /etc/dhcp/dhcpd.conf
echo "#    range 10.0.29.10 10.0.29.230;" >> /etc/dhcp/dhcpd.conf
echo "#  }" >> /etc/dhcp/dhcpd.conf
echo "#}" >> /etc/dhcp/dhcpd.conf
systemctl start isc-dhcp-server
systemctl restart isc-dhcp-server
clear
echo "DHCP POPRAWNIE ZAINSTALOWANE I URUCHOMIONE!"
fi
fi 
if [ $What = 2 ]
then

#PODMIENIANIE PLIKU /ETC/NETWORK/INTERFACES

echo "ROZPOCZYNAM PRACE EDYTORA SERWERA DHCP"
echo "KONFIGURUJESZ PLIK /ETC/NETWORK/INTERFACES !"
echo "KONFIGUROWANA JEST KARTA enp0s8 (SIEC WEWNETRZNA)"
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

# PODMIENIANIE PLIKU ETC/DEFAULT/ISC-DHCP-SERVER

clear
echo "Podmieniam plik isc-dhcp-server"
rm /etc/default/isc-dhcp-server
touch /etc/default/isc-dhcp-server
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

#POLECENIA DO EDYCJI PLIKU DHCPD.CONF

clear
echo "Podaj nazwe domeny! (option domain-name-servers) "
read NazwaDomeny
echo "Podaj IP domeny! (option domain-name) "
read IpDomeny
echo "Podaj Subnet (subnet ...)"
read Subnet
echo "Podaj maske podsieci (netmask ...)"
read MaskSub
echo "Podaj zakres OD którego DHCP ma przydzielać (range ...)"
read OIP
echo "Podaj zakres DO którego DHCP ma przydzielać (range ... ...)"
read DIP
echo "Options routers podaj ip (option routers)"
read OptionR
echo "Podaj Broadcast (option broadcast-address)"
read BroadcastX
rm /etc/dhcp/dhcpd.conf
touch /etc/dhcp/dhcpd.conf

#EDYTOWANIE PLIKU DHCPD.CONF

echo "#" >> /etc/dhcp/dhcpd.conf
echo "# Sample configuration file for ISC dhcpd for Debian" >> /etc/dhcp/dhcpd.conf
echo "#" >> /etc/dhcp/dhcpd.conf
echo "# Attention: If /etc/ltsp/dhcpd.conf exists, that will be used as" >> /etc/dhcp/dhcpd.conf
echo "# configuration file instead of this file." >> /etc/dhcp/dhcpd.conf
echo "#" >> /etc/dhcp/dhcpd.conf
echo "#" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# The ddns-updates-style parameter controls whether or not the server will" >> /etc/dhcp/dhcpd.conf
echo "# attempt to do a DNS update when a lease is confirmed. We default to the" >> /etc/dhcp/dhcpd.conf
echo "# behavior of the version 2 packages ('none', since DHCP v2 didn't" >> /etc/dhcp/dhcpd.conf
echo "# have support for DDNS.)" >> /etc/dhcp/dhcpd.conf
echo "ddns-update-style none;" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# option definitions common to all supported networks..." >> /etc/dhcp/dhcpd.conf
echo "option domain-name "$NazwaDomeny";">> /etc/dhcp/dhcpd.conf
echo "option domain-name-servers $IpDomeny;" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "default-lease-time 600;" >> /etc/dhcp/dhcpd.conf
echo "max-lease-time 7200;" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# If this DHCP server is the official DHCP server for the local" >> /etc/dhcp/dhcpd.conf
echo "# network, the authoritative directive should be uncommented." >> /etc/dhcp/dhcpd.conf
echo "authoritative;" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# Use this to send dhcp log messages to a different log file (you also" >> /etc/dhcp/dhcpd.conf
echo "# have to hack syslog.conf to complete the redirection)." >> /etc/dhcp/dhcpd.conf
echo "log-facility local7;" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# No service will be given on this subnet, but declaring it helps the" >> /etc/dhcp/dhcpd.conf
echo "# DHCP server to understand the network topology." >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "#subnet 10.152.187.0 netmask 255.255.255.0 {" >> /etc/dhcp/dhcpd.conf
echo "#}" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# This is a very basic subnet declaration." >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "#subnet 10.254.239.0 netmask 255.255.255.224 {" >> /etc/dhcp/dhcpd.conf
echo "#  range 10.254.239.10 10.254.239.20;" >> /etc/dhcp/dhcpd.conf
echo "#  option routers rtr-239-0-1.example.org, rtr-239-0-2.example.org;" >> /etc/dhcp/dhcpd.conf
echo "#}" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# This declaration allows BOOTP clients to get dynamic addresses," >> /etc/dhcp/dhcpd.conf
echo "# which we don't really recommend." >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "#subnet 10.254.239.32 netmask 255.255.255.224 {" >> /etc/dhcp/dhcpd.conf
echo "#  range dynamic-bootp 10.254.239.40 10.254.239.60;" >> /etc/dhcp/dhcpd.conf
echo "#  option broadcast-address 10.254.239.31;" >> /etc/dhcp/dhcpd.conf
echo "#  option routers rtr-239-32-1.example.org;" >> /etc/dhcp/dhcpd.conf
echo "#}" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# A slightly different configuration for an internal subnet." >> /etc/dhcp/dhcpd.conf
echo "subnet $Subnet netmask $MaskSub {" >> /etc/dhcp/dhcpd.conf
echo "  range $OIP $DIP;" >> /etc/dhcp/dhcpd.conf
echo "  option domain-name-servers $IpDomeny;" >> /etc/dhcp/dhcpd.conf
echo "  option domain-name "$NazwaDomeny";" >> /etc/dhcp/dhcpd.conf
echo "  option subnet-mask $MaskSub;" >> /etc/dhcp/dhcpd.conf
echo "  option routers $OptionR;" >> /etc/dhcp/dhcpd.conf
echo "  option broadcast-address $BroadcastX;" >> /etc/dhcp/dhcpd.conf
echo "  default-lease-time 600;" >> /etc/dhcp/dhcpd.conf
echo "  max-lease-time 7200;" >> /etc/dhcp/dhcpd.conf
echo "}" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# Hosts which require special configuration options can be listed in" >> /etc/dhcp/dhcpd.conf
echo "# host statements.   If no address is specified, the address will be" >> /etc/dhcp/dhcpd.conf
echo "# allocated dynamically (if possible), but the host-specific information" >> /etc/dhcp/dhcpd.conf
echo "# will still come from the host declaration." >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "#host passacaglia {" >> /etc/dhcp/dhcpd.conf
echo "#  hardware ethernet 0:0:c0:5d:bd:95;" >> /etc/dhcp/dhcpd.conf
echo "#  filename "vmunix.passacaglia";" >> /etc/dhcp/dhcpd.conf
echo "#  server-name "toccata.fugue.com";" >> /etc/dhcp/dhcpd.conf
echo "#}" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# Fixed IP addresses can also be specified for hosts.   These addresses" >> /etc/dhcp/dhcpd.conf
echo "# should not also be listed as being available for dynamic assignment." >> /etc/dhcp/dhcpd.conf
echo "# Hosts for which fixed IP addresses have been specified can boot using" >> /etc/dhcp/dhcpd.conf
echo "# BOOTP or DHCP.   Hosts for which no fixed address is specified can only" >> /etc/dhcp/dhcpd.conf
echo "# be booted with DHCP, unless there is an address range on the subnet" >> /etc/dhcp/dhcpd.conf
echo "# to which a BOOTP client is connected which has the dynamic-bootp flag" >> /etc/dhcp/dhcpd.conf
echo "# set." >> /etc/dhcp/dhcpd.conf
echo "#host fantasia {" >> /etc/dhcp/dhcpd.conf
echo "#  hardware ethernet 08:00:07:26:c0:a5;" >> /etc/dhcp/dhcpd.conf
echo "#  fixed-address fantasia.fugue.com;" >> /etc/dhcp/dhcpd.conf
echo "#}" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "# You can declare a class of clients and then do address allocation" >> /etc/dhcp/dhcpd.conf
echo "# based on that.   The example below shows a case where all clients" >> /etc/dhcp/dhcpd.conf
echo "# in a certain class get addresses on the 10.17.224/24 subnet, and all" >> /etc/dhcp/dhcpd.conf
echo "# other clients get addresses on the 10.0.29/24 subnet." >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "#class "foo" {" >> /etc/dhcp/dhcpd.conf
echo "#  match if substring (option vendor-class-identifier, 0, 4) = "SUNW";" >> /etc/dhcp/dhcpd.conf
echo "#}" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "#shared-network 224-29 {" >> /etc/dhcp/dhcpd.conf
echo "#  subnet 10.17.224.0 netmask 255.255.255.0 {" >> /etc/dhcp/dhcpd.conf
echo "#    option routers rtr-224.example.org;" >> /etc/dhcp/dhcpd.conf
echo "#  }" >> /etc/dhcp/dhcpd.conf
echo "#  subnet 10.0.29.0 netmask 255.255.255.0 {" >> /etc/dhcp/dhcpd.conf
echo "#    option routers rtr-29.example.org;" >> /etc/dhcp/dhcpd.conf
echo "#  }" >> /etc/dhcp/dhcpd.conf
echo "#  pool {" >> /etc/dhcp/dhcpd.conf
echo "#    allow members of "foo";" >> /etc/dhcp/dhcpd.conf
echo "#    range 10.17.224.10 10.17.224.250;" >> /etc/dhcp/dhcpd.conf
echo "#  }" >> /etc/dhcp/dhcpd.conf
echo "#  pool {" >> /etc/dhcp/dhcpd.conf
echo "#    deny members of "foo";" >> /etc/dhcp/dhcpd.conf
echo "#    range 10.0.29.10 10.0.29.230;" >> /etc/dhcp/dhcpd.conf
echo "#  }" >> /etc/dhcp/dhcpd.conf
echo "#}" >> /etc/dhcp/dhcpd.conf
systemctl start isc-dhcp-server
systemctl restart isc-dhcp-server
clear
echo "DHCP POPRAWNIE ZAINSTALOWANE I URUCHOMIONE!"
fi

if [ $What = 3 ]
then
  systemctl start isc-dhcp-server
  clear
  echo "SERWER DHCP URUCHOMIONY"
fi
if [ $What = 4 ]
then
  systemctl restart isc-dhcp-server
  clear
  echo "SERWER DHCP URUCHOMIONY PONOWNIE"
fi
if [ $What = 5 ]
then
  systemctl stop isc-dhcp-server
  clear
  echo "SERWER DHCP WYLACZONY"
fi
if [ $What = 6 ]
then
  clear
  echo "STATUS USLUGI"
  systemctl status isc-dhcp-server
fi
if [ $What = 7 ]
then
clear
systemctl stop isc-dhcp-server
apt remove isc-dhcp-server
rm /etc/dhcp/dhcpd.conf
rm /etc/default/isc-dhcp-server
rm /etc/network/interfaces
touch /etc/network/interfaces
echo "# Defaults for isc-dhcp-server initscript" >> /etc/network/interfaces
echo "# sourced by /etc/init.d/isc-dhcp-server" >> /etc/network/interfaces
echo "# installed at /etc/default/isc-dhcp-server by the maintainer scripts" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "#" >> /etc/network/interfaces
echo "# This is a POSIX shell fragment" >> /etc/network/interfaces
echo "#" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "# Path to dhcpd's config file (default: /etc/dhcp/dhcpd.conf)." >> /etc/network/interfaces
echo "#DHCPD_CONF=/etc/dhcp/dhcpd.conf" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "# Path to dhcpd's PID file (default: /var/run/dhcpd.pid)." >> /etc/network/interfaces
echo "#DHCPD_PID=/var/run/dhcpd.pid" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "# Additional options to start dhcpd with." >> /etc/network/interfaces
echo "#       Don't use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead" >> /etc/network/interfaces
echo "#OPTIONS=""" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?" >> /etc/network/interfaces
echo "#       Separate multiple interfaces with spaces, e.g. "eth0 eth1"." >> /etc/network/interfaces
echo "INTERFACES=""" >> /etc/network/interfaces

echo "Wszystko zostalo odinstalowane!"

fi
