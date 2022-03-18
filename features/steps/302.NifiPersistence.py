import time
import jq

from behave import given, step, when
from os.path import join
from config.settings import CODE_HOME


@given(u'I set the tutorial 302')
def step_impl_tutorial_205(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "302.Persistence_with_Nifi")


@step(u'I set simple sensor values as described in "{sensor_values}"')
def step_impl(context, sensor_values):
    context.payload = sensor_values


@step(u'I validate against JQ {expr}')
def step_impl(context, expr):
    pl = context.response
    jqe = jq.compile(expr)

    i = iter(jqe.input(pl))
    r = next(i, None)
    assert r == True


@step(u'I need to wait until things are manualy done in draco')
def step_impl(context):
    time.sleep(1)