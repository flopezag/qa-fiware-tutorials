from behave import given, when, then, step
from config.settings import CODE_HOME
from os.path import join
import subprocess

@given(u'I set the tutorial 204')
def step_impl_tutorial_203(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "204.IoT_Agent_Mqtt")


@when(u'I run script "{script_file}"')
def run_script_file(context, script_file):
    script_file = join(context.data_home, script_file)
    exit_code = subprocess.call(script_file)
    context.exit_code = exit_code


@then('I expect exit code to be "{exit_code}"')
def dont_expect_anything_to_happen(context, exit_code):
    assert context.exit_code == int(exit_code)