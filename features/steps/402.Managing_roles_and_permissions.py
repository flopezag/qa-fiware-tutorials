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
        f'The Response of the Keyrock does not contain the "role_permission_assignments key"'

    assert ("role_id" in context.response['role_permission_assignments']), \
        f'The Response of the Keyrock does not contain the "role_id" subkey'

    assert ("permission_id" in context.response['role_permission_assignments']), \
        f'The Response of the Keyrock does not contain the "permission_id" subkey'

    assert (context.response['role_permission_assignments']['role_id']), \
        f"The role_id received is not the expected value, received: " \
        f"{context.response['role_permission_assignments']['role_id']}, but was expected {settings.roleId}"

    assert (context.response['role_permission_assignments']['permission_id']), \
        f"The permission_id received is not the expected value, received: " \
        f"{context.response['role_permission_assignments']['permission_id']}, but was expected {settings.permissionId}"


@then('I receive a HTTP "{code}" status code from Keyrock with the following data for organizations')
def step_impl(context, code):
    """
    :type context: behave.runner.Context
    """
    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        # | role_organization_assignments | role_id | organization_id | oauth_client_id | role_organization |
        roleId = getattr(settings, valid_response["role_id"])
        organizationId = getattr(settings, valid_response["organization_id"])

        # Check the status code
        assert (context.statusCode == code), \
            f'The status code is not the expected value, received {context.statusCode}, expected {code}'

        # Check the key values of the response
        assert ("role_organization_assignments" in context.response), \
            f'The Response of the Keyrock does not contain the "role_organization_assignments key"'

        assert ("role_id" in context.response['role_organization_assignments'][0]), \
            f'The Response of the Keyrock does not contain the "role_id" subkey'

        assert ("organization_id" in context.response['role_organization_assignments'][0]), \
            f'The Response of the Keyrock does not contain the "organization_id" subkey'

        #TODO: assert (context.response['role_organization_assignments'] not in ["role_id", "organization_id", "oauth_client_id", "role_organization"]), \
        ##    f'The Response of the Keyrock does not contain the "role_organization" subkey'

        # Check the values of the keys
        assert (context.response['role_organization_assignments'][0]['role_id'] == roleId), \
            f"The role_id received is not the expected value, received: " \
            f"{context.response['role_organization_assignments'][0]['role_id']}, but was expected {roleId}"

        assert (context.response['role_organization_assignments'][0]['organization_id'] == organizationId), \
            f"The permission_id received is not the expected value, received: " \
            f"{context.response['role_organization_assignments'][0]['organization_id']}, " \
            f"but was expected {organizationId}"

        if "role_organization" in valid_response:
            role_organization = valid_response['role_organization']

            assert ("role_organization" in context.response['role_organization_assignments'][0]), \
                f'The Response of the Keyrock does not contain the "role_organization" subkey'

            assert (context.response['role_organization_assignments'][0]['role_organization'] == role_organization), \
                f"The permission_id received is not the expected value, received: " \
                f"{context.response['role_organization_assignments'][0]['role_organization']}, " \
                f"but was expected {role_organization}"

            assert ("oauth_client_id" in context.response['role_organization_assignments'][0]), \
                f'The Response of the Keyrock does not contain the "oauth_client_id" subkey'


@step("I set the organization_roles url with the following data")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        # | application-id | organization-id | role_id | organization_role |
        applicationId = getattr(settings, valid_response["application_id"])
        organizationId = getattr(settings, valid_response["organization_id"])
        roleId = getattr(settings, valid_response["role_id"])
        organization_role = valid_response['organization_role']

        context.url = f'http://localhost:3005/v1/applications/{applicationId}/organizations/{organizationId}' \
                      f'/roles/{roleId}/organization_roles/{organization_role}'


@step("I set the roles url with the following data")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        # | application-id | organization-id |
        applicationId = getattr(settings, valid_response["application_id"])
        organizationId = getattr(settings, valid_response["organization_id"])

        context.url = f'http://localhost:3005/v1/applications/{applicationId}/organizations/{organizationId}/roles'


@then('I receive a HTTP "{code}" status code from Keyrock with the following data for an organization')
def step_impl(context, code):
    """
    :type context: behave.runner.Context
    """
    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        # | role_organization_assignments | role_id | organization_id | oauth_client_id | role_organization |
        roleId = getattr(settings, valid_response["role_id"])
        organizationId = getattr(settings, valid_response["organization_id"])

        # Check the status code
        assert (context.statusCode == code), \
            f'The status code is not the expected value, received {context.statusCode}, expected {code}'

        # Check the key values of the response
        assert ("role_organization_assignments" in context.response), \
            f'The Response of the Keyrock does not contain the "role_organization_assignments key"'

        assert ("role_id" in context.response['role_organization_assignments']), \
            f'The Response of the Keyrock does not contain the "role_id" subkey'

        assert ("organization_id" in context.response['role_organization_assignments']), \
            f'The Response of the Keyrock does not contain the "organization_id" subkey'

        assert (context.response['role_organization_assignments'] not in ["role_id", "organization_id"]), \
            f'The Response of the Keyrock does not contain the "role_organization" subkey'

        # Check the values of the keys
        assert (context.response['role_organization_assignments']['role_id'] == roleId), \
            f"The role_id received is not the expected value, received: " \
            f"{context.response['role_organization_assignments']['role_id']}, but was expected {roleId}"

        assert (context.response['role_organization_assignments']['organization_id'] == organizationId), \
            f"The permission_id received is not the expected value, received: " \
            f"{context.response['role_organization_assignments']['organization_id']}, but was expected {organizationId}"

        if "organization_role" in valid_response:
            organization_role = valid_response['organization_role']

            assert (context.response['role_organization_assignments']['organization_role'] == organization_role), \
                f"The permission_id received is not the expected value, received: " \
                f"{context.response['role_organization_assignments']['organization_role']}, " \
                f"but was expected {organization_role}"
