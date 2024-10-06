#!/bin/bash




#Mise à jour
sudo apt-get update && sudo apt-get upgrade -y




sudo apt-get install apache2 libapache2-mod-php mysql-server libnet-snmp-perl libcrypt-rijndael-perl libcrypt-hcesha-perl libcrypt-des-perl libdigest-hmac-perl libio-pty-perl libnet-telnet-perl libalgorithm-diff-perl librrds-perl php-mysql php-snmp php-gd rrdtool libsocket6-perl -y
sudo apt install openssl net-tools -y




#Installation de Nedi
echo
echo "Downloading NeDi 2.3C"
echo "-----------------------------------------------------------------"
mkdir /var/nedi
cd /var/nedi
wget http://www.nedi.ch/pub/nedi-2.3C.zip
echo "Unzip password is RR4JC"
unzip nedi-2.3C.zip
tar zxf nedi-2.3C.tgz
rm nedi-2.3C.*
chown -R www-data:www-data /var/nedi
mkdir -p /var/log/nedi
chown -R www-data:www-data /var/log/nedi

sudo ln -s /var/nedi/html/ /var/www/

#List your SNMP read-only passwords (one per line)
#/nedi/nedi.conf

#iptables -A PREROUTING -t nat -p udp --dport 514 -j REDIRECT --to-port 1514



#DATABASE
sudo mysql -e "UPDATE mysql.user SET Password = PASSWORD('CHANGEME') WHERE User = 'root'"
sudo mysql -e "DROP USER ''@'localhost'"
sudo mysql -e "DROP USER ''@'$(hostname)'"
sudo mysql -e "DROP DATABASE test"
sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
sudo mysql -e "FLUSH PRIVILEGE"

mdpdb=$(whiptail --inputbox "Pour changer le mot de passe de la Base de Donnée, saisissez le nouveau mot de passe" 8 39 NouveauMotDePasse --title "Mot de passe de la Base de Donnée" 3>&1 1>&2 2>&3)
sudo mysql -u root -e "CREATE DATABASE nedi; GRANT ALL PRIVILEGES ON nedi.* TO nedi@localhost IDENTIFIED BY '$mdpdb'; FLUSH PRIVILEGES;"
/var/nedi/nedi.pl -i nodrop






#Mesures de sécurité :

# Desactiver la signature web d'Apache Web et serveur token
echo "ServerSignature Off" >> /etc/apache2/apache2.conf
echo "ServerTokens Prod" >> /etc/apache2/apache2.conf
#
# Cacher la vervion de PHP
sudo sed -i "s/.*expose_php.*/expose_php = Off/" /etc/php/8.1/apache2/php.ini
sudo service apache2 restart












sudo apt install openssl

# Configuration de la Database ----------------------------------------------------------------------------------
	# Retirer les utilisateurs anonymes et 

#mysql -u root
#UPDATE mysql.user SET Password=PASSWORD('MyNewPass') WHERE User='root';
#GRANT ALL PRIVILEGES ON *.* TO 'root'@'remote host' IDENTIFIED BY 'MyNewPass' WITH GRANT OPTION;
#CREATE USER ‘nedi’@'localhost' IDENTIFIED BY PASSWORD 'MyNewPass';
#GRANT ALL PRIVILEGES ON nedi.* TO ‘nedi’@'localhost';
#FLUSH PRIVILEGES;


#mysql_secure_installation # (n,y,y,y,y,y)

sudo mysql -e "UPDATE mysql.user SET Password = PASSWORD('CHANGEME') WHERE User = 'root'"
sudo mysql -e "DROP USER ''@'localhost'"
sudo mysql -e "DROP USER ''@'$(hostname)'"
sudo mysql -e "DROP DATABASE test"
sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
sudo mysql -e "FLUSH PRIVILEGE"


namedb=$(whiptail --inputbox "Pour changer le nom de la Base de Donnée, saisissez le nouveau nom" 8 39 nedi --title "Nom de la Base de Donnée" 3>&1 1>&2 2>&3)
userdb=$(whiptail --inputbox "Pour changer le nom d'utilisateur de la Base de Donnée, saisissez le nouveau nom" 8 39 nedi_adm --title "Nom de l'utilisateur de la Base de Donnée" 3>&1 1>&2 2>&3)
mdpdb=$(whiptail --inputbox "Pour changer le mot de passe de la Base de Donnée, saisissez le nouveau mot de passe" 8 39 MotDePasseRobuste --title "Mot de passe de la Base de Donnée" 3>&1 1>&2 2>&3)

sudo mysql -u root -e "CREATE DATABASE $namedb ; GRANT ALL PRIVILEGES ON $namedb.* TO '$userdb'@localhost IDENTIFIED BY '$mdpdb'; FLUSH PRIVILEGES

#sudo mysql -u root -e "CREATE DATABASE nedi; GRANT ALL PRIVILEGES ON nedi.* TO nedi@localhost IDENTIFIED BY 'MyNewPass'; FLUSH PRIVILEGES;"


sudo apt install apache php