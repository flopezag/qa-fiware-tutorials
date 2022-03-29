import time

from behave import given, step
from config.settings import CODE_HOME
from os.path import join


@given(u'I set the tutorial 203 LD')
def step_impl_tutorial_203(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"),  "203.ld.IotAgentJSON")


@step(u'I wait for some debug')
def step_impl(context):
    time.sleep(1)

