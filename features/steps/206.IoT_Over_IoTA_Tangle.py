import subprocess
from subprocess import PIPE
import time
import re

from behave import given, step, when, then
from os.path import join
from config.settings import CODE_HOME
from requests import post, put, patch, exceptions
import json

from queue import Queue, Empty
from threading import Thread

terminals = {}

MAX_WAIT_UNTIL_OUTPUT = 15


class ProcesPiper:
    def __init__(self, cmd, name):
        self.proc = subprocess.Popen(cmd, stdout=PIPE, stderr=PIPE, shell=True)
        self.q_out = Queue()
        self.q_err = Queue()
        self.timeout = 1
        self.dead = False
        self.name = name
        self.t = Thread(target=self.thr_stdout).start()
        self.t = Thread(target=self.thr_stderr).start()
        self.stdout_log = open("/tmp/" + self.name + "_stdout.txt", "w")
        self.stderr_log = open("/tmp/" + self.name + "_stderr.txt", "w")
        self.res_log = open("/tmp/" + self.name + "_res.txt", "w")

    def log_stdout(self, ln):
        self.stdout_log.write(ln)
        self.stdout_log.flush()

    def log_stderr(self, ln):
        self.stderr_log.write(ln)
        self.stderr_log.flush()

    def log_res(self, ln):
        for l in ln:
            self.res_log.write(l)
        self.res_log.flush()

    def thr_stdout(self):
        for bline in iter(self.proc.stdout.readline, b''):
            self.log_stdout(bline.decode())
            line = bline.decode().rstrip()
            self.q_out.put(line)

    def thr_stderr(self):
        for bline in iter(self.proc.stderr.readline, b''):
            self.log_stderr(bline.decode())
            line = bline.decode().rstrip()
            self.q_err.put(line)

    def poll(self):
        self.proc.poll()
        if self.proc.returncode is not None:
            self.dead = True
        return self.proc.returncode  ## If no

    def get_stdout(self):
        return self.q_out.get_nowait()

    def get_stderr(self):
        return self.q_err.get_nowait()

    def get_any(self):
        try:
            return self.q_out.get_nowait()
        except Empty:
            return self.q_out.get_nowait()


@given(u'I set the tutorial 206')
def step_impl_tutorial_207(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "206.IoT_Over_IoTA_Tangle")


@when(u'I open a new shell terminal {name} and exec "{command}"')
def open_a_new_terminal(context, name, command):
    p = ProcesPiper(command, name)
    terminals[name] = p


@then(u'everything is ok')
def everything_is_ok(context):
    pass


@step(u'I Compare next lines in terminal {name} are like in filename {filename}')
def compare_some_lines_in_terminal(context, name, filename):
    fn = join(context.data_home, filename)
    p = terminals[name]

    with open(fn, "r") as f:
        re_lines = f.readlines()

    p.log_res(re_lines)

    context.matches = 0
    context.lines = len(re_lines)
    max_timeout = MAX_WAIT_UNTIL_OUTPUT
    n_timeout = 0

    fclosed = False

    for l in re_lines:
        rexp = re.compile(l.rstrip())
        while not fclosed:
            try:
                if p.poll() is not None:
                    fclosed = True
                    break
                nl = p.get_stderr().rstrip()
                if rexp.match(nl):
                    context.matches = context.matches + 1
                    break
            except Empty:
                time.sleep(1)
                n_timeout = n_timeout + 1
                if n_timeout > max_timeout:
                    break
        if fclosed:
            break

    assert(context.lines == context.matches)


@then(u'All lines must have matched')
def test_all_lines_in_terminal_matched(context):
    assert(context.lines == context.matches)


@when(u'I exec the shell command "{command}"')
def exec_shell_command(context, command):
    p = subprocess.Popen(command, stderr=subprocess.PIPE, shell=True)

    context.output_lines = []
    for line in iter(p.stderr.readline, b''):
        context.output_lines.append(line.decode())


@then(u'I write data to file {filename}')
def write_things_to_a_file(context, filename):
    with open(filename, "w") as f:
        for l in context.output_lines:
            f.write(l+"\n")

def write_to_file(line, compare):
    with open("/tmp/afoo", "a") as f:
        f.writelines(line)
        f.write("-------------------------\n")
        f.writelines(compare)
        f.write("\n************************\n")


@then(u'I compare command output to file {filename}')
def compare_command_output_to_file(context, filename):
    fn = join(context.data_home, filename)
    with open(fn, "r") as f:
        re_lines = f.readlines()

    write_to_file(context.output_lines, re_lines)
    for z in zip(re_lines, context.output_lines):
        exp_ln = z[0].rstrip()
        out_ln = z[1].rstrip()
        rexp = re.compile(exp_ln)
        assert(rexp.match(out_ln))


@when('I wait patieintly')
def wait_patiently(context):
    time.sleep(1)
