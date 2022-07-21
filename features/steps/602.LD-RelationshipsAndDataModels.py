from behave import given
from config.settings import CODE_HOME
from os.path import join
from logging import getLogger


__logger__ = getLogger(__name__)


@given(u'I set the tutorial 602')
def step_impl_tutorial_602(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "602.LD-RelationshipsAndDataModels")
