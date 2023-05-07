# -*- coding: utf-8 -*-

__author__ = "@fla"

from logging import getLogger
from python_on_whales import docker
from requests import get
from os.path import exists
from sys import stdout
import subprocess
import os
from shutil import rmtree

from tempfile import mkstemp
from shutil import move
from os import remove
from config.settings import config
from config.settings import CODE_HOME
from os.path import join
import stat

__logger__ = getLogger(__name__)

INTERESTING_FEATURES_STRINGS = ['docker-compose',
                                'docker-compose-changes',
                                'environment',
                                'git-clone',
                                'shell-commands',
                                'git-directory',
                                'clean-shell-commands']


def is_interesting_feature_string(feature_description: str):
    for f in INTERESTING_FEATURES_STRINGS:
        if feature_description.startswith(f + ":"):
            return True
    return False


def git(*args):
    try:
        subprocess.check_output(['/usr/bin/git'] + list(args), stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        stdout.write(f'\n -- GIT EXCEPTION -- \n\n{e.output}\n')
        __logger__.error("Exception on process, rc=", e.returncode, "output=", e.output)


def exec_scripts(parameters: dict, which_scripts: str):
    scripts = parameters[which_scripts].split(';')
    git_dir = parameters['git-directory'] if 'git-directory' in parameters else '.'
    script_dir = join(CODE_HOME, "scripts")

    current_dir = os.getcwd()
    os.chdir(CODE_HOME)

    for script in scripts:
        script = join(join(CODE_HOME, script_dir), script)
        st = os.stat(script)
        os.chmod(script, st.st_mode | stat.S_IEXEC)
        sn = f"{script.strip()} {git_dir}"
        os.system(sn)

    os.chdir(current_dir)


def exec_commands(parameters: dict, which_commands: str):
    commands = parameters[which_commands].split(';')
    commands_dir = parameters['git-directory'] if 'git-directory' in parameters else '.'

    current_dir = os.getcwd()
    os.chdir(commands_dir)

    for command in commands:
        os.system(command.strip())

    os.chdir(current_dir)


def replace(source, pattern, string):
    fh, target_file_path = mkstemp()
    with open(target_file_path, 'w') as target_file:
        with open(source, 'r') as source_file:
            for line in source_file:
                target_file.write(line.replace(pattern, string))

    remove(source)
    move(target_file_path, source)


def before_all(context):
    __logger__.info("=========== INITIALIZE PROCESS ===========\n")
    stdout.write(f'=========== INITIALIZE PROCESS ===========\n')


def before_feature(context, feature):
    __logger__.info("=========== START FEATURE ===========")
    __logger__.info("Feature name: %s", feature.name)

    stdout.write("=========== START FEATURE ===========\n")
    stdout.write(f'Feature name: {feature.name}\n\n')

    # 1st: We need to take an overview of the current docker network configuration
    # os.system("docker network ls -q")
    context.dockerNetworkList = [x.id for x in docker.network.list()]

    p = [s for s in feature.description if is_interesting_feature_string(s)]

    parameters = {}
    # parameters = dict(s.split(':', 1) for s in parameters)
    context.parameters = parameters
    for k, v in (s.split(':', 1) for s in p):
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
        stdout.write("********** START git-clone **********\n")
        # We need to check if the corresponding temporal folder exists from a previous execution
        # not finished properly, and in that case remove it
        if exists(parameters['git-directory']):
            # Remove folder
            stdout.write(f'\nDeleting temporal folder...\n')
            rmtree(context.parameters['git-directory'])

        git("clone", parameters['git-clone'], parameters['git-directory'])
        stdout.write("********** END git-clone **********\n")

    if 'docker-compose-changes' in parameters:
        stdout.write("********** START docker-compose-changes **********\n")
        stdout.write("DIR: " + os.getcwd() + "\n")
        stdout.write("CODE HOME " + CODE_HOME + "\n")
        stdout.write("git-directory" + context.parameters['git-directory'] + "\n")
        exec_scripts(parameters, 'docker-compose-changes')

        stdout.write("********** END docker-compose-changes **********\n\n")

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
        stdout.write(f'\nStop&Clean services...\n\n')
        exec_commands(context.parameters, 'clean-shell-commands')

    if 'docker-compose' in context.parameters:
        stdout.write(f'\nDeleting docker-compose and config files...\n')
        docker.compose.down()
        files = ['docker-compose.yml', '.env']
        [remove(f) for f in files if exists(f)]

    if 'git-directory' in context.parameters:
        stdout.write(f'\nDeleting temporal folder...\n')
        rmtree(context.parameters['git-directory'])

    # Cleaning docker network
    current_status = [x.id for x in docker.network.list()]
    new_docker_network_id = [x for x in current_status if x not in context.dockerNetworkList]

    if new_docker_network_id != []:
        stdout.write(f'\nDeleting Docker Network...\n')
        docker.network.remove(new_docker_network_id)


def after_all(context):
    __logger__.info("... END  :)")
    stdout.write(f'... END  :)\n')
