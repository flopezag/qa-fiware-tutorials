#!/usr/bin/env python
# -*- encoding: utf-8 -*-
##
# Copyright 2021 FIWARE Foundation, e.V.
# All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
##

from configparser import ConfigParser
import logging
from os import environ
from os.path import dirname, join, abspath
from json import load

__author__ = 'Fernando López'

__version__ = '1.0.0'

name = 'qa-fiware-tutorials'

permissionId = str()
applicationId = str()
roleId = str()
organizationId = str()
token = str()
domainId = str()
papPoliciesId = str()
policySetVersion = str()

CODE_HOME = dirname(dirname(abspath(__file__)))
LOG_HOME = join(CODE_HOME, 'logs')
CONFIG_HOME = join(CODE_HOME, 'config')
CONFIG_FILE = join(CONFIG_HOME, 'config.json')

config = None
with open(CONFIG_FILE) as config_file:
    config = load(config_file)
