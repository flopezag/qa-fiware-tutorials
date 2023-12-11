from behave import given
from config.settings import CODE_HOME
from os.path import join


@given(u'I set the tutorial 203')
def step_impl_tutorial_203(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "203.IoT_Agent_Json")
