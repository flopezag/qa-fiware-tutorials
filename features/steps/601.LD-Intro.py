from behave import given, when, then, step
from config.settings import CODE_HOME
from os.path import join
from sys import stdout
from requests import post, exceptions, get
from logging import getLogger
from json import load
from hamcrest import assert_that, is_


__logger__ = getLogger(__name__)


@given(u'I set the tutorial 601')
def step_impl_tutorial_601(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "601.LD-Intro")


@when(u'I send GET HTTP request to {server} at "{url}"')
def set_req_url(context, server, url):
    context.url = url


@step(u"With header '{raw_headers}'")
def set_req_header(context, raw_headers):
    stdout.write("********** START building headers **********\n")

    headers = raw_headers.split('$')
    hdr_payload = {}
    length = len(headers)
    n = 1
    for x in range(0, length, 2):
        stdout.write(f'header_name_{n} = <{headers[x]}>\n')
        stdout.write(f'header_value_{n} = <{headers[x+1]}>\n\n')
        if headers[x] != "NA":
            hdr_payload.update({headers[x]: headers[x+1]})
            n = n+1
    hdr_payload.update({'Content-Type': 'application/x-www-form-urlencoded'})
    context.headers = hdr_payload

    stdout.write(f'hdr_payload = {hdr_payload}\n')
    stdout.write("********** END building headers **********\n\n")


@step(u'With parameters "{raw_parameters}"')
def send_orionld_get(context, raw_parameters):
    stdout.write("********** START building parameters **********\n")

    parameters = raw_parameters.split('$')
    par_payload = {}
    length = len(parameters)
    n = 1
    for x in range(0, length, 2):
        stdout.write(f'parameter_name_{n} = <{parameters[x]}>\n')
        stdout.write(f'parameter_value_{n} = <{parameters[x+1]}>\n\n')
        par_payload.update({parameters[x]: parameters[x+1]})
        n = n+1

    stdout.write(f'par_payload = {par_payload}\n')
    stdout.write("********** END building parameters **********\n\n")

    try:
        response = get(context.url, params=par_payload, headers=context.headers)
    except exceptions.RequestException as e:
        raise SystemExit(e)

    stdout.write(f'formed url = {response.url}\n\n')
    stdout.write("********** END orionld request **********\n\n")

    context.response = response.json()
    context.statusCode = str(response.status_code)


@then(u'I receive from {server} "{status_code}" response code with the body equal to "{response}"')
def http_code_is_returned(context, server, status_code, response):
    assert_that(context.statusCode, is_(status_code),
                "Response to CB ({}) notification has not got the expected HTTP response code: Message: {}"
                .format(server, context.response))

    full_file_name = join(context.data_home, response)
    file = open(full_file_name, 'r')
    expected_response_dict = load(file)
    file.close()

    from deepdiff import DeepDiff
    diff = DeepDiff(expected_response_dict, context.response)

    stdout.write(f'Expected response =\n {expected_response_dict}\n\n')
    stdout.write(f'Context Broker response =\n {context.response}\n\n')

    assert_that(diff.to_dict(), is_(dict()),
                f'Response from {server} Context Broker has not got the expected HTTP response body:\n  {diff}')


@when(u'I send POST HTTP request to {server} at "{url}"')
def set_req_body(context, server, url):
    context.url = url


@step(u'With the post header "{hdr_att}": "{hdr_value}"')
def set_req_header(context, hdr_att, hdr_value):
    if hdr_att != "NA":
        context.header = {
            'Content-Type': 'application/ld+json',
            hdr_att: hdr_value
            }
    else:
        context.header = {'Content-Type': 'application/ld+json'}


@step(u'With the body request described in an {server} file "{file}"')
def send_orion_ld_post(context, server, file):
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


@then(u'I receive a HTTP response with the following {server} data')
def receive_post_response2(context, server):

    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        print(valid_response)

        assert_that(context.statusCode, is_(valid_response['Status-Code']))

        if 'Connection' in valid_response:
            assert_that(context.responseHeaders['Connection'], is_(valid_response['Connection']))

        if valid_response['Location'] != "Any":
            assert_that(context.responseHeaders['Location'], is_(valid_response['Location']))

        #if 'fiware-correlator' in valid_response:
        #    assert_that(context.responseHeaders['fiware-correlator'], is_(valid_response['fiware-correlator']))


@step('I set a parameter with the value equal to "{param}"')
def step_impl(context, param):
    """
    :type context: behave.runner.Context
    :type param: str
    """
    # type=Building
    # check if context.params exist before adding new key: value
    data= param.replace('%22', '"').replace("%20", " ").split("=", 1)

    try:
        context.params[data[0]] = data[1]
    except AttributeError:
        # Context object has no attribute 'header'
        context.params = {data[0]: data[1]}
