#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess --tuples-only -t -c"
SECRET=$(( $RANDOM % 1000 +1 ))

echo Enter your username:
read USERNAME

 #检查db中是否有user
PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE name='$USERNAME'")
if [[ -z $PLAYER_ID ]]

#若无，欢迎新用户
then
  echo Welcome, $USERNAME! It looks like this is your first time here.
  INSERT_USER=$($PSQL "INSERT INTO players(name) VALUES('$USERNAME');")
  PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE name='$USERNAME'")
#若有，欢迎并显示历史战绩
else
  RESULT=$($PSQL "SELECT name,games_played,best_game FROM players WHERE player_id=$PLAYER_ID;")
  echo $RESULT | while read USERNAME BAR GAMES_PLAYED BAR BEST_GAME
  do
    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi
FLAG=0
CNT=0
while [[ $FLAG = 0 ]]
do
  echo Guess the secret number between 1 and 1000:
  read GUESS
  
  if ! [[ $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    
  elif [[ $GUESS -gt $SECRET ]]
  then
    echo "It's lower than that, guess again:"
    CNT=$(( $CNT+1 ))
  elif [[ $GUESS -lt $SECRET ]]
  then
    echo "It's higher than that, guess again:"
    CNT=$(( $CNT+1 ))
  else
    CNT=$(( $CNT+1 ))
    FLAG=1
    #db中存入记录
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE players SET games_played=games_played+1 WHERE player_id=$PLAYER_ID")
    BEST_GAME=$($PSQL "SELECT best_game FROM players WHERE player_id=$PLAYER_ID;")
    if [[ $BEST_GAME -eq 0 ]] || [[ $BEST_GAME -gt $CNT ]]
    then
      INSERT_BEST_GAME=$($PSQL "UPDATE players SET best_game=$CNT WHERE player_id=$PLAYER_ID;") 
    fi
    echo "You guessed it in $CNT tries. The secret number was $SECRET. Nice job!" 
  fi
done