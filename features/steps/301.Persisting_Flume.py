import psycopg2
from behave import given, when, then, step
from config.settings import CODE_HOME
from os.path import join
from requests import get, post, patch, exceptions
from logging import getLogger
from hamcrest import assert_that, is_, is_not
from pymongo import MongoClient
from time import sleep

__logger__ = getLogger(__name__)


@given(u'I set the tutorial 301')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "301.Persisting_Flume")


@given(u'the fiware-service header is "{fiware_service}" and the fiware-servicepath header is "{fiware_servicepath}"')
def fiware_service_headers(context, fiware_service, fiware_servicepath):
    context.headers = {"fiware-service": fiware_service, "fiware-servicepath": fiware_servicepath}


@step(u'I send GET HTTP request to "{url}" with fiware-service and fiware-servicepath')
def send_query_with_service(context, url):
    try:
        response = get(url, headers=context.headers, verify=False)
        # override encoding by real educated guess as provided by chardet
        response.encoding = response.apparent_encoding
    except exceptions.RequestException as e:  # This is the correct syntax
        raise SystemExit(e)

    context.response = response.json()
    context.statusCode = str(response.status_code)


@then(u'I receive a HTTP "{status_code}" response code with all the services information')
def response_services_information(context, status_code):
    assert_that(context.statusCode, is_(status_code),
                "Response to CB notification has not got the expected HTTP response code: Message: {}"
                .format(context.response))

    aux = list(map(lambda x: {x['entity_type']: {"resource": x['resource'], 'apikey': x['apikey']}},
                   context.response['services']))

    context.services_info = dict((key, d[key]) for d in aux for key in d)


@then('I receive a HTTP "{status_code}" response')
def step_impl(context, status_code):
    assert_that(context.statusCode, is_(status_code),
                "Response to CB notification has not got the expected HTTP response code: Message: {}"
                .format(context.response))


@step("I send PATCH HTTP request with the following data")
def step_impl(context):
    for element in context.table.rows:
        valid_response = dict(element.as_dict())

        url = join(join(join(valid_response['Url'], 'entities'), valid_response['Entity_ID']), 'attrs')

        payload = '''{"%s": {"type": "command","value": ""}}''' % valid_response['Command']

        context.headers['Content-Type'] = 'application/json'

        try:
            response = patch(url, data=payload, headers=context.headers)
            # override encoding by real educated guess as provided by chardet
            response.encoding = response.apparent_encoding
        except exceptions.RequestException as e:  # This is the correct syntax
            raise SystemExit(e)

        context.statusCode = str(response.status_code)
        context.response = response.reason


@when('I send a subscription to the Url "{url}" and payload "{file}"')
def step_impl(context, url, file):
    file = join(context.data_home, file)
    with open(file) as f:
        payload = f.read()

    context.headers['Content-Type'] = 'application/json'

    try:
        response = post(url, data=payload, headers=context.headers)
        # override encoding by real educated guess as provided by chardet
        response.encoding = response.apparent_encoding
    except exceptions.RequestException as e:  # This is the correct syntax
        raise SystemExit(e)

    context.statusCode = str(response.status_code)
    context.response = response.reason


@given('I connect to the MongoDB with the host "{host}" and the port "{port}"')
def step_impl(context, host, port):
    connection_string = 'mongodb://' + host + ':' + port
    context.client = MongoClient(connection_string)


@when("I request the available MongoDB databases")
def step_impl(context):
    # We need to wait some seconds because the sth_openiot is not generated automatically
    sleep(8)  # Delays for 8 seconds.

    context.obtained_dbs = context.client.list_database_names()


@then("I obtain the following databases")
def step_impl(context):
    for element in context.table.rows:
        valid_response = dict(element.as_dict())

        expected_dbs = valid_response['Databases']
        expected_dbs = expected_dbs.replace(" ", "").split(",")

        result = list(set(context.obtained_dbs) - set(expected_dbs)) + list(set(expected_dbs) - set(context.obtained_dbs))

        assert_that(len(result), is_(0),
                    "There are some databases not presented in the tutorial: {}"
                    .format(result))


@when('I request the available MongoDB collections from the database "{database}"')
def step_impl(context, database):
    context.mydb = context.client[database]


@then('I obtain "{total}" total collections from MongoDB')
def step_impl(context, total):
    # list the collections should be 4 sensors per store (4 stores) mal 2 for the aggregation: 32
    my_collections = context.mydb.list_collection_names()
    number_collections = len(my_collections)

    assert_that(number_collections, is_(int(total)),
                "There total number of collections found is different: {}"
                .format(number_collections))


@when('I request "{elements}" elements from the database "{database}" and the collection "{collection}"')
def step_impl(context, elements, database, collection):
    my_db = context.client[database]
    context.my_collection = my_db[collection]
    context.my_results = list(context.my_collection.find().limit(int(elements)))


@then('I receive a list with "{elements}" elements')
def step_impl(context, elements):
    number_elements = len(context.my_results)

    assert_that(number_elements, is_(int(elements)),
                "There total number of elements found is different: {}"
                .format(number_elements))


@step("with the following keys")
def step_impl(context):
    for element in context.table.rows:
        valid_response = dict(element.as_dict())

        expected_keys = valid_response['Keys']
        expected_keys = expected_keys.replace(" ", "").split(",")

        obtained_keys = list(context.my_results[0].keys())

        aux = list(set(obtained_keys) - set(expected_keys)) + list(set(expected_keys) - set(obtained_keys))

        assert_that(aux, is_([]),
                    "The expected keys and obtained keys are not the same, difference: {}"
                    .format(aux))


