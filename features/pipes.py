import subprocess
from subprocess import PIPE

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

    def flush(self):
        try:
            while self.q_out.get_nowait():
                pass
        except Empty:
            pass

        try:
            while self.q_err.get_nowait():
                pass
        except Empty:
            pass

    def kill(self):
        self.proc.kill()
