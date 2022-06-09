#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess --tuples-only -c"

RANDOM_NUMBER=$(( $RANDOM % 1000 + 1 ))
#echo $RANDOM_NUMBER

NUMBER_OF_GUESSES=0

GUESS() {
# Prompt to guess the number
echo $1

read USER_GUESS
# check if it is a valid number
if ! [[ "$USER_GUESS" =~ ^[0-9]+$ ]]
then
    GUESS "That is not an integer, guess again:" $2 $3 $4
fi

((NUMBER_OF_GUESSES++))
#echo guesses $NUMBER_OF_GUESSES

# Print lower if lower
if (( $USER_GUESS < $RANDOM_NUMBER ))
then
  GUESS "It's higher than that, guess again:" $2 $3 $4
fi
# Print higher if higher
if (( $USER_GUESS > $RANDOM_NUMBER ))
then
  GUESS "It's lower than that, guess again:" $2 $3 $4
fi

# Print correct if correct
if (( $USER_GUESS == $RANDOM_NUMBER ))
then
  echo -e "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $USER_GUESS. Nice job!"

  #echo "2 and 4: " $2 $4

  if [[ -z $2 ]]
  then
    #New user won insert into the database
    INSERT_RESULT=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 1, $NUMBER_OF_GUESSES)")
  else
    BEST_GAME=$(( $4 < NUMBER_OF_GUESSES ? $4 : NUMBER_OF_GUESSES ))
#    echo $4 $BEST_GAME
    # If correct insert info into the database
    UPDATE_RESULT=$($PSQL "UPDATE users SET games_played=games_played + 1, best_game = $BEST_GAME WHERE username='$USERNAME'")
  #echo $INSERT_RESULT
  fi
  exit 0
fi
}

# Ask for username
echo Enter your username:
# read username
read USERNAME

# query username to see if it existed before
QUERY_RESULT=$($PSQL "SELECT games_played, best_game FROM users WHERE username = '$USERNAME'")
if [[ -z $QUERY_RESULT ]]
  then
  # user not found
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  GUESS "Guess the secret number between 1 and 1000:"
  else
  # user found
  # respond if they are returning username
  echo $QUERY_RESULT | while read GAMES_PLAYED BAR BEST_GAME
  do 
    echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
  done
    GUESS "Guess the secret number between 1 and 1000:" $QUERY_RESULT
  #done
fi
