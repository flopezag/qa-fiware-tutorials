# created by Amani Boughanmi on 20.05.2021
from behave import given, when, then, step
from requests import get, post, exceptions
from hamcrest import assert_that, is_
from os.path import join
from json import load, loads
from deepdiff import DeepDiff
from config.settings import CODE_HOME
from sys import stdout
from xmldiff import main, formatting
from xml.dom.minidom import parseString


@given(u'I set the tutorial 101')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "101.Getting_started")


@when(u'I send GET HTTP request to "{url}"')
def send_orion_get_version(context, url):
    try:
        response = get(url, verify=False)
        # override encoding by real educated guess as provided by chardet
        response.encoding = response.apparent_encoding
    except exceptions.RequestException as e:  # This is the correct syntax
        raise SystemExit(e)

    context.response = response.json()
    context.statusCode = str(response.status_code)


@step(u'I receive a HTTP "{status_code}" response code from {server} with the body equal to "{response}"')
def http_code_is_returned(context, status_code, server, response):
    assert_that(context.statusCode, is_(status_code),
                "Response to {} notification has not got the expected HTTP response code: Message: {}"
                .format(server, context.response))

    file = join(context.data_home, response)
    with open(file) as f:
        data = load(f)

    if server == 'AuthZForce':
        # We need to parse and check the XML response
        diff = DeepDiff(data, context.xml)

        stdout.write(f'Expected response =\n {data}\n\n')
        stdout.write(f'{server} response =\n {context.xml}\n\n')

        if len(diff) != 0:
            assert_that(diff.to_dict(), is_(dict()),
                        f'Response from {server} has not got the expected HTTP response body:\n  {diff}')

        # file = join(context.data_home, response)
        # with open(file) as f:
        #     file_content = f.read()
        #
        # formatter = formatting.DiffFormatter()
        #
        # want = file_content.replace('\n', '').encode('utf-8')
        # got = context.response.replace('\n', '').encode('utf-8')
        # result = main.diff_texts(want, got, formatter=formatter)
        #
        # # We have to ignore the uptime, href, and title values of the results
        # excluded_tags = ['lastModifiedTime', 'uptime', 'href', 'title']
        # data1 = result.split("\n")
        # data1 = [x for x in data1 if all(y not in x for y in excluded_tags)]
        # result = '\n'.join(data1)
        #
        # # Obtain the pretty print xml of the response
        # dom = parseString(context.response)  # or xml.dom.minidom.parseString(xml_string)
        # pretty_xml_as_string = dom.toprettyxml()
        #
        # assert (result == ''), \
        #     f'The XML obtained is not the expected value, ' \
        #     f'\nexpected:\n{file_content}\n\nreceived:\n{pretty_xml_as_string}\n\ndifferences:\n{result}\n'
    else:
        # file = join(context.data_home, response)
        # with open(file) as f:
        #     data = load(f)
        #
        diff = DeepDiff(data,
                        context.response,
                        exclude_paths=["root['orion']['uptime']", "root['version']", "root['index']"])

        stdout.write(f'Expected response =\n {data}\n\n')
        stdout.write(f'Context Broker response =\n {context.response}\n\n')

        if len(diff) != 0:
            assert_that(diff.to_dict(), is_(dict()),
                        f'Response from {server} Context Broker has not got the expected HTTP response body:\n  {diff}')


@when(u'I send POST HTTP request to "{url}"')
def set_req_body2(context, url):
    context.url = url
    context.header = {'Content-Type': 'application/json'}


@step(u'With the body request described in file "{file}"')
def send_orion_post_entity2(context, file):
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
          

@then(u'I receive a HTTP response with the following data')
def receive_post_response2(context):

    for element in context.table.rows:
        valid_response = dict(element.as_dict())

        assert_that(context.statusCode, is_(valid_response['Status-Code']))

        # Currently, there is no Connection Header key in the 101 response
        if 'Connection' in dict(context.responseHeaders).keys():
            assert_that(context.responseHeaders['Connection'], is_(valid_response['Connection']))
        
        if valid_response['Location'] != "Any":
            assert_that(context.responseHeaders['Location'], is_(valid_response['Location']))

        aux = 'fiware-correlator' in valid_response
        assert_that(aux, is_(True))


@step("I receive the entities dictionary")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: And  I receive the entities dictionary')

    
@then('I receive a HTTP "200" code response')
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: Then I receive a HTTP "200" code response')
