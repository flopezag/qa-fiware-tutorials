from behave import given, step
from config.settings import CODE_HOME
from os.path import join
from re import search


@given(u'I set the tutorial 304 LD - Timeseries data')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "304.ld.Time_Series_Data")


@step(u'Header contains key "{key}" with value "{value}"')
def check_header_keys(context, key, value):
    assert key in context.responseHeaders, \
        f"Header does not contain {key} key"

    if key == 'Location':
        # Need to check the url pattern where tha last part is a random generated url
        idx1 = value.rfind(':')
        substring1 = value[:idx1]

        idx2 = context.responseHeaders[key].rfind(':')
        substring2 = context.responseHeaders[key][:idx2]

        assert substring1 == substring2, \
            f'The Location key in the Header is not the expected value, ' \
            f'\nexpected:\n{substring1} + random id \n\nreceived:\n{context.responseHeaders[key]}'
    else:
        assert context.responseHeaders[key] == value, \
            f'The {key} key in the Header is not the expected value, ' \
            f'\nexpected:\n{value} + random id \n\nreceived:\n{context.responseHeaders[key]}'
