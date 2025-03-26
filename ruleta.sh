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
    if ! [[ "$initial_bet" =~ ^[0-9]+$ ]]; then
        echo -e "\n${redColour}[ERROR] La cantidad apostada debe ser un número entero positivo.${endColour}"
        exit 1
    fi
    echo -ne "\n${endColour}${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (${yellowColour}par${endColour}${grayColour}/${endColour}${yellowColour}impar${endColour}${grayColour})? -> ${endColour}${yellowColour}"
    read par_impar
    if [[ "$par_impar" != "par" && "$par_impar" != "impar" ]]; then
        echo -e "\n${redColour}[ERROR] Opción inválida. Debes escribir 'par' o 'impar'.${endColour}"
        exit 1
    fi
    
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

##########################################
#          Inverse Labrouchere           #
##########################################
function inverseLabrouchere(){
    echo -e "Estoy utilizando la funcion Inverse Labrouchere"
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour}${yellowColour} $money€${endColour}"
    echo -ne "\n${endColour}${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (${yellowColour}par${endColour}${grayColour}/${endColour}${yellowColour}impar${endColour}${grayColour})? -> ${endColour}${yellowColour}"
    read par_impar
    if [[ "$par_impar" != "par" && "$par_impar" != "impar" ]]; then
        echo -e "\n${redColour}[ERROR] Opción inválida. Debes escribir 'par' o 'impar'.${endColour}"
        exit 1
    fi
    
    declare -a lab=( 1 2 3 4 5 6 7 )
    first_number=${lab[0]}
    last_number=${lab[-1]}
    initial_bet=$(( first_number + last_number))
    total_elements=${#lab[@]}
    jugadas_malas=""
    initial_capital="$money"
    play_counter="$1"

    while true; do
        
        if [ "$money" -lt "$initial_bet" ] || [ "${#lab[@]}" -eq 0 ]; then
            echo -e "\n${redColour}[!] La partida ha acabado.${endColour}"
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Se han jugado ${blueColour}$play_counter${endColour} partidas. A continuacion se van a representar las jugadas malas consecutivas que han salido: ${endColour}\n"
            echo -e "${blueColour}[ $jugadas_malas]${endColour}"
            exit 0
        fi
        
        random_number=$((RANDOM % 37))
        money=$((money - initial_bet))
        all_elements="${lab[@]}"
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} La lista es: ${endColour}${blueColour}$all_elements${endColour}"
        echo -e "${yellowColour}[+]${endColour}${grayColour} Has apostado${endColour}${yellowColour} $initial_bet${endColour}${grayColour}. Tienes: ${endColour}${yellowColour} $money€${endColour}"
        echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el número: ${endColour}${orangeColour}$random_number${endColour}"

        # aciertas
        if [[ ( "$par_impar" == "par" && $random_number -ne 0 && $((random_number % 2)) -eq 0 ) || ( "$par_impar" == "impar" && $((random_number % 2)) -eq 1 ) ]]; then
            echo -e "${greenColour}[+]${endColour}${grayColour} GANAS!${endColour}"
            addLast=$(( ${lab[0]} + ${lab[-1]} ))
            lab+=($addLast)
            reward=$((initial_bet + $addLast))
            money=$((money + reward))
            first_number=${lab[0]}
            last_number=${lab[-1]}
            initial_bet=$(( first_number + last_number))
            jugadas_malas=""
            echo -e "${yellowColour}[+]${endColour}${grayColour} ahora tienes ${endColour}${yellowColour}$money${endColour}"
            
            # sleep 3
            
        # pierdes
        else
            echo -e "${redColour}[-]${endColour}${grayColour} PIERDES!${endColour}"
            first_number=${lab[0]}
            last_number=${lab[-1]}
            
            if [ "${#lab[@]}" -eq 1 ]; then
                unset lab[0]
            else
                unset lab[0]
                unset lab[-1]
            fi
            
            lab=(${lab[@]})
            total_elements=${#lab[@]}
            if [ ! "$total_elements" -eq 0 ]; then
                first_number=${lab[0]}
                last_number=${lab[-1]}
                
            fi
            initial_bet=$(( first_number + last_number ))
            jugadas_malas+="$random_number "
            #sleep 3
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
        
        elif [ "$technique" == "inverse" ]; then
        inverseLabrouchere
    else
        echo -e "\n${redColour}[!] La tecnica no existe${endColour}"
        helpPanel
    fi
else
    helpPanel
fi