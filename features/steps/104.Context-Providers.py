from behave import given, when, step
from config.settings import CODE_HOME
from os.path import join
from sys import stdout
from requests import post, exceptions, get
from logging import getLogger
from json import load
from hamcrest import assert_that, is_, has_key


__logger__ = getLogger(__name__)


@given(u'I set the tutorial 104')
def step_impl_tutorial_104(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "104.Context-Providers")


@when(u'104 sends a POST HTTP request to "{url}"')
def set_req_body2(context, url):
    context.url = url
    context.header = {'Content-Type': 'application/json'}


@step(u'With the 104 body request described in file "{file}"')
def send_orion_post_entity2(context, file):
    file = join(context.data_home, file)
    with open(file) as f:
        payload = f.read()

    try:
        response = post(context.url, data=payload, headers=context.header)
    except exceptions.RequestException as e:
        raise SystemExit(e)

#    stdout.write(f'response = {response}\n\n\n\n')
    context.responseHeaders = response.headers
    context.statusCode = str(response.status_code)
#    stdout.flush()
    try:
        context.response = response.json()
    except Exception as e:
        context.response = ""


@step(u'104 receives a HTTP "{status_code}" response code with the body equal to "{response}"')
def http_code_is_returned(context, status_code, response):
    assert_that(context.statusCode, is_(status_code),
                "Response to CB notification has not got the expected HTTP response code: Message: {}"
                .format(context.response))

    full_file_name = join(context.data_home, response)
    file = open(full_file_name, 'r')
    expectedResponseDict = load(file)
    file.close()

    stdout.write(f'context.response =\n {context.response}\n')
    stdout.write(f'expectedResponseDict =\n {expectedResponseDict}\n\n')

#    for i in responseDict:
#        stdout.write(f'i = {i}\n')
#        for ii in data[i]:
#            stdout.write(f'ii = {ii}\n')

#    for iii in context.response:
#        stdout.write(f'iii = {iii}\n')
#
    assert_that(context.response, is_(expectedResponseDict),
                f'Response from CB has not got the expected response body!\n')


@when(u'104 sends a GET HTTP request to "{url}"')
def set_req_body2(context, url):
    try:
        response = get(url, verify=False)
        # override encoding by real educated guess as provided by chardet
        response.encoding = response.apparent_encoding
    except exceptions.RequestException as e:  # This is the correct syntax
        raise SystemExit(e)

    context.response = response.json()
    context.statusCode = str(response.status_code)


@step(u'104 receives a HTTP "{status_code}" response code with the body of type "{expectedType}"')
def http_code_is_returned(context, status_code, expectedType):
    assert_that(context.statusCode, is_(status_code),
                "Response to CB notification has not got the expected HTTP response code: Message: {}"
                .format(context.response))

    stdout.write(f'expected type = {expectedType}\n')
    stdout.write(f'context.response =\n {context.response} of type = {type(context.response)}\n')
    if expectedType == "int":
        try:
            i = int(context.response)
        except:
            stdout.write(f'Response type from CB {type(context.response)} is NOT of the expected response type: {expectedType}\n')

    if expectedType == "float":
        try:
            i = float(context.response)
        except:
            stdout.write(f'Response type from CB {type(context.response)} is NOT of the expected response type: {expectedType}\n')

    if expectedType == "str":
        try:
            i = str(context.response)
        except:
            stdout.write(f'Response type from CB {type(context.response)} is NOT of the expected response type: {expectedType}\n')
