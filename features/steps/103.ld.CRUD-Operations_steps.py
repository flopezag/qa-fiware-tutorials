# created by Stefano on 21 July 2021 on top of that of Amani Boughanmi on 20.05.2021

from behave import given, when, then, step
from requests import get, post, put, patch, delete, exceptions
from hamcrest import assert_that, is_
from os.path import join
from config.settings import CODE_HOME

# create the context for the tutorial
#
@given(u'I set the tutorial 103.NGSI-LD')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "103.ld.CRUD-Operations")
