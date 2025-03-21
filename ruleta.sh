#!/bin/bash
#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
orangeColour="\e[38;5;214m\033[1m"
pinkColour="\e[38;5;219m\033[1m"
brownColour="\e[38;5;94m\033[1m"
cyanColour="\e[0;96m\033[1m"

function ctrl_c(){
    echo -e "\n\n[!] Saliendo...\n"
    exit 1
}

# ctrl_c
trap ctrl_c INT

##########################################
#               Help Panel               #
##########################################

function helpPanel(){
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso: ${endColour}"
    echo -e "\t${blueColour}-m)${endColour}${grayColour} Dinero con el que se desea jugar.${endColour}"
    echo -e "\t${blueColour}-t)${endColour}${grayColour} Técnica que se desea emplear: ${endColour}${purpleColour}martingala${endColour} ${grayColour}/${endColour} ${purpleColour}inverseLabrouchere${endColour}"
    exit 1
}
##########################################
#              MARTINGALA                #
##########################################
function martingala(){
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour}${yellowColour} $money€${endColour}"
    echo -ne "\n${yellowColour}[+]${endColour}${grayColour} ¿Cuánto dinero deseas apostar? -> ${endColour}${yellowColour}" && read initial_bet
    echo -ne "\n${endColour}${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (${yellowColour}par${endColour}${grayColour}/${endColour}${yellowColour}impar${endColour}${grayColour})? -> ${endColour}${yellowColour}" && read par_impar
    
    echo -e "\n${endColour}${yellowColour}[+]${endColour}${grayColour} Vamos a jugar una cantidad inicial de${endColour}${yellowColour} $initial_bet€${endColour}${grayColour} a${endColour}${yellowColour} $par_impar${endColour}\n"
    

    while true; do
        random_number="$(($RANDOM % 7))"
        money=$((money - initial_bet))
        echo -e "${endColour}${yellowColour}[+]${endColour}${grayColour} Acabas de apostar${endColour}${yellowColour} $initial_bet€${endColour}${grayColour} y tienes ${endColour}${yellowColour} $money€ ${endColour}"
        sleep 1
        echo -e "${yellowColour}[+]${endColour} Ha salido el numero $random_number"
        sleep 1
        if { { [[ "$par_impar" == "par" ]] && (( random_number % 2 == 0 )) && (( random_number != 0 )) ;} || { [[ "$par_impar" == "impar" ]] && (( random_number % 2 == 1 ));} }; then
            actual_bet=$((initial_bet * 2))
            
            money=$((money + initial_bet * 2))
            echo -e "${greenColour}[+] Has ganado ${yellowColour}$actual_bet${endColour},${greenColour} ahora tienes${endColour} ${yellowColour}$money${endColour}\n"
        else
            echo -e "${redColour}[-] Has perdido ${yellowColour}$initial_bet${endColour}${redColour}, ahora tienes${endColour} ${yellowColour}$money${endColour}\n"
        fi
        sleep 3
    done
}


while getopts "m:t:h" flag; do
    case $flag in
        m) money=$OPTARG;;
        t) technique=$OPTARG;;
        h) helpPanel;;
    esac
done

if [ $money ] && [ $technique ] ; then
    if [ "$technique" == "martingala" ]; then
        martingala
    else
        echo -e "\n${redColour}[!] La tecnica no existe${endColour}"
        helpPanel
    fi
else
    helpPanel
fi