from behave import given, when, then, step
from config.settings import CODE_HOME
from os.path import join
from sys import stdout
from requests import get, post, patch, exceptions
from logging import getLogger
from hamcrest import assert_that, is_, has_key
from json import dumps

__logger__ = getLogger(__name__)


@given(u'I set the tutorial 301')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "301.Persisting_Flume")


@when(u'The fiware-service header is "{fiware_service}" and the fiware-servicepath header is "{fiware_servicepath}"')
def fiware_service_headers(context, fiware_service, fiware_servicepath):
    context.headers = {"fiware-service": fiware_service, "fiware-servicepath": fiware_servicepath}


@step(u'I send GET HTTP request to "{url}" with fiware-service and fiware-servicepath')
def send_query_with_service(context, url):
    try:
        response = get(url, headers=context.headers, verify=False)
        # override encoding by real educated guess as provided by chardet
        response.encoding = response.apparent_encoding
    except exceptions.RequestException as e:  # This is the correct syntax
        raise SystemExit(e)

    context.response = response.json()
    context.statusCode = str(response.status_code)


@then(u'I receive a HTTP "{status_code}" response code with all the services information')
def response_services_information(context, status_code):
    assert_that(context.statusCode, is_(status_code),
                "Response to CB notification has not got the expected HTTP response code: Message: {}"
                .format(context.response))

    aux = list(map(lambda x: {x['entity_type']: {"resource": x['resource'], 'apikey': x['apikey']}},
                   context.response['services']))

    context.services_info = dict((key, d[key]) for d in aux for key in d)


@then('I receive a HTTP "{status_code}" response')
def step_impl(context, status_code):
    assert_that(context.statusCode, is_(status_code),
                "Response to CB notification has not got the expected HTTP response code: Message: {}"
                .format(context.response))


@step("I send PATCH HTTP request with the following data")
def step_impl(context):
    for element in context.table.rows:
        valid_response = dict(element.as_dict())

        url = join(join(join(valid_response['Url'], 'entities'), valid_response['Entity_ID']), 'attrs')

        payload = '''{"%s": {"type": "command","value": ""}}''' % valid_response['Command']

        context.headers['Content-Type'] = 'application/json'

        try:
            response = patch(url, data=payload, headers=context.headers)
            # override encoding by real educated guess as provided by chardet
            response.encoding = response.apparent_encoding
        except exceptions.RequestException as e:  # This is the correct syntax
            raise SystemExit(e)

        context.statusCode = str(response.status_code)
        context.response = response.reason
