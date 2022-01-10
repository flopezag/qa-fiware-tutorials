from behave import given, when, then, step
from config.settings import CODE_HOME
from os.path import join
from os import environ
import subprocess
from hamcrest import assert_that, is_
from features.funtions import read_data_from_file, dict_diff_with_exclusions
from json import loads, dumps
from json.decoder import JSONDecodeError
from requests import get, post, patch, RequestException

Token = str()
global adminId

@given(u'I set the tutorial 401')
def step_impl_tutorial_203(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "401.Administrating_Users_and_Organizations")


@when("I request the information from user table")
@when("I update the information into the user table")
@step("I request the information from user table")
def step_impl(context):
    my_env = environ.copy()
    temp = subprocess.Popen(context.command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=my_env)

    if temp.returncode == 0 or temp.returncode is None:  # is 0 or None if success
        (output, stderr) = temp.communicate()

        if len(output) != 0:  # Update command return no data
            output = output.decode('utf-8').replace('\t', ' ').split('\n')

            del output[2]
            output[0] = output[0].split(" ")
            output[1] = output[1].split(" ")

            aux = dict()
            for i in range(0, len(output[0])):
                aux[output[0][i]] = output[1][i]

            context.output = aux
        else:
            context.output = ''
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


@when('I send a GET HTTP request to "{url}" with equal X-Auth-Token and X-Subject-Token')
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
    global adminId

    if 'user' in context.response:
        if context.response['user']['username'] == 'alice':
            adminId = context.response['user']['id']

    body = loads(read_data_from_file(context, file))

    diff = dict_diff_with_exclusions(context, body, context.response, excl_file)

    assert (context.statusCode == code), \
        f'Wrong Status Code, reveiced \"{context.statusCode}\", but it was expected \"{code}\"'

    assert_that(diff.to_dict(), is_(dict()),
                f'Response from Keyrock has not got the expected HTTP response body:\n  {diff}')

    assert (context.response['access_token'] == Token)


@step("With the body request containing the previous token")
@when("We defined a payload with token equal to the previous token")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    context.payload = {
        "token": Token
    }


@step("With the X-Auth-Token header with the previous obtained token")
@when("I set the X-Auth-Token header with the previous obtained token")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    try:
        context.header['X-Auth-Token'] = Token
    except AttributeError:
        # Context object has no attribute 'header'
        context.header = {'X-Auth-Token': Token}


@given("I connect to the MySQL docker instance to grant user with the following data")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    # docker exec -it <docker instance> mysql -u<user> -p<password> <database>
    #             -e "update user set admin = 1 where username='alice';"

    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        # | DockerInstance | User | Password | Database | Table | Username |
        docker_instance = valid_response['DockerInstance']
        user = valid_response['User']
        password = valid_response['Password']
        database = valid_response['Database']
        table = valid_response['Table']
        username = valid_response['Username']

        update_stmt = f"\"update {table} set admin = 1 where username='{username}';\""

        context.command = f"docker exec {docker_instance} mysql -u{user} -p{password} {database} -e {update_stmt}"


@then('I can check the table with the following data')
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    # docker exec -it <docker instance> mysql -u<user> -p<password> <database>
    #             -e 'select id, username, email, password from user;'

    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        # | DockerInstance | User | Password | Database | Table | Column | Username |
        docker_instance = valid_response['DockerInstance']
        user = valid_response['User']
        password = valid_response['Password']
        database = valid_response['Database']
        table = valid_response['Table']
        column = valid_response['Column']
        username = valid_response['Username']

        select_stmt = f"\"select {column} from {table} where username = \'{username}\';\""

        context.command = f"docker exec {docker_instance} mysql -u{user} -p{password} {database} -e {select_stmt}"


@then("I obtain the value \"{value}\" from the select")
def step_impl(context, value):
    """
    :type context: behave.runner.Context
    """
    obtained_value = context.output['admin']

    assert (value == obtained_value), \
        f"\nThe id value is not the expected, obtained {obtained_value}, but expected: {value}"


@step('With the body request with "{username}", "{email}", and "{password}" data')
def step_impl(context, username, email, password):
    """
    :type context: behave.runner.Context
    :type username: str
    :type email: str
    :type password: str
    """
    context.payload = {
        "user": {
            "username": username,
            "email": email,
            "password": password
        }
    }

    context.payload = dumps(context.payload)


