from behave import given, when, step
from config.settings import CODE_HOME
from os.path import join
from requests import get, post, exceptions
from logging import getLogger
from json import loads, dumps
from features.funtions import read_data_from_file, replace_dates_query, http, check_cratedb_health_status
from time import sleep
from datetime import datetime, timedelta, timezone

__logger__ = getLogger(__name__)


@given(u'I set the tutorial 304')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "304.Time_Series_Data")


@step('the payload request described in "{file}"')
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


@when('I send a POST HTTP request to "{url}" with content type "{content_type}"')
def step_impl_post(context, url, content_type):
    __logger__.info(f'Sending POST HTTP request to {url}')
    header = {'Content-Type': 'application/json'}

    check_cratedb_health_status(url=url, headers=header)

    try:
        response = post(url, data=dumps(context.payload), headers=header)
    except exceptions.RequestException as e:
        raise SystemExit(e)

    context.responseHeaders = response.headers
    context.response = response.json()
    context.statusCode = str(response.status_code)


@step("the date and time are around today")
def step_impl(context):
    context.payload['stmt'] = replace_dates_query(context.payload['stmt'])


@step("using fiware-service and fiware-servicepath header keys")
def step_impl(context):
    sleep(8)

    try:
        response = http.get(context.url, headers=context.headers, verify=False)
    except exceptions.RequestException as e:  # This is the correct syntax
        raise SystemExit(e)

    context.response = response.json()
    context.statusCode = str(response.status_code)


@when(
    'I send GET HTTP request to "{url}" with from and to date {days} days from now')
def step_impl(context, url, days):
    # fromDate=2018-06-27T09:00:00&toDate=2018-06-30T23:59:59
    current_date_time = datetime.now(timezone.utc)

    # We need to select one day after and one day before today
    from_date = (current_date_time - timedelta(days=int(days))).strftime("%Y-%m-%dT%H:%M:%S")
    to_date = (current_date_time + timedelta(days=int(days))).strftime("%Y-%m-%dT%H:%M:%S")

    context.url = url + '&fromDate=' + from_date + '&toDate=' + to_date
