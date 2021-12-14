from sys import stdout

from behave import given, when, step, then
from config.settings import CODE_HOME
from os.path import join, isdir, exists, basename
from os import chdir, getcwd, environ, listdir
from requests import get, post
from requests import ConnectionError, HTTPError, URLRequired, Timeout, TooManyRedirects
from logging import getLogger
from features.funtions import check_java_version, read_data_from_file
import subprocess
from re import match
from warnings import warn

__logger__ = getLogger(__name__)


new_file = ''
jar_file_id = ''


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
    global new_file

    folder = "./" + folder.split("/")[1]
    file = folder + "/" + file
    # Check that the file is downloaded
    file_exists = False
    file_exists = exists(file)

    if file_exists is False:
        files = listdir(folder)
        aux = [match('cosmos-examples-.*\.jar', file) for file in files]
        new_file = [x for x in aux if x is not None][0].group(0)
        new_file = folder + "/" + new_file

        warn(f'The {file} jar file was not created. There is a {new_file} to be used now')
    else:
        new_file = file


@given('I have generated the "{file}" in the target directory')
def step_impl(context, file):
    """
    :param file: the name of the jar file in the target directory
    :type context: behave.runner.Context
    """
    global new_file

    if new_file is not file:
        warn(f'The {file} jar file was not created. There is a {new_file} to be used now')


@when("I submit this new jar file to the Flink instance")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    global new_file

    file = {'file': open(new_file, 'rb')}

    url = 'http://localhost:8081/jars/upload'

    try:
        response = post(url, files=file)
    except ConnectionError:
        raise AssertionError('A Connection error occurred.')
    except HTTPError:
        raise AssertionError('An HTTP error occurred.')
    except URLRequired:
        raise AssertionError('A valid URL is required to make a request.')
    except TooManyRedirects:
        raise AssertionError('Too many redirects.')
    except Timeout:
        raise AssertionError('The request timed out.')

    context.status_code = response.status_code
    context.json = response.json()


@then("I receive the response with the following data")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    global jar_file_id

    for element in context.table.rows:
        valid_response = dict(element.as_dict())

        assert(valid_response['status'] == context.json['status'],
               f"The status of the Flink response should be \"success\", received: : {context.json['status']}")

        assert(valid_response['status_code'] == context.status_code,
               f"The status code should be \"200\", received: {context.status_code}")

        assert(context.json['filename'] is not None,
               f"The Flink response should contain a filename")

        jar_file_id = basename(context.json['filename'])


@given("I have a proper jar file id")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    global jar_file_id
    context.jar_file_id = jar_file_id


@when('I try to create a new job with Entry Class "{entry_class}"')
def step_impl(context, entry_class):
    """
    :param entry_class: The Java Entry Class to execute the Flink job
    :type context: behave.runner.Context
    """
    # curl -X POST http://localhost:8081/jars/bdadc251-01a0-4d43-807e-e9e321379730_cosmos-examples-1.2.jar/
    #     run?entry-class=org.fiware.cosmos.tutorial.Logger
    url = 'http://localhost:8081/jars/' + context.jar_file_id + '/run?entry-class=' + entry_class

    try:
        response = post(url)
    except ConnectionError:
        raise AssertionError('A Connection error occurred.')
    except HTTPError:
        raise AssertionError('An HTTP error occurred.')
    except URLRequired:
        raise AssertionError('A valid URL is required to make a request.')
    except TooManyRedirects:
        raise AssertionError('Too many redirects.')
    except Timeout:
        raise AssertionError('The request timed out.')

    context.status_code = response.status_code
    context.json = response.json()


@then("I receive the {status_code} Ok response with the id of the new created job")
def step_impl(context, status_code):
    """
    :param status_code: The status code of the response of the creation of a new Flink job
    :type context: behave.runner.Context
    """
    assert(context.status_code == status_code,
           f"The status code should be \"200\", received: {context.status_code}")

    job_id = context.json['jobid']

    assert(isinstance(context.json, dict),
           f"The response is not a dict, received {context.json}")

    assert('jobid' in context.json,
           f'The response does not include the key \"jobid\", received {context.json}')

    assert(context.json['jobid'] is not None,
           f'The key jsonid is Empty')


@step("The timesSent is bigger than 0")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: And    The timesSent is bigger than 0')


@step("The lastNotification should be a recent timestamp")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: And    The lastNotification should be a recent timestamp')


@step("The lastSuccess should match the lastNotification date")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: And    The lastSuccess should match the lastNotification date')


@step('The status is "active"')
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: And    The status is "active"')


@then('I obtain the output "{file}" from the console')
def step_impl(context, file):
    """
    :type context: behave.runner.Context
    """
    payload = read_data_from_file(context, file)
    print(file)


@when("I obtain the stderr log from the flink-taskmanager")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    command = "docker logs flink-taskmanager -f --until=60s > stdout.log 2>stderr.log"

    my_env = environ.copy()
    p = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=my_env)

    (std_out, std_err) = p.communicate()

    assert(p.returncode == 0, f'\nReturn code docker logs: {p.returncode}')

    command = "cat stderr.log"
    p = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=my_env)

    (std_out, std_err) = p.communicate()

    assert(p.returncode == 0, f'\nReturn cat: {p.returncode}')
