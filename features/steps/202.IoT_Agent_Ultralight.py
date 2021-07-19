from behave import given, when, then, step
from config.settings import CODE_HOME
from os.path import join
from sys import stdout
from requests import post, exceptions, get
from logging import getLogger
from deepdiff import DeepDiff
from hamcrest import assert_that, is_, has_key
from features.funtions import read_data_from_file, dict_diff_with_exclusions
import json

__logger__ = getLogger(__name__)


@given(u'I set the tutorial 202')
def step_impl_tutorial_202(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "202.IoT_Agent_Ultralight")


@step(u'With body request and headers described in file "{file}" and headers fiware-service "{fw_service}" and '
      u'fiware-servicepath "{fw_servicepath}"')
def set_context_headers(context, file, fw_service, fw_servicepath):
    context.header = {'Content-Type': 'application/json',
                      'fiware-service': fw_service,
                      'fiware-servicepath': fw_servicepath}

    payload = read_data_from_file(context, file)

    try:
        response = post(context.url, data=payload, headers=context.header)
    except exceptions.RequestException as e:  # This is the correct syntax
        raise SystemExit(e)

    context.response = response.json()
    context.statusCode = str(response.status_code)


@then(u'I receive an HTTP response with the code "{http_code}" and empty dict')
def receive_created_from_IotAgent(context, http_code):
    assert (context.statusCode == "201")
    assert (context.response == {})


@when(u'I send POST HTTP IoT dummy request to "{url}"')
def preset_post_iot_dummy_request(context, url):
    context.url = url
    context.header = {'Content-Type': 'text/plain'}


@step(u'With dummy body request in file "{file}"')
def send_post_iot_dummy_request(context, file):
    payload = read_data_from_file(context, file).strip("\n")

    try:
        response = post(context.url, data=payload, headers=context.header)
    except exceptions.RequestException as e:
        raise SystemExit(e)

    context.responseHeaders = response.headers
    context.statusCode = str(response.status_code)


@then(u'I receive a HTTP "{code}" IoT response from dummy device')
def receive_post_iot_dummy_response(context, code):
    assert (context.statusCode == code)


@when(u'I send IoT GET HTTP request with data to "{url}" With headers fiware-service "{fw_service}" and '
      u'fiware-servicepath "{fw_servicepath}" and data is "{file}"')
def get_with_context_headers(context, url, fw_service, fw_servicepath, file):
    context.header = { 'fiware-service': fw_service,
                      'fiware-servicepath': fw_servicepath}
    data = read_data_from_file(context, file).strip('\n')
    try:
        response = get(url, headers=context.header, params=data)
    except exceptions.RequestException as e:  # This is the correct syntax
        raise SystemExit(e)

    context.response = response.json()
    context.statusCode = str(response.status_code)


@then(u'I receive a HTTP "{code}" response code with the body "{file}" and exclusions "{excl_file}"')
def receive_post_iot_dummy_response_with_data(context, code, file, excl_file):
    body = json.loads(read_data_from_file(context, file))


    diff = dict_diff_with_exclusions(context, body, context.response, excl_file)
    stdout.write(f'{diff}\n\n')
    assert_that(diff.to_dict(), is_(dict()),
                f'Response from CB has not got the expected HTTP response body:\n  {diff}')
    assert (context.statusCode == code)
