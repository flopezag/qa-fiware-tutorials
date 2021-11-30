from sys import stdout

from behave import given, when, step, then
from config.settings import CODE_HOME
from os.path import join, isdir, isfile, exists
from os import chdir, getcwd, system
from requests import get, post, exceptions, ConnectionError, HTTPError
from logging import getLogger
from json import loads, dumps
from features.funtions import read_data_from_file, replace_dates_query, http, check_cratedb_health_status, \
    check_java_version
from time import sleep
from datetime import datetime, timedelta, timezone
import subprocess
from os import environ
from hamcrest import assert_that, is_, is_not

__logger__ = getLogger(__name__)


@given(u'I set the tutorial 305')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "305.Big_Data_Flink")


@given('I download the Orion Flink Connector "{orion_flink_connector}"')
def step_impl(context, orion_flink_connector):
    """
    :param orion_flink_connector: the corresponding version jar file to download
    :type context: behave.runner.Context
    """
    # We need to check if the .jar file is created in the "context.parameters['git-directory']"/cosmos-example/target
    # therefore we need to check if /target exist and if cosmos-examples-1.2.jar exist in that folder
    path = join(context.parameters['git-directory'], "cosmos-examples/target")

    if isdir(path) is False:
        # The directory was not created therefore if was not executed the maven package
        cwd = getcwd()
        chdir(join(context.parameters['git-directory'], 'cosmos-examples'))

        # We need to check that the JAVA_HOME points to a 1.8 version
        version = check_java_version()
        assert_that(version, is_(8),
                    "Java Runtime Environment must be 8 in the tutorial: {}"
                    .format(version))

        url = "https://github.com/ging/fiware-cosmos-orion-flink-connector/releases/download/FIWARE_7.9.1/"\
              + orion_flink_connector

        try:
            r = get(url, allow_redirects=True)
            open('orion.flink.connector-1.2.4.jar', 'wb').write(r.content)
        except ConnectionError as e:
            assert(True, 'There were some network problems (e.g. refused connection or internet issues).')
        except HTTPError as e:
            assert(True, 'Invalid HTTP response.')

        # Check that the file is downloaded
        file_exists = exists(orion_flink_connector)
        assert(file_exists is True, 'The Orion-Flink-Connector file was not downloaded')


@when("I execute the maven install command")
def step_impl(context):
    mvn = "mvn install:install-file \
        -Dfile=./orion.flink.connector-1.2.4.jar \
        -DgroupId=org.fiware.cosmos \
        -DartifactId=orion.flink.connector \
        -Dversion=1.2.4 \
        -Dpackaging=jar"

    p = subprocess.Popen(mvn, shell=True, stdout=subprocess.PIPE)

    std_out, std_err = p.communicate()
    stdout.write(f'Return code maven install: {p.returncode}')  # is 0 if success

    if p.returncode == 0:
        mvn = "mvn package"
        p = subprocess.Popen(mvn, shell=True, stdout=subprocess.PIPE)

        std_out, std_err = p.communicate()
        print(p.returncode)  # is 0 if success
    else:
        stdout.write(f'Return code maven package: {p.returncode}')

    # A new JAR file called cosmos-examples-1.1.jar will be created within the cosmos-examples/target directory.


@step("I execute the maven package command")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: And    I execute the maven package command')


@then('A new JAR file called "cosmos-examples-1.1.jar" will be created within the "cosmos-examples/target" directory')
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(
        u'STEP: Then   A new JAR file called "cosmos-examples-1.1.jar" will be created within the "cosmos-examples/target" directory')