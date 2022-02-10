from behave import given, when, step, then
from config import settings
from os.path import join
from base64 import b64encode
from json.decoder import JSONDecodeError
from requests import get, RequestException

auth_token = ''
refresh_token = ''
ClientID = ''


@given(u'I set the tutorial 403')
def step_impl_tutorial_203(context):
    context.data_home = join(join(join(settings.CODE_HOME, "features"), "data"), "403.Securing_Application_Access")


@given('I set "{parameter}" to "{value}"')
def step_impl(context, parameter, value):
    """
    :type context: behave.runner.Context
    """
    global ClientID
    if parameter == 'ClientID':
        context.ClientID = value
        ClientID = value
    elif parameter == 'ClientSecret':
        context.ClientSecret = value

@when("I calculate the base64 of this ClientId and ClientSecret")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    global auth_token

    message = context.ClientID + ':' + context.ClientSecret
    message = message.encode('ascii')
    b64_bytes = b64encode(message)
    context.b64 = b64_bytes.decode('ascii')
    auth_token = context.b64

@then('I obtain the value "{value}"')
def step_impl(context, value):
    """
    :type context: behave.runner.Context
    """
    assert (context.b64 == value), \
        f"The encoded value is not the expected one, calculates\n {context.b64}\n\n but expected\n {value}"


@when("I set the Authorization header token with the calculated value")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    try:
        context.header['Authorization'] = f'Basic {auth_token}'
    except AttributeError:
        # Context object has no attribute 'header'
        context.header = {'Authorization': f'Basic {auth_token}'}


@step('I set the url to "{url}"')
def step_impl(context, url):
    """
    :type context: behave.runner.Context
    """
    context.url = url

@step('the data equal to "{data}"')
def step_impl(context, data):
    """
    :type context: behave.runner.Context
    """
    context.payload = data


@then('I receive a HTTP "{code}" status code from Keyrock with the following data')
def step_impl(context, code):
    """
    :type context: behave.runner.Context
    """
    global refresh_token

    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        # | access_token | token_type | expires_in | refresh_token |
        # | access_token | token_type | expires_in |
        # | access_token | token_type | scope |

        # The response MUST be a dict or there is an error message
        assert(isinstance(context.response, dict)), \
            f'It was received a response that it is not a dictionary.\nReceived:\n{context.response}'

        # Check that there are no other keys in the response
        keys_received = list(context.response.keys())
        keys_expected = list(valid_response.keys())

        difference = list(set(keys_received) - set(keys_expected))

        assert (len(difference) == 0), \
            f'We have received unexpected keys in the response: {difference}'

        difference = list(set(keys_expected) - set(keys_received))

        assert (len(difference) == 0), \
            f'We have some expected keys that were not received: {difference}'

        # Check the status code
        assert (context.statusCode == code), \
            f'The status code is not the expected value, received {context.statusCode}, expected {code}'

        # Get the important values for future execution
        assert ('access_token' in context.response), \
            f'The response MUST include the key "access_token'

        settings.token = context.response['access_token']

        # Remove the key for the rest of chekings
        keys_expected.remove('access_token')

        # For each of the rest expected keys check the received values
        for key in keys_expected:
            received = context.response[key]
            expected = valid_response[key]

            if key == 'refresh_token':
                refresh_token = context.response[key]

            assert (received == expected), \
                f"The {key} received is not the expected value, " \
                f"received: {received}, " \
                f"but was expected {expected}"


@when("I set the the user url with the previous access_token")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    context.url = f'http://localhost:3005/user?access_token={settings.token}'

@step("the data equal to refresh_token value obtained previously")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    context.payload = f'refresh_token={refresh_token}&grant_type=refresh_token'


@when("I set the the user url with the previous access_token and application_id")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    # Application ID is equal to ClientId
    global ClientID

    context.url = f'http://localhost:3005/user?access_token={settings.token}&app_id={ClientID}'


@step("I set the user url with the following data")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    global ClientID

    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        # | access_token | action | resource | app_id   |
        action = valid_response['action']
        resource = valid_response['resource']

        context.url = f'http://localhost:3005/user?access_token={settings.token}&action={action}' \
                      f'&resource={resource}&app_id={ClientID}'


@step("I send a GET HTTP request to that url with no headers")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    """
    :type context: behave.runner.Context
    """
    try:
        response = get(context.url)
    except RequestException as e:
        raise SystemExit(e)

    context.responseHeaders = response.headers
    context.statusCode = str(response.status_code)

    try:
        context.response = response.json()
    except JSONDecodeError:
        context.response = response.text
