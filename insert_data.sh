#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#year, round, winner, opponent, winner_goals, opponent_goals
#IF( query winner NULL ) then INSERT INTO teams(name) VALUES(winner)
#IF(quary winner and opponent not null) then INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES(..);
exec < games.csv
read HEADER
while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
   #echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
   WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE (name = '$WINNER')")"
   if [ -z $WINNER_ID ]
   then
      RESULT="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE (name = '$WINNER')")"
   fi

   OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE (name = '$OPPONENT')")"
   if [ -z $OPPONENT_ID ]
   then
      RESULT="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE (name = '$OPPONENT')")"
   fi
   #echo $WINNER_ID $OPPONENT_ID

   RESULT="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")"
  # echo $RESULT
done 
