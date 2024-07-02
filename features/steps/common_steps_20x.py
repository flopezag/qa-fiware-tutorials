from behave import when, then, step
from os.path import join
from sys import stdout
from logging import getLogger
from requests import post, put, patch, get, delete, exceptions
from features.funtions import read_data_from_file, dict_diff_with_exclusions
from hamcrest import assert_that, is_
import json
import time

__logger__ = getLogger(__name__)


@when(u'I prepare a {method} HTTP request to "{url}"')
def prepare_http_method(context, method, url):
    __logger__.info(f'Send POST HTTP IoT request to {url}')
    context.method = method
    context.url = url
    context.headers = {'content-type': 'application/json'}


@when(u'I prepare a {method} HTTP request for "{description}" to "{url}"')
def prepare_http_method_with_description(context, method, description, url):
    __logger__.info(f'Prepare {method} HTTP IoT request for {description} to {url}')
    context.method = method.upper()
    context.url = url
    context.headers = {'content-type': 'application/json'}


@step(u'I set header {header_name} to {header_value}')
def set_header_to_value(context, header_name, header_value):
    header_name = header_name.lower()
    if not hasattr(context, 'headers'):
        context.headers = {}
    context.headers[header_name] = header_value


@step(u'I set the body request as described in {file}')
def set_body_request_as_in_file(context, file):
    file = join(context.data_home, file)
    stdout.write(f'Context data_home = {file}')

    with open(file) as f:
        context.payload = f.read().strip('\n')


@step(u'I perform the query request')
def perform_query_request(context):
    if not hasattr(context, 'payload'):
        context.payload = "{}"

    data = context.payload

    try:
        context.headers.pop("content-type")
    except KeyError:
        pass

    if context.method == "GET":
        response = get(context.url, headers=context.headers, params=json.loads(data))
    elif context.method == "DELETE":
        response = delete(context.url, headers=context.headers, params=json.loads(data))

    context.statusCode = str(response.status_code)
    context.responseHeaders = response.headers
    if context.statusCode != "204":
        context.response = response.json()
    else:
        context.response = ""


@step(u'I perform the request')
def perform_request(context):
    if not hasattr(context, 'payload'):
        context.payload = None

    try:
        if context.method == "POST":
            context.payload = context.payload.encode('utf-8')
            response = post(context.url, data=context.payload, headers=context.headers)
        elif context.method == "PUT":
            context.payload = context.payload.encode('utf-8')
            response = put(context.url, data=context.payload, headers=context.headers)
        elif context.method == "PATCH":
            context.payload = context.payload.encode('utf-8')
            response = patch(context.url, data=context.payload, headers=context.headers)
        elif context.method == "GET":
            response = get(context.url, headers=context.headers)
        else:
            raise AssertionError(f"Unknown method {context.method}")
    except exceptions.RequestException as e:
        raise AssertionError("A request exception occurred")

    context.statusCode = str(response.status_code)
    context.responseHeaders = response.headers

    try:
        context.response = response.json()
    except json.decoder.JSONDecodeError:
        context.response = response.text


@then(u'I receive a HTTP response with status "{expected_status}" and with the body as in file "{response_file}"')
def receive_http_response(context, expected_status, response_file):
    file = join(context.data_home, response_file)

    with open(file) as f:
        payload = f.read().strip('\n')

    stdout.write(' --- BODY ---')
    stdout.write(f' --- BODY --- {context.response}\n')
    assert(context.statusCode == expected_status), \
        f"\nThe status code is not the expected value, received {context.statusCode}, but expected: {expected_status}"

    assert (context.response == payload), \
        f"\nThe response context is not the expected value, received:\n{context.response}\n\n" \
        f"but it was expected:\n{payload}"


@then(u'I receive a HTTP "{code}" response code from {server} with the body "{file}" and exclusions "{excl_file}"')
def receive_post_iot_dummy_response_with_data(context, code, server, file, excl_file):
    body = json.loads(read_data_from_file(context, file))

    diff = dict_diff_with_exclusions(context, body, context.response, excl_file)

    assert_that(diff.to_dict(), is_(dict()),
                f'Response from {server} has not got the expected HTTP response body:\n  {diff.pretty()}')

    assert (context.statusCode == code), \
        f"\nThe status code is not the expected value, received {context.statusCode}, but expected: {code}"


@then(u'I receive a HTTP response with status {http_code} and empty dict')
def receive_created_from_IotAgent(context, http_code):
    assert (context.statusCode == http_code), \
        f"\nThe status code is not the expected value, received {context.statusCode}, but expected: {http_code}"
    if http_code != "204" and http_code != "409" and int(context.responseHeaders['Content-Length']) > 0:
        assert (context.response == {}), \
            f"\nThe response context is expected to be empty but it was:\n{context.response}"


@then(u'I simply receive a HTTP response with status {http_code}')
def receive_simple_status_code(context, http_code):
    assert (context.statusCode == http_code), \
        f"\nThe status code is not the expected value, received {context.statusCode}, but expected: {http_code}"


@step(u'I wait "{n}" seconds')
def wait_some_seconds_before_continuing(context, n):
    n = int(n)
    time.sleep(n)
