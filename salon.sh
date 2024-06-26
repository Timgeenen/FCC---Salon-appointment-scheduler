#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"
SERVICE_MENU="1) cut\n2) color\n3) perm\n4) style\n5) trim"

MAIN_MENU() {

  if [[ $1 ]]
  then
    echo -e "\n$1\n"
  fi
  echo -e $SERVICE_MENU

  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
  [0-5]) APPOINTMENT_MENU ;;
  *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

APPOINTMENT_MENU() {
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'" | sed 's/ //')
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED" | sed 's/ //')

  if [[ ! $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    echo "$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")"
  fi
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME'" | sed 's/ //')


  echo -e "\nWhat time would you like your $SERVICE, $CUSTOMER_NAME?"
  read SERVICE_TIME
  echo "$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")"

  echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."

}

MAIN_MENU