import os.path

from behave import given, when, step, then
from config.settings import CODE_HOME
import os, stat
from os.path import join
from logging import getLogger
import subprocess
from os import environ

__logger__ = getLogger(__name__)

new_file = ''
jar_file_id = ''
subscription_id = ''


@given(u'I set the tutorial 305.Spark')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "305.Big_Data_Spark")


@given(u'I prepare the script {script_name} to be run')
def step_impl(context, script_name):
    filename = join(context.data_home, script_name)
    assert(os.path.exists(filename))
    os.chmod(filename, stat.S_IRWXU | stat.S_IRWXG)
    context.script_name = filename


@step(u'I set the environ variable {var_name} to "{var_value}"')
def step_impl(context, var_name, var_value):
    environ[var_name] = var_value


@step(u'I set the environ variable {var_name} to "{var_value}" under git')
def step_impl(context, var_name, var_value):
    environ[var_name] = join(context.parameters['git-directory'], var_value)


@when(u'I run the script as in the tutorial page')
def step_impl(context):
    res = os.system(context.script_name)
    context.result = res


@given(u'I run the script in the background')
def step_impl(context):
    # run and forget about the process
    _ = subprocess.Popen(context.script_name, shell=True)
    pass


@then(u'I expect the scripts shows a result of {result}')
def step_impl(context, result):
    assert (int(result) == context.result), \
        f"\nThe result received is different to the expected value, received {context.result}, but expected: {result}"
