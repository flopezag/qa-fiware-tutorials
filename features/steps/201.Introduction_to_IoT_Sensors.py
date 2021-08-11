from behave import given, when, then, step
from config.settings import CODE_HOME
from os.path import join
from sys import stdout
from requests import post, exceptions
from logging import getLogger

__logger__ = getLogger(__name__)


@given(u'I set the tutorial 201')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "201.Introduction_to_IoT_Sensors")


@when(u'I send POST HTTP IoT request for "{description}" to "{url}"/"{location}"')
def send_post_iot_ul20(context, description, url, location):
    __logger__.info(f'Send POST HTTP IoT request for {description} to {url}/{location}')
    context.url = url + "/" + location
    context.header = {'Content-Type': 'application/x-www-form-urlencoded'}


@step(u'With the body IoT request described in "{file}"')
def send_iot_ul20_post(context, file):
    file = join(context.data_home, file)
    stdout.write(f'Context data_home = {file}')

    with open(file) as f:
        payload = f.read().strip('\n')

    try:
        response = post(context.url, data=payload, headers=context.header)
    except exceptions.RequestException as e:
        raise SystemExit(e)

    context.statusCode = str(response.status_code)
    context.body = response.text


@then(u'I receive a HTTP "{expected_status}" IoT response code with the body "{response_file}"')
def recieve_iot_ul20_post(context, expected_status, response_file):
    file = join(context.data_home, response_file)

    with open(file) as f:
        payload = f.read().strip('\n')

    stdout.write(' --- BODY ---')
    stdout.write(f' --- BODY --- {context.body}\n')
    assert(context.statusCode == expected_status)
    assert (context.body == payload)
