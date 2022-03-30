import time

from behave import given, step
from config.settings import CODE_HOME
from os.path import join
import jq


@given(u'I set the tutorial 203 LD')
def step_impl_tutorial_203(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"),  "203.ld.IotAgentJSON")


@step(u'I filter the result with jq {expr}')
def step_impl(context, expr):
    pl = context.response
    jqc = jq.compile(expr)
    r = jqc.input(pl).first()
    context.response = r
