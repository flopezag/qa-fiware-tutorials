from behave import given, step
from config.settings import CODE_HOME
from os.path import join
from os import getcwd
import time


@given(u'I set the tutorial 306 NGSI-LD - Big Data analysis with Spark')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "306.ngsild.Big_Data_Spark")