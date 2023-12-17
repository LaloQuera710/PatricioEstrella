#!bin/bash

#Colors
white="\033[1;37m"
grey="\033[0;37m"
purple="\033[0;35m"
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
Purple="\033[0;35m"
Cyan="\033[0;36m"
Cafe="\033[0;33m"
Fiuscha="\033[0;35m"
blue="\033[1;34m"
nc="\e[0m"
mon="mon"

check_wifi_mode() {
        #Gurdar en el contenedor $modo si la tarjeta esta en modo Monitor o >
  mode_check=$(iwconfig $1 | grep Mode | awk '{print $1}')
  if [ "$mode_check" == "Mode:Monitor" ]; then
    mode=Monitor
  else
    mode=Managed
  fi
}

function card {
        #Aparezcan las interfaces de Red conectadas al equipo/maquina
        clear
        ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d; s/^\([^:]*\):/[*] \1/'

}
function ActMonitor {
####Activacion Modo Monitor y Modo Seguro####

        #Comprueba si se a introducido algo en el contenedor $interfaz#
        if [ -n "$interfaz" ]; then
                clear
                echo
                read -p "[*] Cortar la salida a internet para evitar futuros>
                echo
                if [ $fails = y ]
                        then
                                airmon-ng check kill >/dev/null
                        else
                                echo "OK"
                fi
                 ifconfig $interfaz promisc >/dev/null
                 airmon-ng start $interfaz >/dev/null
                echo "======================="
                echo "Activando Modo Monitor"
echo "======================="
                echo "--->""                  |"
                sleep 1
                echo "-------->""             |"
                sleep 1
                echo "--------------->""      |"
                sleep 1
                echo "--------------------->""|"
                echo "======================="
                #Mostrar logo1 + interfaces#
                card 
                echo
               read -p "[*] Escribe la Interfaz de la Tarjeta de Red en modo Monitor (Ej: wlan0mon o wlan0): " interfaz2
                 echo
                 ifconfig $interfaz2 promisc >/dev/null
                 ifconfig $interfaz2 down >/dev/null
                sleep 2.5
                macchanger -a $interfaz2 >/dev/null
                 ifconfig $interfaz2 up >/dev/null
                echo "======================="
                echo " Activando Modo Seguro"
                echo "======================="
                echo "--->""                  |"
                sleep 1
                echo "-------->""             |"
                sleep 1
                echo "--------------->""      |"
                sleep 1
                echo "--------------------->""|"
                echo "======================="
        else
                card
                echo
                read -p "[*] Escribe la Interfaz de la Tarjeta de Red (Ej: w>
                read -p "[*] Cortar la salida a internet para evitar futuros>
                echo
                if [ $fails = y ]
                        then
                airmon-ng check kill >/dev/null
                        else
                                echo "OK"
                fi
                 ifconfig $interfaz promisc >/dev/null
                 airmon-ng start $interfaz >/dev/null
                echo "======================="
                echo "Activando Modo Monitor"
                echo "======================="
                echo "--->""                  |"
                sleep 1
                echo "-------->""             |"
                sleep 1
                echo "--------------->""      |"
                sleep 1
                echo "--------------------->""|"
                echo "======================="
                
                card
                echo
                read -p "[*] Escribe la Interfaz de la Tarjeta de Red en modo Monitor (Ej: wlan0mon o wlan0): " interfaz2
 echo
                 ifconfig $interfaz2 promisc >/dev/null
                 ifconfig $interfaz2 down >/dev/null
                sleep 2.5
                 macchanger -a $interfaz2 >/dev/null
                 ifconfig $interfaz2 up >/dev/null  
                echo "======================="
                echo " Activando Modo Seguro"
                echo "======================="
                echo "--->""                  |"
                sleep 1
                echo "-------->""             |"
                sleep 1
                echo "--------------->""      |"
                sleep 1
                echo "--------------------->""|"
                echo "======================="
        fi
}
 
function DesaMonitor {
 #Desactiva el modo monitor y lo restablece (Coge la interfaz de cuan>
        echo
        echo "[#] Desactivando Ataque y Protocolos"
        echo
         ifconfig $interfaz2 down >/dev/null
        sleep 2.5
         ifconfig $interfaz2 promisc >/dev/null
         macchanger -p $interfaz2 >/dev/null
         ifconfig $interfaz2 up >/dev/null
         ifconfig $interfaz2 -promisc >/dev/null
         airmon-ng stop $interfaz2 >/dev/null
         ifconfig $interfaz -promisc >/dev/null
         systemctl restart NetworkManager.service >/dev/null
        echo "=============================="
        echo "        Desactivando"
        echo "Ataque/Modo Monitor/Seguridad"
        echo "=============================="
        echo "-------->""                    |"
        sleep 1
        echo "--------------->""             |"
        sleep 1
        echo "---------------------->""      |"
        sleep 1
        echo "---------------------------->""|"
        echo "=============================="
}
 
function DesaMonitor2 {
        #Desactiva el modo monitor y lo fuerza a restablecerse (Pide las int>
        card
        echo
        read -p "[*] Escribe la Interfaz de la Tarjeta de Red en modo Monito>
        echo
echo "[#] Restableciendo Tarjeta de Red"
        echo
        ifconfig $interfaz2 down >/dev/null
        sleep 2.5
         ifconfig $interfaz2 promisc >/dev/null
         macchanger -p $interfaz2 >/dev/null
         ifconfig $interfaz2 up >/dev/null
         ifconfig $interfaz2 -promisc >/dev/null
         airmon-ng stop $interfaz2 >/dev/null
        echo "=============================="
        echo "  Desactivando Modo Monitor"
        echo "Restableciendo Tarjeta  de Red"
        echo "=============================="
        echo "-------->""                    |"
        sleep 0.30
        echo "--------------->""             |"
        sleep 0.30
        echo "---------------------->""      |"
        sleep 0.30
        echo "---------------------------->""|"
        echo "=============================="
        echo
  /etc/init.d/networking restart
}

check_managed() {
        #Comprobacion de si la Tarjeta de Red esta en Modo Managed, en caso >
        if [ $mode = Managed ]; then
    sleep 0.25
        echo
    echo -e "$blue(Modo)$nc ................................................>
    sleep 2
else
    sleep 0.25
        echo
echo -e "$red(Modo)$nc Monitor [$red✗$nc]"
        sleep 2
        clear
        DesaMonitor2
        echo
        echo "[#] Iniciando NetworkManager 45s"
        sleep 45
fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
        Title
        echo "[0] Requisitos"
        echo
         apt-get install xterm -y
         apt-get install gnome-terminal -y
         apt-get install wireless-tools aircrack-ng -y
         apt install aircrack-ng -y
         apt install airgraph-ng -y
         apt install nmap -y
         apt-get install mdk4 -y
         apt install hping3 -y
         apt-get install bettercap -y
         apt install wireshark -y
         apt-get install -y netdiscover -y
         apt install macchanger -y
         apt-get install john -y
         apt install iw -y
         apt-get install network-manager -y

        if ! [ -d requisitos/resultados ]
                then
                        mkdir requisitos/resultados
        fi
 cd requisitos

         rm -r Inhibitor

         git clone https://github.com/XDeadHackerX/Inhibitor.git && cd Inhib>

        cd ..
        cd ..

         chmod 777 wifi_troll.sh
         bash wifi_troll.sh
fi




