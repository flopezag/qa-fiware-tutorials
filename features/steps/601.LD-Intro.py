import time
import requests

from behave import given, when, then, step
from config.settings import CODE_HOME
from os.path import join
from sys import stdout
from requests import post, exceptions, get, patch, put, delete
from logging import getLogger
from json import load, loads
from deepdiff import DeepDiff
from hamcrest import assert_that, is_, has_key
from features.funtions import read_data_from_file, dict_diff_with_exclusions
import json


__logger__ = getLogger(__name__)


@given(u'I set the tutorial 601')
def step_impl_tutorial_601(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "601.LD-Intro")


@when(u'I send GET HTTP request to orionld at "{url}"')
def set_req_url(context, url):
    context.url = url

@step(u'With header "{hdr_att}": "{hdr_value}"')
def set_req_header(context, hdr_att, hdr_value):
    if hdr_att != "NA":
        context.header = {
            hdr_att: hdr_value,
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/ld+json'
            }
    else:
        context.header = {
                    'Content-Type': 'application/x-www-form-urlencoded'
        }

@step(u'With parameters "{raw_parameters}"')
def send_orionld_get(context, raw_parameters):
    stdout.write("********** START building parameters **********\n")

    parameters = raw_parameters.split('$')
    payload = {}
    l = len(parameters)
    n = 1
    for x in range(0, l, 2):
        stdout.write(f'parameter_name_{n} = <{parameters[x]}>\n')
        stdout.write(f'parameter_value_{n} = <{parameters[x+1]}>\n\n')
        payload.update({parameters[x]: parameters[x+1]})
        n = n+1

    stdout.write(f'payload = {payload}\n')
    stdout.write("********** END building parameters **********\n\n")

    try:
        response = get(context.url, params=payload, headers=context.header)
    except exceptions.RequestException as e:
        raise SystemExit(e)

    stdout.write(f'formed url = {response.url}\n\n')
    stdout.write("********** END orionld request **********\n\n")

    context.response = response.json()
    context.statusCode = str(response.status_code)

@then(u'I receive from orionld "{status_code}" response code with the body equal to "{response}"')
def http_code_is_returned(context, status_code, response):
    assert_that(context.statusCode, is_(status_code),
                "Response to CB notification has not got the expected HTTP response code: Message: {}"
                .format(context.response))

    full_file_name = join(context.data_home, response)
    file = open(full_file_name, 'r')
    expectedResponseDict = load(file)
    file.close()

    stdout.write(f'expectedResponseDict =\n {expectedResponseDict}\n\n')
    stdout.write(f'context.response =\n {context.response}\n\n')

    assert_that(context.response, is_(expectedResponseDict),
                f'Response from CB has not got the expected response body!\n')


@when(u'I send POST HTTP request to orion-ld at "{url}"')
def set_req_body(context, url):
    context.url = url
    context.header = {'Content-Type': 'application/ld+json'}


@step(u'With the body request described in an orion-ld file "{file}"')
def send_orion_ld_post(context, file):
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


@then(u'I receive a HTTP response with the following orion-ld data')
def receive_post_response2(context):

    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        print(valid_response)
        valid_response['Status-Code']
        valid_response['Location']

        assert_that(context.statusCode, is_(valid_response['Status-Code']))
        assert_that(context.responseHeaders['Connection'], is_(valid_response['Connection']))
        if valid_response['Location'] != "Any":
            assert_that(context.responseHeaders['Location'], is_(valid_response['Location']))

        aux = 'fiware-correlator' in valid_response
        assert_that(aux, is_(True))