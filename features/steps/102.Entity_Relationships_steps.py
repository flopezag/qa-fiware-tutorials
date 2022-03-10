# created by Stefano on 19 July 2021 on top of that of Amani Boughanmi on 20.05.2021

from behave import given, when, then, step
from requests import get, post, exceptions
from hamcrest import assert_that, is_, has_key
from os.path import join
from json import load
from deepdiff import DeepDiff
from config.settings import CODE_HOME
from sys import stdout


@given(u'I set the tutorial 102')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "102.Entity_Relationships")


@when(u'I send POST HTTP batch request to "{url}"')
def set_req_body102(context, url):
    context.url = url
    context.header = {'Content-Type': 'application/json'}


@step(u'With the body batch request described in file "{file}"')
def send_orion_post_entity102(context, file):
    file = join(context.data_home, file)
    with open(file) as f:
        payload = f.read()

    try:
        response = post(context.url, data=payload, headers=context.header)
    except exceptions.RequestException as e:
        raise SystemExit(e)

    context.responseHeaders = response.headers
    context.statusCode = str(response.status_code)


@then(u'I receive a HTTP batch response with the following data')
def receive_post_response102(context):

    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        print(valid_response)
        valid_response['Status-Code']
        assert_that(context.statusCode, is_(valid_response['Status-Code']))
