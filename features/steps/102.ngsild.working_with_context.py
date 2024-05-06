from behave import given, step
from config.settings import CODE_HOME
from os.path import join
from logging import getLogger
import json

__logger__ = getLogger(__name__)


@given(u'I set the tutorial 102 NGSI-LD')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "102.ld.working_with_context")


@step(u'I have the header "{header}" with value "{value}"')
def compare_header_value(context, header, value):
    h = context.responseHeaders
    if header in h:
        assert h[header] == value, \
            f'The value of "{header}" does not match the value of "{value}", received "{h[header]}"'
