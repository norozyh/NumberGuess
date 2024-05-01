#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=guess_number -t --no-align -c"
SECRET=$(( $RANDOM % 1000 +1 ))
echo $SECRET
echo Enter your username:
read USERNAME

 #检查db中是否有user
PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE name='$USERNAME'")
if [[ -z $PLAYER_ID ]]

#若无，欢迎新用户
then
  echo Welcome, $USERNAME! It looks like this is your first time here.
  INSERT_USER=$($PSQL "INSERT INTO players(name) VALUES('$USERNAME');")
#若有，欢迎并显示历史战绩
else
  RESULT=$($PSQL "SELECT player_id,games_played,best_game FROM players WHERE name='$USERNAME';")
  echo $RESULT
  echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
fi
FLAG=0
CNT=0
while [[ $FLAG = 0 ]]
do
  echo Guess the secret number between 1 and 1000:
  read GUESS
  CNT=$(( $CNT+1 ))
  if ! [[ $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  elif [[ $GUESS > $SECRET ]]
  then
    echo "It's lower than that, guess again:"
  elif [[ $GUESS < $SECRET ]]
  then
    echo "It's higher than that, guess again:"
  else
    echo You guessed it in $CNT tries. The secret number was $SECRET. Nice job!
    FLAG=1
    #db中存入记录
  fi
done