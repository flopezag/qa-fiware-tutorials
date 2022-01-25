from behave import given, when, step, then
from config import settings
from os.path import join


@given(u'I set the tutorial 402')
def step_impl_tutorial_203(context):
    context.data_home = join(join(join(settings.CODE_HOME, "features"), "data"), "402.Managing_Roles_and_Permissions")


@when('I set the "{key}" header with the value "{value}"')
def step_impl(context, key, value):
    """
    :type context: behave.runner.Context
    """
    try:
        context.header[key] = value
    except AttributeError:
        # Context object has no attribute 'header'
        context.header = {key: value}


@step("I set the permission url with an application id")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    context.url = f'http://localhost:3005/v1/applications/{settings.applicationId}/permissions'


@step("I set the permission url with the application and permission ids")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    context.url = f'http://localhost:3005/v1/applications/{settings.applicationId}/permissions/{settings.permissionId}'


@step("I set the roles url with an application id")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    context.url = f'http://localhost:3005/v1/applications/{settings.applicationId}/roles'


@step("I set the roles url with an application id and role id")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    context.url = f'http://localhost:3005/v1/applications/{settings.applicationId}/roles/{settings.roleId}'


@step("I set the permission to the role of an application")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    context.url = f'http://localhost:3005/v1/applications/{settings.applicationId}/roles/{settings.roleId}' \
                  f'/permissions/{settings.permissionId}'


@step("I set the permissions url to the role of an application")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    context.url = f'http://localhost:3005/v1/applications/{settings.applicationId}/roles/{settings.roleId}/permissions'


@then(
    'I receive a HTTP "{code}" status code from Keyrock with the "role_permission_assignments" with this'
    ' "roleId" and "permissionId"'
)
def step_impl(context, code):
    """
    :type context: behave.runner.Context
    """
    assert (context.statusCode == code), \
        f'The status code is not the expected value, received {context.statusCode}, expected {code}'

    assert ("role_permission_assignments" in context.response), \
        f'The Response of the Keyrock does not contain the key "role_permission_assignments"'

    assert ("role_id" in context.response['role_permission_assignments']), \
        f'The Response of the Keyrock does not contain the subkey "role_id"'

    assert ("permission_id" in context.response['role_permission_assignments']), \
        f'The Response of the Keyrock does not contain the subkey "permission_id"'

    assert (context.response['role_permission_assignments']['role_id']), \
        f"The role_id received is not the expected value, received: " \
        f"{context.response['role_permission_assignments']['role_id']}, but was expected {settings.roleId}"

    assert (context.response['role_permission_assignments']['permission_id']), \
        f"The permission_id received is not the expected value, received: " \
        f"{context.response['role_permission_assignments']['permission_id']}, but was expected {settings.permissionId}"
