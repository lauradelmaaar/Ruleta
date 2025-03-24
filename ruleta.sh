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
    echo -ne "\n${yellowColour}[+]${endColour}${grayColour} ¿Cuánto dinero deseas apostar? -> ${endColour}${yellowColour}"
    read initial_bet
    echo -ne "\n${endColour}${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (${yellowColour}par${endColour}${grayColour}/${endColour}${yellowColour}impar${endColour}${grayColour})? -> ${endColour}${yellowColour}"
    read par_impar
    
    play_counter="$1"
    jugadas_malas=""
    initial_capital="$money"
    backup_bet=$initial_bet
    while true; do
        if [ "$money" -lt "$initial_bet" ]; then
            
            echo -e "\n${redColour}[!] No tienes suficiente dinero para apostar ${yellowColour}$initial_bet€${endColour}${redColour}. Tu capital inicial era${endColour}${yellowColour} $initial_capital€${endColour}${redColour} te quedan ${endColour}${yellowColour}$money€${endColour}. "
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Han habido un total de :${endColour}${yellowColour} $play_counter jugadas${endColour}"
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} A continuacion se van a representar las jugadas malas consecutivas que han salido: ${endColour}\n"
            echo -e "${blueColour}[ $jugadas_malas]${endColour}"
            exit 0
        fi
        
        random_number=$((RANDOM % 37))
        money=$((money - initial_bet))
        if [[ ( "$par_impar" == "par" && $random_number -ne 0 && $((random_number % 2)) -eq 0 ) || ( "$par_impar" == "impar" && $((random_number % 2)) -eq 1 ) ]]; then
            reward=$((initial_bet * 2))
            money=$((money + reward))
            initial_bet=$backup_bet
            jugadas_malas=""
        else
            initial_bet=$((initial_bet * 2))
            jugadas_malas+="$random_number "
        fi
        ((play_counter+=1))
        
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