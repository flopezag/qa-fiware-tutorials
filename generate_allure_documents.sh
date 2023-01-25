#!/bin/bash

function generate_ngsiv2 {
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
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/303.Short_term_history.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/303.Short_term_history_cygnus.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/304.Time_Series_Data.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/305.Big_Data_Flink.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/305.Big_Data_Spark.feature

    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/401.Administrating_Users_and_Organizations.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/402.Managing_roles_and_permissions.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/403.Securing_Application_Access.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/404.Securing_Microservices_Northport.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/404.Securing_Microservices_Orion.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/404.Securing_Microservices_Southport.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/405.XACML_Rules-based_Permissions.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/406.Administrating_XACML_Rules.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/407.Securing_Access_OpenID_Connect.feature

    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/603.Traversing_Linked_Data_Orion.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/603.Traversing_Linked_Data_Scorpio.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/603.Traversing_Linked_Data_Stellio.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/604.Linked_Data_Subscriptions_and_Registrations_Orion.feature
}


function generate_ngsild {
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/102.ngsild.working_with_context.feature

    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/201.ngsild.IoTSensors.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/202.ngsild.IoTAgentUltralight.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/203.ngsild.IoTAgentJson.feature

    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/301.ngsild.TimeseriesData.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/302.ngsild.BigDataFlink.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/306.ngsild.BigDataSpark.feature

    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/601.LD-Intro_Orion-LD.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/601.LD-Intro_Scorpio.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/601.LD-Intro_Stellio.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/602.LD-RelationshipsAndDataModels_Orion-LD.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/602.LD-RelationshipsAndDataModels_Scorpio.feature
    behave -f allure_behave.formatter:AllureFormatter -o ./tmp ./features/602.LD-RelationshipsAndDataModels_Stellio.feature
}


if [ -n "$1" ];
then
    parameter=$1

    if [[ $parameter == "ngsiv2"  || $parameter == "ngsild" ]];
    then
        name='generate_'$parameter

        echo $name
        echo
        time eval $name
    else
        echo 'No correct values, expected parameter values are ngsiv2 or ngsild'
    fi
else
    echo 'No parameter passed.'
fi

# Time to execute NGSIv2: 50m45.113s
# Time to execute NGSI-LD: 3m47.608s
