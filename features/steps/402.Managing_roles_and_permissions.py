from behave import given, when, step
from config import settings
from os.path import join


@given(u'I set the tutorial 402')
def step_impl_tutorial_203(context):
    context.data_home = join(join(join(settings.CODE_HOME, "features"), "data"), "402.Managing_Roles_and_Permissions")


@when('I set the "{key}" header with the value "{value}"')
def step_impl(context, key, value):
    """
    :type context: behave.runner.Context
    """
    try:
        context.header[key] = value
    except AttributeError:
        # Context object has no attribute 'header'
        context.header = {key: value}


@step("I set the permission url with an application id")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    context.url = f'http://localhost:3005/v1/applications/{settings.applicationId}/permissions'


@step("I set the permission url with the application and permission ids")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    context.url = f'http://localhost:3005/v1/applications/{settings.applicationId}/permissions/{settings.permissionId}'