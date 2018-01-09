#!/usr/bin/bash

hash_good=$1
hash_test=$2
hash_test_length=${#hash_test}
hash_length=${#hash_good}
tab=()
tab_hash=(0 1 2 3 4 5 6 7 8 9 A B C D E F)
tab_bits=(0000 0001 0010 0011 0100 0101 0110 0111 1000 1001 1010 1011 1100 1101 1110 1111)


if [[ $# == 1 && $1 == "--help" ]]
then

	echo "
	 ______________________________________________________________
	|                                                              |
	|  Program 'hash.sh' służy do  sprawdzania haszówek. Są  to    |
	|  testy z odpowiedziami:                                      |
	|                                                              |
	|  TAK - 11                                                    |
	|  NIE - 00                                                    |
	|  NIE WIEM - 01 lub 10                                        |
	|                                                              |
	|  Za poprawną odpowiedź otrzymujemy punkt, za złą tracimy     |
	|  punkt. Odpowiadając 'nie wiem' stan punktów  się  utrzyma.  |
	|  Pierwszym parametrem  programu  jest prawidłowa  odpowiedź  |        
	|  zapisana w kodzie  szesnastkowym. Drugim  parametrem  jest  |
	|  odpowiedź którą chcemy  sprawdzić.  Odpowiedź  ta  również  |
	|  zapisana jest w kodzie szesnastkowym. Oba kody zmieniane są |
	|  na postać binarną, a następnie porównywane są odpowiednie   |   
	|  pary kodów.                                                 |
	|                                                              |
	|   Przykład:                                                  |
	|                                                              |
	|   ./hash.sh F033 F12B                                        |
	|   1111000000110011                                           |
	|   1111000100101011                                           |
	|   5                                                          |
	|______________________________________________________________|
	"
exit

elif [[ $# == 0 || $# == 1 ]]
then
	echo "Niepoprawna ilość haszy. Wymagam hasz testowy oraz oryginalny."
	exit
elif [[ "$hash_length" != "$hash_test_length" ]]
then
	echo "Podane hasze są różnej długości"
	exit
fi

#Wstawienie hasza do tablicy i do zmiennej dehash

function hash_f ()
{
	dehash=""

	for (( i=0 ; i<$2 ; i++ ))
	do
		tab[i]=${1:$i:1}
		for (( j=0 ; j<16 ; j++ ))
		do
			if [[ "${tab[i]}" == "${tab_hash[j]}" ]]
			then
				tab[i]=${tab_bits[j]}
				dehash=$dehash${tab[i]}
			fi
		done
	done
}

function check_hash ()
{
	score=0
	for (( i=0 ; i<$3 ; i+=2 ))
	do
		tmp_good=${1:$i:2}
		tmp_test=${2:$i:2}
		if [[ "$tmp_good" == "$tmp_test" ]]
		then
			(( score++ ))
		elif [[ "$tmp_test" == "01" || "$tmp_test" == "10" ]]
		then
			continue
		elif [[ "$tmp_good" != "$tmp_test" ]]
		then
			(( score-- ))
		fi
	done
}

hash_f $hash_good $hash_length

bits_good=$dehash

hash_f $hash_test $hash_length

bits_test=$dehash

echo "$bits_good"
echo "$bits_test"

check_hash $bits_good $bits_test ${#bits_good}

echo "$score"