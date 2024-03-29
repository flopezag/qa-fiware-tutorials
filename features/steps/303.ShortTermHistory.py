import time
import jq

from behave import given, step, when
from os.path import join
from config.settings import CODE_HOME


@given(u'I set the tutorial 303')
def step_impl_tutorial_303(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "303.Short_Term_History")


@step(u'I set simple sensor values as described in "{sensor_values}"')
def step_impl(context, sensor_values):
    context.payload = sensor_values

