from behave import given, step
from config.settings import CODE_HOME
from os.path import join
import time


@given(u'I set the tutorial 306 NGSI-LD - Big Data analysis with Spark')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "306.ngsild.Big_Data_Spark")


@step(u'I wait for debug')
def wait_some_seconds_before_continuing(context):
    time.sleep(1)
