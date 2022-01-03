from behave import given, when, then, step
from config.settings import CODE_HOME
from os.path import join
from os import environ
import subprocess


@given(u'I set the tutorial 401')
def step_impl_tutorial_203(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "401.Administrating_Users_and_Organizations")


@when("I request the information from user table")
def step_impl(context):
    my_env = environ.copy()
    temp = subprocess.Popen(context.command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=my_env)

    if temp.returncode == 0 or temp.returncode is None:  # is 0 or None if success
        (output, stderr) = temp.communicate()

    output = output.decode('utf-8').replace('\t', ' ').split('\n')

    del output[2]
    output[0] = output[0].split(" ")
    output[1] = output[1].split(" ")

    aux = dict()
    for i in range(0, len(output[0])):
        aux[output[0][i]] = output[1][i]

    context.output = aux


@given("I connect to the MySQL docker instance with the following data")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    # docker exec -it <docker instance> mysql -u<user> -p<password> <database>
    #             -e 'select id, username, email, password from user;'

    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        # | DockerInstance | User | Password | Database | Columns | Table |
        dockerInstance = valid_response['DockerInstance']
        user = valid_response['User']
        password = valid_response['Password']
        database = valid_response['Database']
        columns = valid_response['Columns']
        table = valid_response['Table']

        selectStmt = f"'select {columns} from {table};'"

        context.command = f"docker exec {dockerInstance} mysql -u{user} -p{password} {database} -e {selectStmt}"


@then("I obtain the following data from MySQL")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        id = valid_response['id']
        username = valid_response['username']
        email = valid_response['email']

        o_id = context.output['id']
        o_username = context.output['username']
        o_email = context.output['email']

        assert (id == context.output['id']), \
            f"\nThe id value is not the expected, obtained {id}, but expected: {valid_response['id']}"

        assert (username == context.output['username']), \
            f"\nThe id value is not the expected, obtained {username}, but expected: {valid_response['username']}"

        assert (email == context.output['email']), \
            f"\nThe id value is not the expected, obtained {email}, but expected: {valid_response['email']}"

        assert ('password' in context.output.keys()), \
            f'There should be a password data in the obtained values'
