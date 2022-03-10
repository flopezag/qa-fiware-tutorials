# created by Stefano on 21 July 2021 on top of that of Amani Boughanmi on 20.05.2021

from behave import given, when, then, step
from requests import get, post, put, patch, delete, exceptions
from hamcrest import assert_that, is_, has_key
from os.path import join
from json import load
from deepdiff import DeepDiff
from config.settings import CODE_HOME
from sys import stdout

# create the context for the tutorial
#
@given(u'I set the tutorial 103')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "103.CRUD-Operations")


# POST
#
@when(u'I send POST HTTP request to add an attribute to "{url}"')
def set_req_body102(context, url):
    context.url = url
    context.header = {'Content-Type': 'application/json'}

@step(u'With the attribute request described in file "{file}"')
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

@then(u'I receive a HTTP response on attribute with the following data')
def receive_post_response102(context):

    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        print(valid_response)
        valid_response['Status-Code']
        assert_that(context.statusCode, is_(valid_response['Status-Code']))

#
# PUT
#
@when(u'I send PUT HTTP request to update an attribute to "{url}"')
def set_req_body103(context, url):
    context.url = url
    context.header = {'Content-Type': 'text/plain'}

@step(u'With the update request described in file "{file}"')
def send_orion_put_value103(context, file):
    file = join(context.data_home, file)
    with open(file) as f:
        payload = f.read()

    try:
        response = put(context.url, data=payload, headers=context.header)
    except exceptions.RequestException as e:
        raise SystemExit(e)

    context.responseHeaders = response.headers
    context.statusCode = str(response.status_code)

@then(u'I receive a HTTP response on update with the following data')
def receive_put_response103(context):

    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        print(valid_response)
        valid_response['Status-Code']
        assert_that(context.statusCode, is_(valid_response['Status-Code']))

#
# PATCH
#
@when(u'I send PATCH HTTP request to update attributes to "{url}"')
def set_req_body103(context, url):
    context.url = url
    context.header = {'Content-Type': 'application/json'}

@step(u'With the patch update request described in file "{file}"')
def send_orion_patch_value103(context, file):
    file = join(context.data_home, file)
    with open(file) as f:
        payload = f.read()

    try:
        response = patch(context.url, data=payload, headers=context.header)
    except exceptions.RequestException as e:
        raise SystemExit(e)

    context.responseHeaders = response.headers
    context.statusCode = str(response.status_code)

@then(u'I receive a HTTP response on updates with the following data')
def receive_patch_response103(context):

    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        print(valid_response)
        valid_response['Status-Code']
        assert_that(context.statusCode, is_(valid_response['Status-Code']))


#
# DELETE
#
@when(u'I send DELETE HTTP request no body to "{url}"')
def set_req_body103(context, url):
    try:
        response = delete(url, verify=False)
    except exceptions.RequestException as e:
        raise SystemExit(e)

    context.responseHeaders = response.headers
    context.statusCode = str(response.status_code)

@step(u'I receive a HTTP "{status_code}" response code')
def http_code_is_returned(context, status_code):
    assert_that(context.statusCode, is_(status_code),
                "Response to CB notification has not got the expected HTTP response code: Message: {}"
                )


# GET
#
@when(u'I send GET HTTP request no body to assert to "{url}"')
def send_orion_get_version(context, url):
    try:
        response = get(url, verify=False)
        # override encoding by real educated guess as provided by chardet
        response.encoding = response.apparent_encoding
    except exceptions.RequestException as e:  # This is the correct syntax
        raise SystemExit(e)

    context.statusCode = str(response.status_code)

@step(u'I receive a DELETE HTTP "{status_code}" response code')
def http_code_is_returned(context, status_code):
    assert_that(context.statusCode, is_(status_code),
                "Response to CB notification has not got the expected HTTP response code: Message: {}"
                )