@then('I receive a HTTP "{code}" response with the corresponding "{username}" and "{email}" data')
def step_impl(context, code, username, email):
    """
    :param username: the name of the user
    :param code: the status code of the response
    :param email: the email of the user
    :type context: behave.runner.Context
    """
    assert (context.statusCode == code), \
        f'The status code is not the expected value, received {context.statusCode}, expected {code}'

    assert (context.response['user']['username'] == username), \
        f"The username is not the expected, received {context.response['user']['username']}, expected {username}"

    assert (context.response['user']['email'] == email), \
        f"The email value is not the expected value, received {context.response['user']['email']}, expected {email}"

    assert (context.response['user']['enabled'] is True), \
        f"The enabled value is not the expected value, received {context.response['user']['enabled']}, expected True"

    assert (context.response['user']['admin'] is False), \
        f"The admin value is not the expected value, received {context.response['user']['admin']}, expected False"


@when('I send a GET HTTP request to "{url}"')
def step_impl(context, url):
    """
    :type context: behave.runner.Context
    """
    try:
        response = get(url, headers=context.header)
    except RequestException as e:
        raise SystemExit(e)

    context.responseHeaders = response.headers
    context.statusCode = str(response.status_code)

    try:
        context.response = response.json()
    except JSONDecodeError as e:
        context.response = ""


@step('I send a GET HTTP request to "{url}" with the admin user id from previous execution')
def step_impl(context, url):
    """
    :type context: behave.runner.Context
    """
    global adminId
    url = url + f'/{adminId}'

    try:
        response = get(url, headers=context.header)
    except RequestException as e:
        raise SystemExit(e)

    context.responseHeaders = response.headers
    context.statusCode = str(response.status_code)

    try:
        context.response = response.json()
    except JSONDecodeError as e:
        context.response = ""


@then('I receive a HTTP "{code}" status code from Keyrock wit the following data for each created user')
def step_impl(context, code):
    """
    :type context: behave.runner.Context
    """

    assert (context.statusCode == code), \
        f'The status code is not the expected value, received {context.statusCode}, expected {code}'

    number_users = len(context.response['users'])

    index = 0
    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        # | id | username | email | enabled | gravatar | date_password | description | website |
        username = valid_response['username']
        email = valid_response['email']
        enabled = valid_response['enabled']
        gravatar = valid_response['gravatar']
        description = valid_response['description']
        website = valid_response['website']

        assert ("id" in context.response['users'][index]), \
            f"The id is not in the description of the user {index}, data received: \n{context.response['users'][index]}"

        assert (context.response['users'][index]['username'] == username), \
            f"The username is not the expected, received {context.response['users'][index]['username']}, expected {username}"

        assert (context.response['users'][index]['email'] == email), \
            f"The email value is not the expected value, received {context.response['users'][index]['email']}, expected {email}"

        assert (context.response['users'][index]['enabled'] == enabled), \
            f"The enabled value is not the expected value, received {context.response['users'][index]['enabled']}, expected {enabled}"

        assert (context.response['users'][index]['gravatar'] == gravatar), \
            f"The enabled value is not the expected value, received {context.response['users'][index]['enabled']}, expected {gravatar}"

        assert ("date_password" in context.response['users'][index]), \
            f"The date_password is not in the description of the user {index}, data received: \n{context.response['users'][index]}"

        assert (context.response['users'][index]['description'] == description), \
            f"The description value is not the expected value, received {context.response['users'][index]['description']}, expected {description}"

        assert (context.response['users'][index]['website'] == website), \
            f"The website value is not the expected value, received {context.response['users'][index]['website']}, expected {website}"

        index += 1

    assert (index == number_users), \
        f'The number of received users are not the expected value, received {number_users}, expected {index}'


@step('the body request described in file "{file}"')
def step_impl(context, file):
    """
    :type context: behave.runner.Context
    """
    file = join(context.data_home, file)
    with open(file) as f:
        context.payload = f.read()


@step('I send a PATCH HTTP request to the url "{url}" with the admin user id from previous execution')
def step_impl(context, url):
    """
    :type context: behave.runner.Context
    """
    global adminId

    url = url + f'/{adminId}'
    context.header['Content-Type'] = 'application/json'

    try:
        response = patch(url, data=context.payload, headers=context.header)
    except RequestException as e:
        raise SystemExit(e)

    context.responseHeaders = response.headers
    context.statusCode = str(response.status_code)

    try:
        context.response = response.json()
    except JSONDecodeError as e:
        context.response = ""


@when('I send a POST HTTP request to "{url}"')
def step_impl(context, url):
    """
    :type context: behave.runner.Context
    """
    try:
        response = post(url, data=context.payload, headers=context.header)
    except RequestException as e:
        raise SystemExit(e)

    context.responseHeaders = response.headers
    context.statusCode = str(response.status_code)

    try:
        context.response = response.json()
    except JSONDecodeError as e:
        context.response = ""


@step('the content-type header key equal to "{value}"')
def step_impl(context, value):
    """
    :type context: behave.runner.Context
    """
    try:
        context.header['Content-Type'] = value
    except AttributeError:
        context.header = {'Content-Type': value}
