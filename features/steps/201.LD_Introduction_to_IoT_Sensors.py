import time

from behave import given,step,then
from config.settings import CODE_HOME
from os.path import join
from logging import getLogger

__logger__ = getLogger(__name__)


@given(u'I set the tutorial 201 LD')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "201.ld.IotSensors")


@step(u'I set the body text to {text_data}')
def step_impl(context, text_data : str):
    context.payload = text_data.strip()


@step(u'I have a text response as {response_data}')
def step_impl(context, response_data : str):
    assert(context.response.strip() == response_data.strip())

@step(u'I do some waiting to debug')
def step_impl(context):
    time.sleep(1)
