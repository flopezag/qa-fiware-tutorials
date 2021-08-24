from behave import given, when, then, step
from config.settings import CODE_HOME
from os.path import join
from requests import get, post, patch, exceptions
from logging import getLogger
from hamcrest import assert_that, is_, is_not
from json import loads
from features.funtions import read_data_from_file, dict_diff_with_exclusions

__logger__ = getLogger(__name__)


@given(u'I set the tutorial 304')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "304.Time_Series_Data")


@step('the payload request described in "{}"')
def step_impl(context, file):
    """
    :type context: behave.runner.Context
    :type arg0: str
    """
    context.payload = loads(read_data_from_file(context, file))


@given(
    'the fiware-service header is "{fiware_service}", the fiware-servicepath header is "{fiware_servicepath}", '
    'and the accept is "{accept}"')
def step_impl(context, fiware_service, fiware_servicepath, accept):
    context.headers = {"fiware-service": fiware_service, "fiware-servicepath": fiware_servicepath, "accept": accept}


@when('I send POST HTTP request to "{url}" with fiware-service and fiware-servicepath')
def step_impl(context, url):
    __logger__.info(f'Sending POST HTTP request to {url}')
    header = {'Content-Type': 'application/json'}

    try:
        response = post(url, data=context.payload, headers=header)
    except exceptions.RequestException as e:
        raise SystemExit(e)

    context.responseHeaders = response.headers
    context.response = response
    context.statusCode = str(response.status_code)
