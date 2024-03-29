import time

from behave import given,step,then
from config.settings import CODE_HOME
from os.path import join
from logging import getLogger
import jq

__logger__ = getLogger(__name__)


@given(u'I set the tutorial 202 LD')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "202.ld.IotAgentUltralight")


@step(u"I filter the result with jq '{expr}'")
def step_impl(context, expr):
    pl = context.response
    jqc = jq.compile(expr)
    context.response = jqc.input(pl).first()


@step(u"I validate against jq '{expr}'")
def step_impl(context, expr):
    pl = context.response
    jqe = jq.compile(expr)

    print(pl)
    i = iter(jqe.input(pl))
    r = next(i, None)
    assert r == True
    assert(r == True), \
        (f"\nThe evaluation of the jq expression was False, received {pl} and expression was {expr},"
         f" expected value was 'True'")

