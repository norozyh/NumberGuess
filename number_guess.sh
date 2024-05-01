#!/bin/bash

SECRET=$(( $RANDOM % 1000 +1 ))
echo $SECRET
echo Enter your username:
read USERNAME

 #检查db中是否有user

if [[ $1 ]]

#若有，欢迎并显示历史战绩
then
  echo Welcome back, <username>! You have played <games_played> games, and your best game took <best_game> guesses.
#若无，欢迎新用户
else
  echo Welcome, <username>! It looks like this is your first time here.

fi
FLAG=0
while [[ $FLAG = 0 ]]
do
  echo Guess the secret number between 1 and 1000:
  read GUESS
  if [[ !$GUESS =~ [0~9]+ ]]
  then
    echo "That is not an integer, guess again:"
  elif [[ $GUESS > $SECRET ]]
  then
    echo "It's lower than that, guess again:"
  elif [[ $GUESS < $SECRET ]]
  then
    echo "It's higher than that, guess again:"
  else
    echo You guessed it in <number_of_guesses> tries. The secret number was <secret_number>. Nice job!
    FLAG=1
  fi
done