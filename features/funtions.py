from subprocess import Popen, PIPE
from deepdiff import DeepDiff
from deepdiff.helper import CannotCompare
from os.path import join
from requests.adapters import HTTPAdapter
from urllib3.util import Retry
from requests import Session, exceptions
from datetime import datetime, timezone, timedelta
from re import search
from time import sleep
from sys import stdout
from os import environ
from config import settings

DEFAULT_TIMEOUT = 5  # seconds
DEFAULT_RETRIES = 3


def read_data_from_file(context, file):
    file = join(context.data_home, file)
    with open(file, "r") as f:
        data = f.read()
    return data


def compare_func(x, y, level=None):
    try:
        return x['id'] == y['id']
    except Exception:
        raise CannotCompare() from None


def change_context(data, context):
    # Change the context only if it is the core context. The list of available core context is published in the
    # following link: https://uri.etsi.org/ngsi-ld/v1/
    available_core_context = {
        'https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context.jsonld': context,

        'https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context-v1.3.jsonld': context,

        'https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context-v1.4.jsonld': context,

        'https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context-v1.5.jsonld': context,

        'https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context-v1.6.jsonld': context,

        'https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context-v1.7.jsonld': context,

        'https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context-v1.8.jsonld': context,
    }

    if isinstance(data, list):
        for idx in range(len(data)):
            if '@context' in data[idx]:
                if isinstance(data[idx]['@context'], str):
                    try:
                        data[idx]['@context'] = available_core_context[data[idx]['@context']]
                    except KeyError:
                        pass
                elif isinstance(data[idx]['@context'], list):
                    for idx1 in range(len(data[idx]['@context'])):
                        try:
                            data[idx]['@context'][idx1] = available_core_context[data[idx]['@context'][idx1]]
                        except KeyError:
                            pass
    elif isinstance(data, dict):
        if '@context' in data:
            if isinstance(data['@context'], str):
                try:
                    data['@context'] = available_core_context[data['@context']]
                except KeyError:
                    pass
            elif isinstance(data['@context'], list):
                for idx in range(len(data['@context'])):
                    try:
                        data['@context'][idx] = available_core_context[data['@context'][idx]]
                    except KeyError:
                        pass


def exclude_obj_callback(obj, path):
    return True if "context" in path or isinstance(obj, int) else False

# def dict_diff_with_exclusions(context, d1, d2, exclude_file):
#     ep = read_data_from_file(context, exclude_file).splitlines()
#     return DeepDiff(d1, d2, exclude_paths=ep, iterable_compare_func=compare_func)


def dict_diff_with_exclusions(data_home, d1, d2, exclude_file):
    ep = read_data_from_file(data_home, exclude_file).splitlines()
    diff = DeepDiff(d1, d2, exclude_paths=ep, iterable_compare_func=compare_func)

    if 'type_changes' in diff.keys():
        data = diff['type_changes']

        for d in data.copy():
            if 'context' in d:
                aux = data[d]

                if aux['old_type'] == str and aux['new_type'] == list and len(aux['new_value']) == 1:
                    # We need to check if the item of the list is the same as str
                    # @context can be a str or a list
                    if aux['old_value'] == aux['new_value'][0]:
                        del data[d]

        if len(diff['type_changes']) == 0:
            diff = DeepDiff(d1, d2,
                            exclude_paths=ep,
                            iterable_compare_func=compare_func,
                            exclude_obj_callback=exclude_obj_callback)

    return diff


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
    allowed_methods=["HEAD", "GET", "OPTIONS"]
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


def check_java_version():
    # JRE MUST be 8, version is in the format 1.x.y_z, where x is the version of the JRE
    jre_version = 0

    command = "java -version"

    my_env = environ.copy()
    temp = Popen(command, shell=True, stdout=PIPE, stderr=PIPE, env=my_env)

    if temp.returncode == 0 or temp.returncode is None:  # is 0 or None if success
        (output, stderr) = temp.communicate()

        version = str(stderr).split('\\n')[0].split(" ")[2].replace("\"", "")
        jre_version = int(version.split(".")[0])

    return jre_version

  
def set_xml_data(tag):
    if settings.domainId == '':
        settings.domainId = tag[0].attributes['href'].value
    elif settings.papPoliciesId == '':
        # The 2nd time that I receive resources is to obtain the PAP Policies id
        settings.papPoliciesId = tag[0].attributes['href'].value
    else:
        # The 3rd time that I receive resources is to obtain the different versions of a policy set
        settings.policySetVersion = tag[0].attributes['href'].value
