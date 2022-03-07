import time

from behave import given, when, then, step
from config.settings import CODE_HOME
from os.path import join
from sys import stdout
from requests import post, exceptions, get, patch, put, delete
from logging import getLogger
from deepdiff import DeepDiff
from hamcrest import assert_that, is_, has_key
from features.funtions import read_data_from_file, dict_diff_with_exclusions
import json

__logger__ = getLogger(__name__)


@given(u'I set the tutorial 202')
def step_impl_tutorial_202(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "202.IoT_Agent_Ultralight")
