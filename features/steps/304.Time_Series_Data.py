from behave import given, when, step
from config.settings import CODE_HOME
from os.path import join
from requests import get, post, exceptions
from logging import getLogger
from json import loads, dumps
from features.funtions import read_data_from_file
from time import sleep
from sys import stdout

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

    # I need to wait until the Health Status of CrateDB is Green in order to start querying it
    # Sometimes, it is needed some time before Tables and Indexes are ok in CrateDB
    stmt = '{"stmt": "select health from sys.health order by severity desc limit 1;"}'
    response = ''
    while response != 'GREEN':
        try:
            response = get(url, data=stmt, headers=header)
            status = response.json()['rows'][0]

            stdout.write(f'\nCrateDB Health Status: {status}')

            response = status[0]
        except exceptions.ConnectionError:
            # Could be possible that even CrateDB server is not still alive
            # Therefore we need to wait a little and try it again...
            sleep(2)
            continue
        except IndexError:
            # The transition from RED status to GREEN status crosses through
            # an empty status in the response of 'rows', then we wait 1 second
            # and try again
            sleep(2)
            continue

    try:
        response = post(url, data=dumps(context.payload), headers=header)
    except exceptions.RequestException as e:
        raise SystemExit(e)

    context.responseHeaders = response.headers
    context.response = response.json()
    context.statusCode = str(response.status_code)
