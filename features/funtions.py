from deepdiff import DeepDiff
from os.path import join
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry
from requests import Session, exceptions
from datetime import datetime, timezone, timedelta
from re import search
from time import sleep
from sys import stdout

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


def replace_dates_query(query):
    """
    Replace the strings corresponding to the from and to dates in the corresponding SELECT Query
    :param query: The select query with the dates to be changed
    :return:
    """

    """
    ' The query sentence is with the form of the following example:' \
    ' "SELECT MAX(luminosity) AS max FROM mtopeniot.etlamp WHERE entity_id = \'Lamp:001\' ' \
    '        and time_index >= \'2018-06-27T09:00:00\' and time_index < \'2018-06-30T23:59:59\'"
    """
    regex = r".*time_index >= '(.*)' and time_index < '(.*)'"

    match = search(regex, query)
    str_to_find1 = ''
    str_to_find2 = ''

    if match is not None:
        str_to_find1 = match.group(1)
        str_to_find2 = match.group(2)
    else:
        print("The regex pattern does not match.")

    current_date_time = datetime.now(timezone.utc)

    # We need to select one day after and one day before today
    previous_day = (current_date_time - timedelta(days=1)).strftime("%Y-%m-%dT%H:%M:%S")
    next_day = (current_date_time + timedelta(days=1)).strftime("%Y-%m-%dT%H:%M:%S")

    query = query.replace(str_to_find1, previous_day)
    query = query.replace(str_to_find2, next_day)

    return query


def check_cratedb_health_status(url, headers):
    # I need to wait until the Health Status of CrateDB is Green in order to start querying it
    # Sometimes, it is needed some time before Tables and Indexes are ok in CrateDB
    stmt = '{"stmt": "select health from sys.health order by severity desc limit 1;"}'
    response = ''
    while response != 'GREEN':
        try:
            sleep(1)

            response = http.get(url, data=stmt, headers=headers)
            status = response.json()['rows'][0]

            stdout.write(f'\nCrateDB Health Status: {status}\n')

            response = status[0]
        except exceptions.ConnectionError:
            # Could be possible that even CrateDB server is not still alive
            # Therefore we need to wait a little and try it again...
            sleep(2)
            continue
        except IndexError:
            # The transition from RED status to GREEN status crosses through
            # an empty status sometimes in the response of 'rows', then we
            # wait 1 second and try again
            sleep(1)
            continue
