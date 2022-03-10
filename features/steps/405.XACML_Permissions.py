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
    elif entity == 'to the pdp endpoint':
        context.url = f'http://localhost:8080/authzforce-ce/domains/{settings.domainId}/pdp'
    elif entity == 'pap policies with pdp.properties':
        context.url = f'http://localhost:8080/authzforce-ce/domains/{settings.domainId}/pap/pdp.properties'


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


@when("I set the user url to obtain roles and domain with the following data")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    for row in context.table.rows:
        # | access_token | app_id |
        valid_response = dict(row.as_dict())
        app_id = valid_response['app_id']
        context.url = f'http://localhost:3005/user?access_token={settings.token}&app_id={app_id}&authzforce=true'
