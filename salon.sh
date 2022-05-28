#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"


SERVICE() {
# echo argument message
echo -e $1

#services function
SERVICES=$($PSQL "SELECT service_id, name FROM services")
echo -e "$SERVICES" | while IFS=" " read ID BAR NAME
do
   #echo $NAME
   if [[ $NAME != 'name' && ! -z $NAME ]]
   then
      #display services
      echo -E $ID\) $NAME
   fi
done

# read input in service_id
read SERVICE_ID_SELECTED
# check if valid 
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED" --tuples-only)
# if not send to services funtion
if [[ -z $SERVICE_NAME ]]
then
   SERVICE "\nI could not find that service. What would you like today?"
fi
# read phone number
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

# check if phone number is a customer
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'" --tuples-only)

if [[ -z $CUSTOMER_NAME ]]
then
# read name if not a customer
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  #add to the customer list
  CUSTOMER_ADDING_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
fi

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'" --tuples-only)
# read time for appointment
echo -e "\nWhat time would you like your$SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME
# add appointment
ADD_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.\n"

exit

}

SERVICE "Welcome to My Salon, how can I help you?\n"
