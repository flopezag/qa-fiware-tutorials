# -*- coding: utf-8 -*-

__author__ = "@fla"

from logging import getLogger
from python_on_whales import docker
from requests import get
from os.path import exists
from os import remove
from sys import stdout

__logger__ = getLogger(__name__)


def before_all(context):
    __logger__.info("=========== INITIALIZE PROCESS ===========\n")
    stdout.write(f'=========== INITIALIZE PROCESS ===========\n')


def before_feature(context, feature):
    __logger__.info("=========== START FEATURE ===========")
    __logger__.info("Feature name: %s", feature.name)

    stdout.write("=========== START FEATURE ===========\n")
    stdout.write(f'Feature name: {feature.name}\n\n')

    parameters = [s for s in feature.description if 'docker-compose' in s or 'environment' in s]
    parameters = dict(s.split(':', 1) for s in parameters)

    r = get(parameters['docker-compose'], allow_redirects=True)
    open('docker-compose.yml', 'wb').write(r.content)

    r = get(parameters['environment'], allow_redirects=True)
    open('.env', 'wb').write(r.content)

    docker.compose.up(detach=True)


def before_scenario(context, scenario):
    __logger__.info("********** START SCENARIO **********")
    __logger__.info(f'Scenario name: {scenario.name}')

    stdout.write("********** START SCENARIO **********\n")
    stdout.write(f'Scenario name: {scenario.name}\n')

    if "runner.continue_after_failed_step" in scenario.effective_tags:
        scenario.continue_after_failed_step = True
    else:
        scenario.continue_after_failed_step = False


def after_scenario(context, scenario):
    __logger__.info("********** END SCENARIO **********")
    stdout.write(f'********** END SCENARIO **********\n\n')


def after_feature(context, feature):
    __logger__.info("=========== END FEATURE ===========")
    stdout.write(f'=========== END FEATURE ===========\n')

    docker.compose.down()

    files = ['docker-compose.yml', '.env']

    [remove(f) for f in files if exists(f)]


def after_all(context):
    __logger__.info("... END  :)")
    stdout.write(f'... END  :)\n')
