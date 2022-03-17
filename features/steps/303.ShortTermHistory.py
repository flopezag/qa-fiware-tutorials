import time
import jq

from behave import given, step, when
from os.path import join
from config.settings import CODE_HOME


@given(u'I set the tutorial 303')
def step_impl_tutorial_205(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "303.Short_Term_History")


@step(u'I set simple sensor values as described in "{sensor_values}"')
def step_impl(context, sensor_values):
    context.payload = sensor_values


@step(u'I substitute in payload "{what}" for "{dst}"')
def step_impl(context, what, dst):
    f = context.payload
    f = f.replace(what, dst)
    context.payload = f
    pass

@step(u'I validate against JQ {expr}')
def step_impl(context, expr):
    expr = expr.replace('#124;', '|')
    pl = context.response
    jqe = jq.compile(expr)

    i = iter(jqe.input(pl))
    r = next(i, None)
    assert r == True