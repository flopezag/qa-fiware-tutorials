#!/bin/bash

function function_one {
  echo "Function one (expected time: 52s)"
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/101.Getting_Started.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/102.Entity_Relationships.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/103.CRUD-Operations.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/104.Context-Providers.feature
  echo
}

function function_two {
  echo "Function two (expected time: 3m 5s"
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/201.Introduction_to_IoT_Sensors.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/202.IotAgent_Ultralight.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/203.IotAgentJson.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/204.IotOverMqtt.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/205.CustonIoTAgent.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/206.IoTOverIoTATangle.feature
  echo
}

function function_three {
  echo "Function three (expected time: 12m 32s)"
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/301.Persisting_Flume_MongoDB.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/301.Persisting_Flume_MySQL.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/301.Persisting_Flume_PostgreSQL.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/303.Short_term_history_sthcomet.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/303.Short_term_history_cygnus.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/304.Time_Series_Data.feature
  echo

  # F behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/305.Big_Data_Flink.feature
  # F behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/305.Big_Data_Spark.feature
}

function function_four {
  echo "Function four (expected time: 7m 40s)"
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/401.Administrating_Users_and_Organizations.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/402.Managing_roles_and_permissions.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/403.Securing_Application_Access.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/404.Securing_Microservices_Northport.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/404.Securing_Microservices_Orion.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/404.Securing_Microservices_Southport.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/405.XACML_Rules-based_Permissions.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/406.Administrating_XACML_Rules.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/407.Securing_Access_OpenID_Connect.feature
  echo
}

function function_five {
  echo "Function five (expected time: )"
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/603.Traversing_Linked_Data_Orion.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/603.Traversing_Linked_Data_Scorpio.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/603.Traversing_Linked_Data_Stellio.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/604.Linked_Data_Subscriptions_and_Registrations_Orion.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/604.Linked_Data_Subscriptions_and_Registrations_Stellio.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/604.Linked_Data_Subscriptions_and_Registrations_Scorpio.feature
  echo
}

function function_all {
  echo "function all"
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/101.Getting_Started.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/102.Entity_Relationships.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/103.CRUD-Operations.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/104.Context-Providers.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/201.Introduction_to_IoT_Sensors.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/202.IotAgent_Ultralight.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/203.IotAgentJson.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/204.IotOverMqtt.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/205.CustonIoTAgent.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/206.IoTOverIoTATangle.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/301.Persisting_Flume_MongoDB.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/301.Persisting_Flume_MySQL.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/301.Persisting_Flume_PostgreSQL.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/303.Short_term_history.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/303.Short_term_history_cygnus.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/304.Time_Series_Data.feature
  echo

  # F behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/305.Big_Data_Flink.feature
  # F behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/305.Big_Data_Spark.feature

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/401.Administrating_Users_and_Organizations.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/402.Managing_roles_and_permissions.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/403.Securing_Application_Access.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/404.Securing_Microservices_Northport.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/404.Securing_Microservices_Orion.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/404.Securing_Microservices_Southport.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/405.XACML_Rules-based_Permissions.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/406.Administrating_XACML_Rules.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/407.Securing_Access_OpenID_Connect.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/603.Traversing_Linked_Data_Orion.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/603.Traversing_Linked_Data_Scorpio.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/603.Traversing_Linked_Data_Stellio.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/604.Linked_Data_Subscriptions_and_Registrations_Orion.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/604.Linked_Data_Subscriptions_and_Registrations_Stellio.feature
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/604.Linked_Data_Subscriptions_and_Registrations_Scorpio.feature
  echo
}

# delete temporal folder before running the script
rm ./tmp/*

# print the different options
echo "Select one option:"
echo "1) Execute all 10x tests"
echo "2) Execute all 20x tests"
echo "3) Execute all 30x tests"
echo "4) Execute all 40x tests"
echo "5) Execute all 60x tests"
echo "6) Execute all tests"
echo

# Read the number from the user
read -p "Enter a number (1-6): " num

# Call the appropriate function based on the number
case $num in
  1) time function_one ;;
  2) time function_two ;;
  3) time function_three ;;
  4) time function_four ;;
  5) time function_five ;;
  6) time function_all ;;
  *) echo "Invalid number entered" ;;
esac


allure serve ./tmp
