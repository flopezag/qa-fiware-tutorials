import subprocess
import time
import re
from sys import stdout

from behave import given, step, when, then
from os.path import join
from config.settings import CODE_HOME

from queue import Empty
from features.pipes import terminals, ProcesPiper, MAX_WAIT_UNTIL_OUTPUT


@given(u'I set the tutorial 206')
def step_impl_tutorial_207(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "206.IoT_Over_IoTA_Tangle")


@when(u'I open a new shell terminal {name} and run "{command}"')
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
    data = list()

    file_closed = False

    for line in re_lines:
        rexp = re.compile(line.rstrip())
        while not file_closed:
            try:
                if p.poll() is not None:
                    file_closed = True
                    break
                nl = p.get_stderr().rstrip()
                data.append(nl)
                if rexp.match(nl):
                    context.matches = context.matches + 1
                    break
            except Empty:
                time.sleep(1)
                n_timeout = n_timeout + 1
                if n_timeout > max_timeout:
                    break
        if file_closed:
            break

    stdout.write(f'Expected lines =\n {re_lines}\n\n')
    stdout.write(f'Received lines in terminal =\n {data}\n\n')

    assert (context.lines == context.matches), \
        f"\nThe number of matches lines is not equal to the number of expected lines:" \
        f" matches lines {context.matches}, expected lines: {context.lines}"


@step(u'I Compare next lines in terminal {name} at least I can find {n_matches} in {output} with a timeout'
      u' {timeout} matching filename {filename}')
def step_impl(context, name,  n_matches, output, timeout, filename):
    n_matches = int(n_matches)
    timeout = int(timeout)
    fn = join(context.data_home, filename)
    p = terminals[name]

    with open(fn, "r") as f:
        re_lines = f.readlines()

    context.matches = 0

    rexps = []
    for line in re_lines:
        rexps.append(re.compile(line.rstrip()))

    file_closed = False
    n_timeout = 0

    while not file_closed:
        try:
            if p.poll() is not None:
                file_closed = True
                break

            ln = p.get_stdout().rstrip()

            for exp in rexps:
                if exp.match(ln):
                    context.matches = context.matches + 1
                    break

            if context.matches >= n_matches:
                break
        except Empty:
            time.sleep(1)
            n_timeout = n_timeout + 1
            if n_timeout > timeout:
                break

    assert (context.matches == n_matches), \
        f"\nThe number of matches lines is not equal to the number of expected lines:" \
        f" matches lines {n_matches}, expected lines: {context.matches}"


@when(u'I flush the terminal {name} queues')
def step_impl(context, name):
    p = terminals[name]
    p.flush()


@then(u'All lines must have matched')
def test_all_lines_in_terminal_matched(context):
    assert (context.lines == context.matches), \
        f"\nNot all the lines have been matched:" \
        f" Number of lines {context.lines}, number of lines matches: {context.matches}"


@when(u'I run the shell command "{command}"')
def exec_shell_command(context, command):
    p = subprocess.Popen(command, stderr=subprocess.PIPE, shell=True)

    context.output_lines = []
    for line in iter(p.stderr.readline, b''):
        context.output_lines.append(line.decode())


@then(u'I write data to file {filename}')
def write_things_to_a_file(context, filename):
    with open(filename, "w") as f:
        for line in context.output_lines:
            f.write(line+"\n")


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


@given(u'I kill process in terminal {name}')
def step_impl(context, name):
    p = terminals[name]
    p.kill()

    terminals.pop(name)
