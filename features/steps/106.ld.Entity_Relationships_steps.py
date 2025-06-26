# -*- coding: utf-8 -*-
"""
Step definitions for the 106 LD Entity Relationships tutorial.
"""

from behave import given
from config.settings import CODE_HOME
from os.path import join
from logging import getLogger

__logger__ = getLogger(__name__)


@given(u'I set the tutorial 106.NGSI-LD')
def step_impl_tutorial_106(context):
    """
    Sets the data home directory in the context for tutorial 106.
    This allows common steps to find the JSON request/response files.
    """
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "106.ld.Entity_Relationships")
    __logger__.info(f"Set context.data_home to: {context.data_home}")
