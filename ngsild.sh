#!/bin/bash

function function_one {
  echo "Function one (expected time: 2m 14,057s)"
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/102.ngsild.working_with_context_orionld.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/102.ngsild.working_with_context_scorpio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/102.ngsild.working_with_context_stellio.feature
}

function function_two {
  echo "Function two (expected time: 5m 14,621s)"
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/201.ngsild.IoTSensors.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/202.ngsild.IoTAgentUltralight_orionld.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/202.ngsild.IoTAgentUltralight_scorpio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/202.ngsild.IoTAgentUltralight_stellio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/203.ngsild.IoTAgentJson_orionld.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/203.ngsild.IoTAgentJson_scorpio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/203.ngsild.IoTAgentJson_stellio.feature
}

function function_three {
  echo "Function three (expected time: 2m 52,834s)"
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/304.ngsild.TimeseriesData_orionld.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/304.ngsild.TimeseriesData_scorpio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/304.ngsild.TimeseriesData_stellio.feature
  # F behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/302.ngsild.BigDataFlink_orionld.feature
  # F behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/306.ngsild.BigDataSpark_orionld.feature
}

function function_four {
  echo "Function four (expected time: 3m 1,707s)"
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/601.ngsild.Intro_Orion-LD.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/601.ngsild.Intro_Scorpio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/601.ngsild.Intro_Stellio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/602.ngsild.RelationshipsAndDataModels_Orion-LD.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/602.ngsild.RelationshipsAndDataModels_Scorpio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/602.ngsild.RelationshipsAndDataModels_Stellio.feature
}

function function_all {
  echo "function all (expected time: )"
  echo

  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/102.ngsild.working_with_context_orionld.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/102.ngsild.working_with_context_scorpio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/102.ngsild.working_with_context_stellio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/201.ngsild.IoTSensors.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/202.ngsild.IoTAgentUltralight_orionld.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/202.ngsild.IoTAgentUltralight_scorpio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/202.ngsild.IoTAgentUltralight_stellio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/203.ngsild.IoTAgentJson_orionld.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/203.ngsild.IoTAgentJson_scorpio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/203.ngsild.IoTAgentJson_stellio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/301.ngsild.TimeseriesData_orionld.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/301.ngsild.TimeseriesData_scorpio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/301.ngsild.TimeseriesData_stellio.feature
  # F behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/302.ngsild.BigDataFlink_orionld.feature
  # F behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/306.ngsild.BigDataSpark_orionld.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/601.ngsild.Intro_Orion-LD.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/601.ngsild.Intro_Scorpio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/601.ngsild.Intro_Stellio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/602.ngsild.RelationshipsAndDataModels_Orion-LD.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/602.ngsild.RelationshipsAndDataModels_Scorpio.feature
  behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/602.ngsild.RelationshipsAndDataModels_Stellio.feature
}

# delete temporal folder before running the script
rm ./tmp/*

# print the different options
echo "Select one option:"
echo "1) Execute all 10x tests"
echo "2) Execute all 20x tests"
echo "3) Execute all 30x tests"
echo "4) Execute all 60x tests"
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
  5) time function_all ;;
  *) echo "Invalid number entered" ;;
esac

allure serve ./tmp
