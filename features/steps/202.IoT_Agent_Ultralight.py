from behave import given
from config.settings import CODE_HOME
from os.path import join
from logging import getLogger

__logger__ = getLogger(__name__)


@given(u'I set the tutorial 202')
def step_impl_tutorial_202(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "202.IoT_Agent_Ultralight")
