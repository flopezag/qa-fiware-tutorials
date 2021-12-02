from sys import stdout

from behave import given, when, step, then
from config.settings import CODE_HOME
from os.path import join, isdir, exists
from os import chdir, getcwd, environ, listdir
from requests import get, ConnectionError, HTTPError
from logging import getLogger
from features.funtions import check_java_version
import subprocess
from hamcrest import assert_that, is_
from re import match

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

        if version != 8:
            raise AssertionError("Java Runtime Environment must be 8 in the tutorial: {}".format(version))

        url = "https://github.com/ging/fiware-cosmos-orion-flink-connector/releases/download/FIWARE_7.9.1/"\
              + orion_flink_connector

        try:
            r = get(url, allow_redirects=True)
            open('orion.flink.connector-1.2.4.jar', 'wb').write(r.content)
        except ConnectionError:
            raise AssertionError('There were some network problems (e.g. refused connection or internet issues).')
        except HTTPError:
            raise AssertionError(True, 'Invalid HTTP response.')

        # Check that the file is downloaded
        file_exists = False
        file_exists = exists(orion_flink_connector)
        if file_exists is False:
            raise AssertionError(file_exists, 'The Orion-Flink-Connector file was not downloaded')


@when("I execute the maven install command")
def step_impl(context):
    command = "mvn install:install-file \
        -Dfile=./orion.flink.connector-1.2.4.jar \
        -DgroupId=org.fiware.cosmos \
        -DartifactId=orion.flink.connector \
        -Dversion=1.2.4 \
        -Dpackaging=jar"

    my_env = environ.copy()
    p = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=my_env)

    (std_out, std_err) = p.communicate()

    assert(p.returncode == 0, f'\nReturn code maven install: {p.returncode}')

    # We need to check the result of maven execution in the std_out to find BUILD FAILURE or BUILD BUILD SUCCESS
    assert(str(std_out).find('BUILD SUCCESS') != -1, 'The maven install was not successful')


@step("I execute the maven package command")
def step_impl(context):
    command = "mvn package"

    my_env = environ.copy()

    p = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=my_env)

    (std_out, std_err) = p.communicate()

    assert(p.returncode == 0, f'\nReturn code maven install: {p.returncode}')

    # We need to check the result of maven execution in the std_out to find BUILD FAILURE or BUILD BUILD SUCCESS
    assert(str(std_out).find('BUILD SUCCESS') != -1, 'The maven install was not successful')


@then('A new JAR file called "{file}" is created within the "{folder}" directory')
def step_impl(context, file, folder):
    """
    :param file: The name of the jar file
    :param folder: The folder in which this jar file is located
    :type context: behave.runner.Context
    """

    folder = "./" + folder.split("/")[1]
    file = folder + "/" + file
    # Check that the file is downloaded
    file_exists = False
    context.possible_file = ''
    file_exists = exists(file)

    if file_exists is False:
        files = listdir(folder)
        aux = [match('cosmos-examples-.*\.jar', file) for file in files]
        context.possible_file = [x for x in aux if x is not None][0].group(0)

        raise AssertionError(f'The {file} jar file was not created. There is a {context.possible_file} to be used now')
