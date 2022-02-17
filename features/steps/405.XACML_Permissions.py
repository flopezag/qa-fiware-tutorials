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


@when('I set the "AuthZForce" {entity} url with the "domainId"')
def step_impl(context, entity):
    """
    :type context: behave.runner.Context
    """
    if entity == 'domains':
        context.url = f'http://localhost:8080/authzforce-ce/domains/{settings.domainId}'
    elif entity == 'pap policies':
        context.url = f'http://localhost:8080/authzforce-ce/domains/{settings.domainId}/pap/policies'


@when('I set the "AuthZForce" {entity} url with the "domainId" and "policyId"')
def step_impl(context, entity):
    """
    :type context: behave.runner.Context
    """
    if entity == 'a pap policy set':
        context.url = \
            f'http://localhost:8080/authzforce-ce/domains/{settings.domainId}/pap/policies/{settings.papPoliciesId}'
    elif entity == 'to a single version of a pap policy set':
        context.url = \
            f'http://localhost:8080/authzforce-ce/domains/{settings.domainId}/pap/policies/{settings.papPoliciesId}' \
            f'/{settings.policySetVersion}'
