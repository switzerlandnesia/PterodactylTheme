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
echo "Copyright (c) 2022 Angelillo15 | angelillo15.es"
echo "This program is free software: you can redistribute it and/or modify"
echo ""
echo "Discord: https://discord.angelillo15.es/"
echo "Website: https://angelillo15.es/"
echo ""
echo "[1] Install theme"
echo "[2] Restore backup"
echo "[3] Repair panel (use if you have an error in the theme installation)"
echo "[4] Exit"

read -p "Please enter a number: " choice
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
