# -*- coding: utf-8 -*-

__author__ = "@fla"

from logging import getLogger
from python_on_whales import docker
from requests import get
from os.path import exists
from os import remove
from sys import stdout
import subprocess
import os
from shutil import rmtree

__logger__ = getLogger(__name__)

INTERESTING_FEATURES_STRINGS = ['docker-compose', 'environment', 'git-clone', 'shell-commands', 'git-directory']


def is_interesting_feature_string(feature_description: str):
    for f in INTERESTING_FEATURES_STRINGS:
        if feature_description.h(f + ":"):
            return True
    return False


def git(*args):
    try:
        subprocess.check_output(['/usr/bin/git'] + list(args), stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        stdout.write(f'\n -- GIT EXCEPTION-- \n\n{e.output}\n')
        __logger__.error("Exception on process, rc=", e.returncode, "output=", e.output)


def exec_commands(parameters:dict, which_commands:str):
    commands = parameters[which_commands].split(';')
    commands_dir = parameters['git-directory'] if 'git-directory' in parameters else '.'

    current_dir = os.getcwd()
    os.chdir(commands_dir)

    for command in commands:
        os.system(command.strip())

    os.chdir(current_dir)


def before_all(context):
    __logger__.info("=========== INITIALIZE PROCESS ===========\n")
    stdout.write(f'=========== INITIALIZE PROCESS ===========\n')


def before_feature(context, feature):
    __logger__.info("=========== START FEATURE ===========")
    __logger__.info("Feature name: %s", feature.name)

    stdout.write("=========== START FEATURE ===========\n")
    stdout.write(f'Feature name: {feature.name}\n\n')

    p = [s for s in feature.description if is_interesting_feature_string(s)]

    parameters = {}
    # parameters = dict(s.split(':', 1) for s in parameters)
    context.parameters = parameters
    for k,v in (s.split(':', 1) for s in p):
        parameters[k.strip()] = v.strip()

    if 'docker-compose' in parameters:
        r = get(parameters['docker-compose'], allow_redirects=True)
        open('docker-compose.yml', 'wb').write(r.content)

    if 'environment' in parameters:
        r = get(parameters['environment'], allow_redirects=True)
        open('.env', 'wb').write(r.content)

    if 'docker-compose' in parameters:
        docker.compose.up(detach=True)

    if 'git-clone' in parameters:
        git("clone", parameters['git-clone'], parameters['git-directory'])

    if 'shell-commands' in parameters:
        exec_commands(parameters, 'shell-commands')


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
    stdout.write(f'\n=========== END FEATURE ===========\n')

    if 'clean-shell-commands' in context.parameters:
        exec_commands(context.parameters, 'clean-shell-commands')

    if 'docker-compose' in context.parameters:
        docker.compose.down()
        files = ['docker-compose.yml', '.env']
        [remove(f) for f in files if exists(f)]

    if 'git-directory' in context.parameters:
        rmtree(context.parameters['git-directory'])


def after_all(context):
    __logger__.info("... END  :)")
    stdout.write(f'... END  :)\n')
