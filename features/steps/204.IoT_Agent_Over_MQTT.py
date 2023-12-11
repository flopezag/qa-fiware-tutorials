from behave import given, when, then
from config.settings import CODE_HOME
from os.path import join
import subprocess


@given(u'I set the tutorial 204')
def step_impl_tutorial_204(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "204.IoT_Agent_Mqtt")


@when(u'I run script "{script_file}"')
def run_script_file(context, script_file):
    script_file = join(context.data_home, script_file)
    exit_code = subprocess.call(script_file)
    context.exit_code = exit_code


@then('I expect exit code to be "{exit_code}"')
def expect_process_exit_code(context, exit_code):
    assert (context.exit_code == int(exit_code)), \
        f"\nThe exit code is not the expected value, received {context.exit_code}, but expected: {exit_code}"
