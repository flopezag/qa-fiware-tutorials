# created by Amani Boughanmi on 20.05.2021

from behave import given, when, then, step
from requests import get, exceptions
from hamcrest import assert_that, is_, has_key


@given(u'I set the tutorial')
def step_impl(context):
    # Nothing to do so far, at the moment
    pass


@when(u'I send GET HTTP request to "{url}"')
def send_orion_get_version(context, url):
    try:
        response = get(url)
    except exceptions.RequestException as e:  # This is the correct syntax
        raise SystemExit(e)

    context.response = response.json()
    context.statusCode = str(response.status_code)


@step(u'I receive a HTTP "{status_code}" response code')
def http_code_is_returned(context, status_code):
    assert_that(context.statusCode, is_(status_code),
                "Response to CB notification has not got the expected HTTP response code: Message: {}"
                .format(context.response))


@then(u'I receive a dictionary with the key "{key}" and the following data')
def receive_orion_version_response1(context, key):
    assert_that(context.response, has_key(key),
                "Response to CB notification has not got the 'orion' key: Message: {}"
                .format(context.response))

    value = context.response[key]
    for element in context.table.rows:
        expected_message = dict(element.as_dict())
        print(expected_message)
        for key_version in expected_message.keys():
            assert_that(value, has_key(key_version))
            assert_that(value[key_version], is_(expected_message[key_version]),
                        "The value of key {} received is: {}, it is not the expected one: {}"
                        .format(key, value[key_version], expected_message[key_version]))


@then(u'also the following data')
def check_dict_content_request_version2(context):
    raise NotImplementedError(u'STEP: also the following data')


@then(u'there is no other information on it')
def check_dict_content_request_version2(context):
    raise NotImplementedError(u'STEP: there is no other information on it')
