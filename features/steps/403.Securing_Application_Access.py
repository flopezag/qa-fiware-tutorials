from behave import given, when, step, then
from config import settings
from os.path import join
from base64 import b64encode
from json.decoder import JSONDecodeError
from requests import get, RequestException

auth_token = ''
access_token = ''
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
    global access_token
    global refresh_token

    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        # | access_token | token_type | expires_in | refresh_token |
        # | access_token | token_type | expires_in |
        expires_in = valid_response["expires_in"]
        token_type = valid_response['token_type']

        # Check the status code
        assert (context.statusCode == code), \
            f'The status code is not the expected value, received {context.statusCode}, expected {code}'

        # Check the key values of the response
        assert ("access_token" in context.response), \
            f'The Response of the Keyrock does not contain the "access_token" key'

        assert ("token_type" in context.response), \
            f'The Response of the Keyrock does not contain the "token_type" key'

        assert ("expires_in" in context.response), \
            f'The Response of the Keyrock does not contain the "expires_in" key'

        # Get the important values for future execution
        access_token = context.response['access_token']

        if 'refresh_token' in valid_response:
            assert ("refresh_token" in context.response), \
                f'The Response of the Keyrock does not contain the "refresh_token" key'

            refresh_token = context.response['refresh_token']

        # Check that there are no other keys in the response
        keys_received = list(context.response.keys())
        keys_expected = list(valid_response.keys())

        difference = list(set(keys_received) - set(keys_expected))

        assert (len(difference) == 0), \
            f'We have received unexpected keys in the response: {difference}'

        # Check the values of the keys
        assert (context.response['expires_in'] == expires_in), \
            f"The expires_in received is not the expected value, " \
            f"received: {context.response['expires_in']}, " \
            f"but was expected {expires_in}"

        assert (context.response['token_type'] == token_type), \
            f"The token_type received is not the expected value, " \
            f"received: {context.response['token_type']}, " \
            f"but was expected {token_type}"


@when("I set the the user url with the previous access_token")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    global access_token
    context.url = f'http://localhost:3005/user?access_token={access_token}'

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
    global access_token

    context.url = f'http://localhost:3005/user?access_token={access_token}&app_id={ClientID}'


@step("I set the user url with the following data")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    global access_token
    global ClientID

    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        # | access_token | action | resource | app_id   |
        action = valid_response['action']
        resource = valid_response['resource']

        context.url = f'http://localhost:3005/user?access_token={access_token}&action={action}' \
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
        context.response = ""
