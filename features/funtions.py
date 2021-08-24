from deepdiff import DeepDiff
from os.path import join
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry
from requests import Session

DEFAULT_TIMEOUT = 5  # seconds
DEFAULT_RETRIES = 3


def read_data_from_file(context, file):
    file = join(context.data_home, file)
    with open(file, "r") as f:
        data = f.read()
    return data


def dict_diff_with_exclusions(context, d1, d2, exclude_file):
    ep = read_data_from_file(context, exclude_file).splitlines()
    return DeepDiff(d1, d2, exclude_paths=ep)


class TimeoutHTTPAdapter(HTTPAdapter):
    def __init__(self, *args, **kwargs):
        self.timeout = DEFAULT_TIMEOUT
        if "timeout" in kwargs:
            self.timeout = kwargs["timeout"]
            del kwargs["timeout"]
        super().__init__(*args, **kwargs)

    def send(self, request, **kwargs):
        timeout = kwargs.get("timeout")
        if timeout is None:
            kwargs["timeout"] = self.timeout
        return super().send(request, **kwargs)


retry_strategy = Retry(
    total=DEFAULT_RETRIES,
    status_forcelist=[429, 500, 502, 503, 504],
    backoff_factor=1,
    method_whitelist=["HEAD", "GET", "OPTIONS"]
)

http = Session()
http.mount("https://", TimeoutHTTPAdapter(timeout=10, max_retries=retry_strategy))
http.mount("http://", TimeoutHTTPAdapter(timeout=10, max_retries=retry_strategy))
