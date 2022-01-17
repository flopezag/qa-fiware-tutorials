# created by Amani Boughanmi on 20.05.2021
import time

from behave import given, when, then, step
from requests import get, post, exceptions
from hamcrest import assert_that, is_, has_key
from os.path import join
from json import load
from deepdiff import DeepDiff
from config.settings import CODE_HOME
from sys import stdout


@given(u'I set the tutorial')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "101.Getting_started")


@when(u'I send GET HTTP request to "{url}"')
def send_orion_get_version(context, url):
    try:
        response = get(url, verify=False)
        # override encoding by real educated guess as provided by chardet
        response.encoding = response.apparent_encoding
    except exceptions.RequestException as e:  # This is the correct syntax
        raise SystemExit(e)

    context.response = response.json()
    context.statusCode = str(response.status_code)


@step(u'I receive a HTTP "{status_code}" response code from {server} with the body "{response}"')
def http_code_is_returned(context, status_code, server, response):
    assert_that(context.statusCode, is_(status_code),
                "Response to {} notification has not got the expected HTTP response code: Message: {}"
                .format(server, context.response))

    file = join(context.data_home, response)
    with open(file) as f:
        data = load(f)

    diff = DeepDiff(data, context.response)
    stdout.write(f'{diff}\n\n')

    assert_that(diff.to_dict(), is_(dict()),
                f'(depa) Response from CB test execution does not match the tutorial expected HTTP response body:\n  {diff}')


@when(u'I send POST HTTP request to "{url}"')
def set_req_body2(context, url):
    context.url = url
    context.header = {'Content-Type': 'application/json'}


@step(u'With the body request described in file "{file}"')
def send_orion_post_entity2(context, file):
    file = join(context.data_home, file)
    with open(file) as f:
        payload = f.read()

    try:
        response = post(context.url, data=payload, headers=context.header)
    except exceptions.RequestException as e:
        raise SystemExit(e)

    context.responseHeaders = response.headers
    context.statusCode = str(response.status_code)
    stdout.write(f'{context.responseHeaders}\n\n\n\n')
    stdout.flush()
    try:
        context.response = response.json()
    except Exception as e:
        context.response = ""


@then(u'I receive a HTTP response with the following data')
def receive_post_response2(context):

    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        print(valid_response)
        valid_response['Status-Code']
        valid_response['Location']
        assert_that(context.responseHeaders['Connection'], is_(valid_response['Connection']))
        assert_that(context.responseHeaders['Location'], is_(valid_response['Location']))
        assert_that(context.statusCode, is_(valid_response['Status-Code']))

        aux = 'fiware-correlator' in valid_response
        assert_that(aux, is_(True))


@step("I receive the entities dictionary")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: And  I receive the entities dictionary')


@then('I receive a HTTP "200" code response')
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: Then I receive a HTTP "200" code response')
