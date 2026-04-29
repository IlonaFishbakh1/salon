#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU(){
    echo "$($PSQL "SELECT service_id || ') ' || name FROM services ORDER BY service_id")"
}

echo -e "\nWelcome to the salon, choose your option: "
MAIN_MENU

read SERVICE_ID_SELECTED
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")

while [[ -z $SERVICE_NAME ]]
do
  MAIN_MENU "You choose the wrong number"
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
done

echo -e "\nEnter your phone number: "
read CUSTOMER_PHONE

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
#CUSTOMER_ID=$(echo $CUSTOMER_ID | xargs)

if [[ -z $CUSTOMER_ID ]] 
then
  echo -e "\nEnter your name: "
  read CUSTOMER_NAME
  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name,phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  CUSTOMER_ID=$(echo $CUSTOMER_ID | xargs)
else
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id='$CUSTOMER_ID'")
fi

echo -e "\nWhat time do you like your $SERVICE_NAME, $CUSTOMER_NAME ?"
read SERVICE_TIME

INSERT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
echo "I have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
