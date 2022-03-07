from behave import given, when, step
from os.path import join
from config import settings

auth_token = str()
access_token = str()
refresh_token = str()
ClientID = str()
iotAgentId = str()


@given(u'I set the tutorial 603')
def step_impl_tutorial_203(context):
    context.data_home = join(join(join(settings.CODE_HOME, "features"), "data"), "603.Traversing_Linked_Data")


@step('the params equal to "{params}"')
def step_impl(context, params):
    """
    :type context: behave.runner.Context
    """

    params = params.split('=')

    if hasattr(context, 'params') is False:
        context.params = dict()

    context.params[params[0]] = params[1]


@step('I encode this body in "{codec}"')
def step_impl(context, codec):
    """
    :type context: behave.runner.Context
    """
    if hasattr(context, 'payload'):
        context.payload = context.payload.encode(codec)
