# created by Amani Boughanmi on 20.05.2021

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
    context.data_home = join(join(join(CODE_HOME, "features"), "tutorial-101"), "data")


@when(u'I send GET HTTP request to "{url}"')
def send_orion_get_version(context, url):
    try:
        response = get(url)
    except exceptions.RequestException as e:  # This is the correct syntax
        raise SystemExit(e)

    context.response = response.json()
    context.statusCode = str(response.status_code)


@step(u'I receive a HTTP "{status_code}" response code with the body "{response}"')
def http_code_is_returned(context, status_code, response):
    assert_that(context.statusCode, is_(status_code),
                "Response to CB notification has not got the expected HTTP response code: Message: {}"
                .format(context.response))

    file = join(context.data_home, response)
    with open(file) as f:
        data = load(f)

    diff = DeepDiff(data, context.response)
    stdout.write(f'{diff}\n\n')

    assert_that(diff.to_dict(), is_(dict()),
                f'Response from CB has not got the expected HTTP response body:\n  {diff}')


# POST request2
@when(u'I send POST HTTP request to "{url}"')
def set_req_body2(context, url):
    context.url = url
    context.header = {'Content-Type': 'application/json'}


@step(u'With the body request described in file "{file}"')
def send_orion_post_entity2(context, file):
    file = join(context.data_home, file)
    with open(file) as f:
        payload = load(f)

    try:
        response = post(context.url, data=payload, headers=context.header)
    except exceptions.RequestException as e:  
        raise SystemExit(e)

    context.response = response.json()
    context.statusCode = str(response.status_code)


@then(u'I receive this dictionary')
def receive_post_response2(context):

    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        print(valid_response)
        for key in valid_response.keys():
            assert_that(context.response, has_key(key))
            assert_that(context.response[key], is_(valid_response[key]),
                        "The value of key {} received is: {}, it is not the expected one: {}"
                        .format(key, context.response[key], valid_response[key]))


@then(u'also the following keys')
def check_dict_post_request2(context):
    for key in valid_response.keys():
        assert_that(context.response, has_key(key),
                    "The key {} received is not the expected one:"
                    .format(key))


# POST request3
@then(u'I receive a HTTP {status_code} code response')
def http_post_code_returned3(context, status_code):
    assert_that(context.statusCode, is_(status_code),
                "Response to CB notification has not got the expected HTTP response code: Message: {}"
                .format(context.response))
