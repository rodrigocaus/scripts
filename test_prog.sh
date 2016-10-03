#!/bin/bash
#Execution script for .c programming
#Steps on this script
	#1. Compile .c using gcc -std=c11 -pedantic -Wall  *.c -o lab.o
	#2. Execute .o file using .in file as entry
	#3. Compare .out files with exit files using diff

###############################################################################

#Define some colors
RED='\e[1;31m'
GREEN='\e[1;32m'
NC='\e[0m'

#Starts interaction
echo "Nome do programa: "
read NAME

#Compile program
gcc -std=c11 -pedantic -Wall *.c -o $NAME
if (($? != 0));
then
	echo -e "${RED}Erro de compilação!${NC}"
else
	#Ask's if you want to test
	echo "Testar arquivos?(s/n)"
	read ANSW
	if((($ANSW == 's') || ($ANSW == 'S')));
	then
		clear
		echo "******************************"
		for ARQ in $(ls *.in);
		do
			timeout 1 ./$NAME <$ARQ >saida.out
			ERROR="$?"
			if(($ERROR == 139));
			then
				#It detects segmentation fault
				echo -e "${RED}Falha de Segmentação!${NC}"
				echo "******************************"
				printf "\n"
			elif ((($ERROR == 124) || ($ERROR == 125)));
			then
				#Problems with execution time (>1s)
				echo -e "${RED}Tempo limite excedido!${NC}"
				echo "******************************"
				printf "\n"
			else
				#The .out file has de same name as .in file
				diff ${ARQ:0:(${#ARQ}-2)}out saida.out
				if(($? != 0));
				then
					echo -e "${RED}Saida Incorreta!${NC}"
					echo "******************************"
					printf "\n"
				else
					echo -e "${GREEN}Saida correta!${NC}"
					echo "******************************"
					printf "\n"
				fi
			fi
		done
		rm "saida.out"
	fi
fi
