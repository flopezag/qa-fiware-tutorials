from behave import given, when, step, then
from config import settings
from os.path import join
from base64 import b64encode
from json.decoder import JSONDecodeError
from requests import get, RequestException
from config import settings

auth_token = ''
access_token = ''
refresh_token = ''
ClientID = ''


@given(u'I set the tutorial 404')
def step_impl_tutorial_203(context):
    context.data_home = join(join(join(settings.CODE_HOME, "features"), "data"), "404.Securing_Microservices")


@then('I receive a HTTP "{code}" status code from Keyrock with the following data for a pep proxy')
def step_impl(context, code):
    """
    :type context: behave.runner.Context
    """
    for element in context.table.rows:
        # | id | password |
        # | id | oauth_client_id |
        valid_response = dict(element.as_dict())

        # Get the list of keys to check from element
        keys = valid_response.keys()

        # Check the status code
        assert (context.statusCode == code), \
            f'The status code is not the expected value, received {context.statusCode}, expected {code}'

        # Check the key values of the response
        assert ("pep_proxy" in context.response), \
            f'The Response of the Keyrock does not contain the "pep_proxy" key'

        for key in keys:
            assert (key in context.response['pep_proxy']), \
                    f'The Response of the Keyrock does not contain the "{key}" key'

            if valid_response[key] != 'any':
                assert (context.response['pep_proxy'][key] == valid_response[key]), \
                    f"The {key} key has unexpected value, " \
                    f"received '{context.response['pep_proxy'][key]}', but expected '{valid_response[key]}'"


@step("I do not specify any payload")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    context.payload = None


@step('I set the application_id equal to "{applicationId}"')
def step_impl(context, applicationId):
    """
    :type context: behave.runner.Context
    """
    settings.applicationId = applicationId


@then('I receive a HTTP "{code}" status code from Keyrock with the new password')
def step_impl(context, code):
    """
    :type context: behave.runner.Context
    """
    # Check the status code
    assert (context.statusCode == code), \
        f'The status code is not the expected value, received {context.statusCode}, expected {code}'

    assert ('new_password' in context.response), \
        f'The Response of the Keyrock does not contain the "new_password" key'

    assert (len(context.response) == 1), \
        f'The response contains unexpected keys: {context.response.keys()}'