@step('with the following filter query and and filter fields, limited to "{elements}" elements')
def step_impl(context, elements):
    for element in context.table.rows:
        valid_response = dict(element.as_dict())

        find_query = eval(valid_response['Query'])
        find_fields = eval(valid_response['Fields'])

        context.my_results = list(context.my_collection.find(find_query, find_fields).limit(int(elements)))


@when('I request information from the database "{database}" and the collection "{collection}"')
def step_impl(context, database, collection):
    my_db = context.client[database]
    context.my_collection = my_db[collection]


@then("I receive a non-empty list with at least one element with the following keys")
def step_impl(context):
    assert_that(len(context.my_results), is_not(0),
                "The expected list should have at least one data")

    for element in context.table.rows:
        valid_response = dict(element.as_dict())

        expected_keys = valid_response['Keys']
        expected_keys = expected_keys.replace(" ", "").split(",")

        obtained_keys = list(context.my_results[0].keys())

        aux = list(set(obtained_keys) - set(expected_keys)) + list(set(expected_keys) - set(obtained_keys))

        assert_that(aux, is_([]),
                    "The expected keys and obtained keys are not the same, difference: {}"
                    .format(aux))


@given('I connect to the PostgreSQL with the following data')
def step_impl(context):
    for element in context.table.rows:
        valid_response = dict(element.as_dict())

        user = valid_response['User']
        password = valid_response['Password']
        host = valid_response['Host']
        port = valid_response['Port']

        if 'Database' in valid_response:
            database = valid_response['Database']
            context.connection = psycopg2.connect(user=user,
                                                  password=password,
                                                  host=host,
                                                  port=port,
                                                  database=database)
        else:
            context.connection = psycopg2.connect(user=user,
                                                  password=password,
                                                  host=host,
                                                  port=port)

        # Create a cursor to perform database operations
        context.cursor = context.connection.cursor()

        # We need to wait some seconds because the openiot is not generated automatically
        sleep(8)  # Delays for 8 seconds.


@when("I request the available PostgreSQL databases")
def step_impl(context):
    query_dbs = "SELECT datname FROM pg_database"
    context.cursor.execute(query_dbs)
    context.my_results = context.cursor.fetchall()
    context.obtained_dbs = [i[0] for i in context.my_results]


@when("I request the available PostgreSQL schemas")
def step_impl(context):
    query_schemas = """select s.nspname as table_schema
    from pg_catalog.pg_namespace s
    join pg_catalog.pg_user u on u.usesysid = s.nspowner
    where nspname not in ('information_schema', 'pg_catalog')
          and nspname not like 'pg_toast%'
          and nspname not like 'pg_temp_%'
    order by table_schema"""
    context.cursor.execute(query_schemas)
    context.my_results = context.cursor.fetchall()
    context.obtained_schemas = [i[0] for i in context.my_results]


@then("I obtain the following schemas from PostgreSQL")
def step_impl(context):
    for element in context.table.rows:
        valid_response = dict(element.as_dict())

        expected_schemas = valid_response['Schemas']
        expected_schemas = expected_schemas.replace(" ", "").split(",")

        obtained_schemas = context.obtained_schemas

        result = list(set(obtained_schemas) - set(expected_schemas)) + list(set(expected_schemas) - set(obtained_schemas))

        assert_that(len(result), is_(0),
                    "There are some schemas not presented in the tutorial: {}"
                    .format(result))

        context.cursor.close()
        context.connection.close()


@then("I obtain the following databases from PostgreSQL")
def step_impl(context):
    for element in context.table.rows:
        valid_response = dict(element.as_dict())

        expected_dbs = valid_response['Databases']
        expected_dbs = expected_dbs.replace(" ", "").split(",")

        result = list(set(context.obtained_dbs) - set(expected_dbs)) + list(set(expected_dbs) - set(context.obtained_dbs))

        assert_that(len(result), is_(0),
                    "There are some databases not presented in the tutorial: {}"
                    .format(result))

        context.cursor.close()
        context.connection.close()


@when('I request the available table_schema and table_name from PostgreSQL when table_schema is "openiot"')
def step_impl(context):
    query_schemas = """select table_schema,table_name
                       from information_schema.tables
                       where table_schema ='openiot'
                       order by table_schema,table_name"""
    context.cursor.execute(query_schemas)
    context.my_results = context.cursor.fetchall()
    context.obtained_schemas = [i[0] for i in context.my_results]


@when('I request "10" elements from the table "openiot.motion_001_motion"')
def step_impl(context):
    query = """select * from openiot.motion_001_motion limit 10"""
    context.cursor.execute(query)
    context.my_results = context.cursor.fetchall()
    context.obtained_schemas = [i[0] for i in context.my_results]


@when('I request recvtime, attrvalue from the table "openiot.motion_001_motion" limited to "10" registers')
def step_impl(context):
    query = """select recvtime, attrvalue from openiot.motion_001_motion where attrname ='count'  limit 10;"""
    context.cursor.execute(query)
    context.my_results = context.cursor.fetchall()
    context.obtained_schemas = [i[0] for i in context.my_results]
