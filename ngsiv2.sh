#!/bin/bash

function function_one {
  echo "Function one (expected time: 52s)"
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/101.Getting_Started.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/102.Entity_Relationships.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/103.CRUD-Operations.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/104.Context-Providers.feature
}

function function_two {
  echo "Function two (expected time: 3m 5s"
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/201.Introduction_to_IoT_Sensors.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/202.IotAgent_Ultralight.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/203.IotAgentJson.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/204.IotOverMqtt.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/205.CustonIoTAgent.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/206.IoTOverIoTATangle.feature
}

function function_three {
  echo "Function three (expected time: 12m 32s)"
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/301.Persisting_Flume_MongoDB.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/301.Persisting_Flume_MySQL.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/301.Persisting_Flume_PostgreSQL.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/303.Short_term_history_sthcomet.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/303.Short_term_history_cygnus.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/304.Time_Series_Data.feature
  # F behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/305.Big_Data_Flink.feature
  # F behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/305.Big_Data_Spark.feature
}

function function_four {
  echo "Function four (expected time: 7m 40s)"
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/401.Administrating_Users_and_Organizations.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/402.Managing_roles_and_permissions.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/403.Securing_Application_Access.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/404.Securing_Microservices_Northport.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/404.Securing_Microservices_Orion.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/404.Securing_Microservices_Southport.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/405.XACML_Rules-based_Permissions.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/406.Administrating_XACML_Rules.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/407.Securing_Access_OpenID_Connect.feature
}

function function_five {
  echo "Function five (expected time: 3m 1,662s)"
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/603.Traversing_Linked_Data_Orion.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/603.Traversing_Linked_Data_Scorpio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/603.Traversing_Linked_Data_Stellio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/604.Linked_Data_Subscriptions_and_Registrations_Orion.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/604.Linked_Data_Subscriptions_and_Registrations_Stellio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/604.Linked_Data_Subscriptions_and_Registrations_Scorpio.feature
}

function function_all {
  echo "function all"
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/101.Getting_Started.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/102.Entity_Relationships.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/103.CRUD-Operations.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/104.Context-Providers.feature

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/201.Introduction_to_IoT_Sensors.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/202.IotAgent_Ultralight.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/203.IotAgentJson.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/204.IotOverMqtt.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/205.CustonIoTAgent.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/206.IoTOverIoTATangle.feature

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/301.Persisting_Flume_MongoDB.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/301.Persisting_Flume_MySQL.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/301.Persisting_Flume_PostgreSQL.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/303.Short_term_history_sthcomet.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/303.Short_term_history_cygnus.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/304.Time_Series_Data.feature
  # F behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/305.Big_Data_Flink.feature
  # F behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/305.Big_Data_Spark.feature

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/401.Administrating_Users_and_Organizations.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/402.Managing_roles_and_permissions.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/403.Securing_Application_Access.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/404.Securing_Microservices_Northport.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/404.Securing_Microservices_Orion.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/404.Securing_Microservices_Southport.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/405.XACML_Rules-based_Permissions.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/406.Administrating_XACML_Rules.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/407.Securing_Access_OpenID_Connect.feature

  # behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/603.Traversing_Linked_Data_Orion.feature
  # behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/603.Traversing_Linked_Data_Scorpio.feature
  # behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/603.Traversing_Linked_Data_Stellio.feature
  # behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/604.Linked_Data_Subscriptions_and_Registrations_Orion.feature
  # behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/604.Linked_Data_Subscriptions_and_Registrations_Stellio.feature
  # behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/604.Linked_Data_Subscriptions_and_Registrations_Scorpio.feature
}

# delete temporal folder before running the script
rm ./tmp/*

# print the different options
echo "Select one option:"
echo "1) Execute all 10x tests"
echo "2) Execute all 20x tests"
echo "3) Execute all 30x tests"
echo "4) Execute all 40x tests"
# echo "5) Execute all 60x tests"
echo "5) Execute all tests"
echo

# Read the number from the user
read -p "Enter a number (1-5): " num

# Call the appropriate function based on the number
case $num in
  1) time function_one ;;
  2) time function_two ;;
  3) time function_three ;;
  4) time function_four ;;
#  5) time function_five ;;
  5) time function_all ;;
  *) echo "Invalid number entered" ;;
esac


allure serve ./tmp
