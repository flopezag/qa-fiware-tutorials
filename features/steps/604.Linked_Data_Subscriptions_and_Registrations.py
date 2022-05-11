from behave import given
from os.path import join
from config import settings

auth_token = str()
access_token = str()
refresh_token = str()
ClientID = str()
iotAgentId = str()


@given(u'I set the tutorial 604')
def step_impl_tutorial_203(context):
    context.data_home = join(join(
        join(settings.CODE_HOME, "features"), "data"), "604.Linked_Data_Subscriptions_and_Registrations")

