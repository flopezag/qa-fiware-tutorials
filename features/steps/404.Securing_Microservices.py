from behave import given, step, then
from os.path import join
from config import settings

auth_token = str()
access_token = str()
refresh_token = str()
ClientID = str()
iotAgentId = str()


@given(u'I set the tutorial 404')
def step_impl_tutorial_203(context):
    context.data_home = join(join(join(settings.CODE_HOME, "features"), "data"), "404.Securing_Microservices")


@then('I receive a HTTP "{code}" status code from Keyrock with the following data for {element}')
def step_impl(context, code, element):
    """
    :type context: behave.runner.Context
    """
    global iotAgentId

    if element == 'a pep proxy':
        element = 'pep_proxy'
    elif element == 'an iot agent':
        element = 'iot_agent'

    for row in context.table.rows:
        # | id | password |
        # | id | oauth_client_id |
        valid_response = dict(row.as_dict())

        # Get the list of keys to check from element
        keys = valid_response.keys()

        # Check the status code
        assert (context.statusCode == code), \
            f'The status code is not the expected value, received {context.statusCode}, expected {code}'

        # Check the key values of the response
        assert (element in context.response), \
            f'The Response of the Keyrock does not contain the "{element}" key, received {context.response.keys()}'

        for key in keys:
            assert (key in context.response[element]), \
                    f'The Response of the Keyrock does not contain the "{key}" key, ' \
                    f'received {context.response[element].keys()}'

            if valid_response[key] != 'any':
                assert (context.response[element][key] == valid_response[key]), \
                    f"The {key} key has unexpected value, " \
                    f"received '{context.response[element][key]}', but expected '{valid_response[key]}'"

        if element == 'iot_agent':
            iotAgentId = context.response[element]['id']


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


@step('I set the "iot_agents" url with the "application_id" and "iot_agent_id"')
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    global iotAgentId

    context.url = f'http://localhost:3005/v1/applications/{settings.applicationId}/iot_agents/{iotAgentId}'


@then('I receive a HTTP "{code}" status code from Keyrock with the list of iot agents')
def step_impl(context, code):
    """
    :type context: behave.runner.Context
    """
    # Check the status code
    assert (context.statusCode == code), \
        f'The status code is not the expected value, received {context.statusCode}, expected {code}'

    # Check the key values of the response
    assert ("iots" in context.response), \
        f'The Response of the Keyrock does not contain the "iots" key'

    aux = len(context.response)
    assert (aux == 2), \
        f'The Response of the Keyrock contain a number of IoT Agents not expected, received {aux}, expected 2'

    assert ('id' in context.response['iots']), \
        f'The Response of the Keyrock does not contain the id of the IoT Agents'

    aux = len(context.response['iots'].keys())
    assert (aux == 1), \
        f'The number of attributes on each of the IoT Agents are different to 1'


@then("fail: {message}")
def step_impl(context, message):
    """
    :type context: behave.runner.Context
    """
    raise AssertionError(message)


@then('I receive a HTTP "{code}" status code response and the following message')
def step_impl(context, code):
    """
    :type context: behave.runner.Context
    """
    for row in context.table.rows:
        # | message |
        # | id | oauth_client_id |
        valid_response = dict(row.as_dict())

        # Check the status code
        assert (context.statusCode == code), \
            f'The status code is not the expected value, received {context.statusCode}, expected {code}'

        assert (context.response == valid_response['message']), \
            f"The received message is not the expected one." \
            f"\nReceived\n{context.response}\n\nExpected\n{valid_response['message']}"
