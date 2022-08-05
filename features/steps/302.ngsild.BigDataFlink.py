from behave import given, step
from config.settings import CODE_HOME
from os.path import join
from time import sleep

@given(u'I set the tutorial 302 LD - Big Data Flink')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "302.ld.BigData_Flink")