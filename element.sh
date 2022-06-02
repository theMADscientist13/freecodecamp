#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -X -c"
if [[ -z $1 ]]
then
   echo "Please provide an element as an argument."
   exit 0
else

PRINT_ELEMENT() {
  if [[ -z $RESULT ]]
  then
    echo "I could not find that element in the database."
    exit 0
  fi
#  echo $RESULT | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING BAR BOILING BAR TYPE BAR;
#  echo $RESULT | while IFS=" | " read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING BOILING TYPE;
#    do
#      echo "The element with the atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
#    done

echo "$RESULT" | while IFS="|" read TYPE_ID AUTOMIC_NUM SYMBOL NAME ATOMIC_MASS MPC BPC TYPE
do
echo "The element with atomic number $AUTOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."

done
}

if [[ $1 == ?(-)+([0-9]) ]]
then
   RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $1")
   #echo $RESULT
   PRINT_ELEMENT $RESULT
   #echo $ATOMIC_NUMBER $SYMBOL
else
  if [[ ${#1} -le 2  ]]
  then
    RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$1'")
    PRINT_ELEMENT $RESULT
  else
    RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name = '$1'")
    PRINT_ELEMENT $RESULT
  fi
fi

fi
