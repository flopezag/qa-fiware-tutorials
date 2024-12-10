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
