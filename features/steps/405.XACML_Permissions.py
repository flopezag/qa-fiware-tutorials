from behave import given, when
from os.path import join
from config import settings

auth_token = str()
access_token = str()
refresh_token = str()
ClientID = str()
iotAgentId = str()


@given(u'I set the tutorial 405')
def step_impl_tutorial_203(context):
    context.data_home = join(join(join(settings.CODE_HOME, "features"), "data"), "405.XACML_Permissions")


@when('I set the "AuthZForce" domains url with the "domainId"')
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    context.url = f'http://localhost:8080/authzforce-ce/domains/{settings.domainId}'
