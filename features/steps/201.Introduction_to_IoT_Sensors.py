from behave import given, when, then, step
from config.settings import CODE_HOME
from os.path import join
from sys import stdout
from requests import post, exceptions
from logging import getLogger

__logger__ = getLogger(__name__)


@given(u'I set the tutorial 201')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "201.Introduction_to_IoT_Sensors")
