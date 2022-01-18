from behave import given, when, then, step
from config.settings import CODE_HOME
from os.path import join
from os import environ
import subprocess
from hamcrest import assert_that, is_
from features.funtions import read_data_from_file, dict_diff_with_exclusions
from json import loads, dumps
from json.decoder import JSONDecodeError
from requests import get, post, patch, delete, put, RequestException

global Token
global adminId
global organizationId
global userId


@given(u'I set the tutorial 402')
def step_impl_tutorial_203(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "402.Managing_Roles_and_Permissions")


@when('I set the "{key}" header with the value "{value}"')
def step_impl(context, key, value):
    """
    :type context: behave.runner.Context
    """
    global Token

    try:
        context.header[key] = value
    except AttributeError:
        # Context object has no attribute 'header'
        context.header = {key: value}
