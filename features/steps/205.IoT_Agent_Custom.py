from behave import given, step, when
from os.path import join
from config.settings import CODE_HOME


@given(u'I set the tutorial 205')
def step_impl_tutorial_205(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "205.IoT_Agent_Custom")


@when(u'I prepare a "{method}" HTTP request to "{url}"')
def prepare_http_request(context, method, url):
    context.method = method
    context.url = url
    context.payload = None
    context.headers = {}


@step(u'I set the header "{headerName}" to "{headerValue}"')
def set_http_header_to_value(context, headerName, headerValue):
    if context.headers is None:
        context.headers = {}
    context.headers[headerName] = headerValue


@step(u'I set payload as in file "{filename}"')
def set_payload_from_file(context, filename):
    file = join(context.data_home, filename)
    with open(file) as f:
        context.payload = f.read().strip('\n').replace("\n", " ")



