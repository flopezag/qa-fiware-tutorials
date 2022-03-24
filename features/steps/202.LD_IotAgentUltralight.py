import time

from behave import given,step,then
from config.settings import CODE_HOME
from os.path import join
from logging import getLogger

__logger__ = getLogger(__name__)


@given(u'I set the tutorial 202 LD')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "202.ld.IotAgentUltralight")
