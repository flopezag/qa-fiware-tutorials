from behave import given, when, step
from os.path import join
from config import settings

auth_token = str()
access_token = str()
refresh_token = str()
ClientID = str()
iotAgentId = str()


@given(u'I set the tutorial 407')
def step_impl_tutorial_203(context):
    context.data_home = join(join(join(settings.CODE_HOME, "features"), "data"), "407.Securing_Access_OpenID_Connect")


@step("I set the application url with an application id")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    context.url = f'http://localhost:3005/v1/applications/{settings.applicationId}'
