#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please Run As root"
    exit
fi

clear

installTheme(){
    cd /var/www/
    tar -cvf PterodactylThemebackup.tar.gz pterodactyl
    echo "Installing Theme"
    cd /var/www/pterodactyl
    rm -r PterodactylTheme
    git clone https://github.com/switzerlandnesia/PterodactylTheme.git
    cd PterodactylTheme
    rm /var/www/pterodactyl/resources/scripts/PterodactylTheme.css
    rm /var/www/pterodactyl/resources/scripts/index.tsx
    mv index.tsx /var/www/pterodactyl/resources/scripts/index.tsx
    mv PterodactylTheme.css /var/www/pterodactyl/resources/scripts/PterodactylTheme.css
    cd /var/www/pterodactyl

    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    apt update
    apt install -y nodejs

    npm i -g yarn
    yarn

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear


}

installThemeQuestion(){
    while true; do
        read -p "Are You Sure That You Want To Install The Theme [y/n] " yn
        case $yn in
            [Yy]* ) installTheme; break;;
            [Nn]* ) exit;;
            * ) echo "Please Answer Yes Or No.";;
        esac
    done
}

repair(){
    bash <(curl https://raw.githubusercontent.com/switzerlandnesia/PterodactylTheme/main/repair.sh)
}

restoreBackUp(){
    echo "Restoring Backup"
    cd /var/www/
    tar -xvf PterodactylThemebackup.tar.gz
    rm PterodactylThemebackup.tar.gz

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear
}
echo "Copyright (c) Switzerland"
echo "This Program Is Free Software: You Can Redistribute It And/Or Modify"
echo ""
echo "WhatsApp: https://whatsApp.com"
echo "Tweet: https://twitter.com"
echo ""
echo "[1] Install Theme"
echo "[2] Restore Backup"
echo "[3] Repair Panel (Use If You Have An Error In The Theme Installation)"
echo "[4] Exit"

read -p "Please Enter A Number: " choice
if [ $choice == "1" ]
    then
    installThemeQuestion
fi
if [ $choice == "2" ]
    then
    restoreBackUp
fi
if [ $choice == "3" ]
    then
    repair
fi
if [ $choice == "4" ]
    then
    exit
fi