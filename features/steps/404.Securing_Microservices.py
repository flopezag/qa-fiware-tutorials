from behave import given, when, step, then
from config import settings
from os.path import join
from base64 import b64encode
from json.decoder import JSONDecodeError
from requests import get, RequestException

auth_token = ''
access_token = ''
refresh_token = ''
ClientID = ''


@given(u'I set the tutorial 404')
def step_impl_tutorial_203(context):
    context.data_home = join(join(join(settings.CODE_HOME, "features"), "data"), "404.Securing_Microservices")
