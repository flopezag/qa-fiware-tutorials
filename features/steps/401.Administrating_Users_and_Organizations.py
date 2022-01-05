from behave import given, when, then, step
from config.settings import CODE_HOME
from os.path import join
from os import environ
import subprocess
from hamcrest import assert_that, is_
from features.funtions import read_data_from_file, dict_diff_with_exclusions
from json import loads
from requests import get, RequestException

Token = str()

@given(u'I set the tutorial 401')
def step_impl_tutorial_203(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "401.Administrating_Users_and_Organizations")


@when("I request the information from user table")
def step_impl(context):
    my_env = environ.copy()
    temp = subprocess.Popen(context.command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=my_env)

    if temp.returncode == 0 or temp.returncode is None:  # is 0 or None if success
        (output, stderr) = temp.communicate()

        output = output.decode('utf-8').replace('\t', ' ').split('\n')

        del output[2]
        output[0] = output[0].split(" ")
        output[1] = output[1].split(" ")

        aux = dict()
        for i in range(0, len(output[0])):
            aux[output[0][i]] = output[1][i]

        context.output = aux
    else:
        raise AssertionError('An docker error was produced during the execution of the command')


@given("I connect to the MySQL docker instance with the following data")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    # docker exec -it <docker instance> mysql -u<user> -p<password> <database>
    #             -e 'select id, username, email, password from user;'

    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        # | DockerInstance | User | Password | Database | Columns | Table |
        docker_instance = valid_response['DockerInstance']
        user = valid_response['User']
        password = valid_response['Password']
        database = valid_response['Database']
        columns = valid_response['Columns']
        table = valid_response['Table']

        select_stmt = f"'select {columns} from {table};'"

        context.command = f"docker exec {docker_instance} mysql -u{user} -p{password} {database} -e {select_stmt}"


@then("I obtain the following data from MySQL")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        user_id = valid_response['id']
        username = valid_response['username']
        email = valid_response['email']

        obtained_user_id = context.output['id']
        obtained_username = context.output['username']
        obtained_email = context.output['email']

        assert (user_id == obtained_user_id), \
            f"\nThe id value is not the expected, obtained {user_id}, but expected: {obtained_user_id}"

        assert (username == obtained_username), \
            f"\nThe id value is not the expected, obtained {username}, but expected: {obtained_username}"

        assert (email == obtained_email), \
            f"\nThe id value is not the expected, obtained {email}, but expected: {obtained_email}"

        assert ('password' in context.output.keys()), \
            f'There should be a password data in the obtained values'


@then("I receive a HTTP response with the following data in header and payload")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    global Token

    for element in context.table.rows:
        valid_response = dict(element.as_dict())

        assert (context.statusCode == valid_response['Status-Code']), \
            f"Status Code wrong, expected \"{valid_response['Status-Code']}\" but was received \"{context.statusCode}\""

        v_connection = valid_response['Connection']
        r_connection = context.responseHeaders['Connection']
        assert (r_connection == v_connection), \
            f"Invalid Connection value, expected \"{v_connection}\" but was received \"{r_connection}\""

        assert ('X-Subject-Token' in context.responseHeaders), \
            f"Unable to get X-Subject-Token in the header of the response"

        Token = context.responseHeaders['X-Subject-Token']

        # Check the HTTP response
        body = loads(read_data_from_file(context, valid_response['data']))

        diff = dict_diff_with_exclusions(context, body, context.response, valid_response['excluded'])

        assert_that(diff.to_dict(), is_(dict()),
                    f'Response from Keyrock has not got the expected HTTP response body:\n  {diff}')


@when('I send GET HTTP request to "{url}" with equal X-Auth-Token and X-Subject-Token')
def step_impl(context, url):
    """
    :type context: behave.runner.Context
    """
    try:
        headers = {
            'Content-Type': 'application/json',
            'X-Auth-token': Token,
            'X-Subject-token': Token
        }

        response = get(url, headers=headers, verify=False)

        # override encoding by real educated guess as provided by chardet
        response.encoding = response.apparent_encoding
    except RequestException as e:
        raise SystemExit(e)

    context.response = response.json()
    context.statusCode = str(response.status_code)


@then(u'I receive a HTTP "{code}" status code from Keyrock with the body "{file}" and exclusions "{excl_file}"')
def receive_post_iot_dummy_response_with_data(context, code, file, excl_file):
    body = loads(read_data_from_file(context, file))

    diff = dict_diff_with_exclusions(context, body, context.response, excl_file)

    assert_that(diff.to_dict(), is_(dict()),
                f'Response from Keyrock has not got the expected HTTP response body:\n  {diff}')

    assert (context.statusCode == code)

    assert (context.response['access_token'] == Token)
