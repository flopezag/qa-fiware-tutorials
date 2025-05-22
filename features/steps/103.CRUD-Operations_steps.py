# created by Stefano on 21 July 2021 on top of that of Amani Boughanmi on 20.05.2021

from behave import given, when, then, step
from requests import get, post, put, patch, delete, exceptions
from hamcrest import assert_that, is_
import allure
import json
from os.path import join
from config.settings import CODE_HOME

# create the context for the tutorial
#
@given(u'I set the tutorial 103')
def step_impl(context):
    context.data_home = join(join(join(CODE_HOME, "features"), "data"), "103.CRUD-Operations")


# POST
#
@when(u'I send POST HTTP request to add an attribute to "{url}"')
def set_req_body102(context, url):
    context.url = url
    context.header = {'Content-Type': 'application/json'}

@step(u'With the attribute request described in file "{file}"')
def send_orion_post_entity102(context, file):
    file = join(context.data_home, file)
    with open(file) as f:
        payload = f.read()

    allure.attach("POST", name="Request Method", attachment_type=allure.attachment_type.TEXT)
    allure.attach(context.url, name="Request URL", attachment_type=allure.attachment_type.TEXT)
    if hasattr(context, 'header') and context.header:
        allure.attach(json.dumps(context.header), name="Request Headers", attachment_type=allure.attachment_type.JSON)
    
    if payload:
        try:
            allure.attach(json.dumps(json.loads(payload), indent=4), name="Request Payload", attachment_type=allure.attachment_type.JSON)
        except json.JSONDecodeError:
            allure.attach(payload, name="Request Payload", attachment_type=allure.attachment_type.TEXT)
    else:
        allure.attach("No payload", name="Request Payload", attachment_type=allure.attachment_type.TEXT)

    try:
        response = post(context.url, data=payload, headers=context.header)
    except exceptions.RequestException as e:
        allure.attach(str(e), name="Request Exception", attachment_type=allure.attachment_type.TEXT)
        raise SystemExit(e)

    context.responseHeaders = response.headers
    context.statusCode = str(response.status_code)

    allure.attach(context.statusCode, name="Response Status Code", attachment_type=allure.attachment_type.TEXT)
    allure.attach(json.dumps(dict(response.headers)), name="Response Headers", attachment_type=allure.attachment_type.JSON)
    
    if response.text:
        try:
            response_json = response.json()
            allure.attach(json.dumps(response_json, indent=4), name="Response Body", attachment_type=allure.attachment_type.JSON)
        except json.JSONDecodeError:
            allure.attach(response.text, name="Response Body", attachment_type=allure.attachment_type.TEXT)
    else:
        allure.attach("Empty Response Body", name="Response Body", attachment_type=allure.attachment_type.TEXT)

@then(u'I receive a HTTP response on attribute with the following data')
def receive_post_response102(context):
    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        print(valid_response)
        valid_response['Status-Code']
        assert_that(context.statusCode, is_(valid_response['Status-Code']))

#
# PUT
#
@when(u'I send PUT HTTP request to update an attribute to "{url}"')
def set_req_body_put103(context, url): # Renamed from set_req_body103
    context.url = url
    context.header = {'Content-Type': 'text/plain'}

@step(u'With the update request described in file "{file}"')
def send_orion_put_value103(context, file):
    file = join(context.data_home, file)
    with open(file) as f:
        payload = f.read()

    allure.attach("PUT", name="Request Method", attachment_type=allure.attachment_type.TEXT)
    allure.attach(context.url, name="Request URL", attachment_type=allure.attachment_type.TEXT)
    if hasattr(context, 'header') and context.header:
        allure.attach(json.dumps(context.header), name="Request Headers", attachment_type=allure.attachment_type.JSON)
    
    # Payload for this PUT is text/plain as per context.header in set_req_body_put103
    allure.attach(payload, name="Request Payload", attachment_type=allure.attachment_type.TEXT)

    try:
        response = put(context.url, data=payload, headers=context.header)
    except exceptions.RequestException as e:
        allure.attach(str(e), name="Request Exception", attachment_type=allure.attachment_type.TEXT)
        raise SystemExit(e)

    context.responseHeaders = response.headers
    context.statusCode = str(response.status_code)

    allure.attach(context.statusCode, name="Response Status Code", attachment_type=allure.attachment_type.TEXT)
    allure.attach(json.dumps(dict(response.headers)), name="Response Headers", attachment_type=allure.attachment_type.JSON)

    if response.text:
        try:
            response_json = response.json() 
            allure.attach(json.dumps(response_json, indent=4), name="Response Body", attachment_type=allure.attachment_type.JSON)
        except json.JSONDecodeError:
            allure.attach(response.text, name="Response Body", attachment_type=allure.attachment_type.TEXT)
    else:
        allure.attach("Empty Response Body", name="Response Body", attachment_type=allure.attachment_type.TEXT)

@then(u'I receive a HTTP response on update with the following data')
def receive_put_response103(context):
    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        print(valid_response)
        valid_response['Status-Code']
        assert_that(context.statusCode, is_(valid_response['Status-Code']))

#
# PATCH
#
@when(u'I send PATCH HTTP request to update attributes to "{url}"')
def set_req_body_patch103(context, url): # Renamed from set_req_body103
    context.url = url
    context.header = {'Content-Type': 'application/json'}

@step(u'With the patch update request described in file "{file}"')
def send_orion_patch_value103(context, file):
    file = join(context.data_home, file)
    with open(file) as f:
        payload = f.read()

    allure.attach("PATCH", name="Request Method", attachment_type=allure.attachment_type.TEXT)
    allure.attach(context.url, name="Request URL", attachment_type=allure.attachment_type.TEXT)
    if hasattr(context, 'header') and context.header:
        allure.attach(json.dumps(context.header), name="Request Headers", attachment_type=allure.attachment_type.JSON)
    
    if payload:
        try:
            allure.attach(json.dumps(json.loads(payload), indent=4), name="Request Payload", attachment_type=allure.attachment_type.JSON)
        except json.JSONDecodeError:
            allure.attach(payload, name="Request Payload", attachment_type=allure.attachment_type.TEXT)
    else:
        allure.attach("No payload", name="Request Payload", attachment_type=allure.attachment_type.TEXT)

    try:
        response = patch(context.url, data=payload, headers=context.header)
    except exceptions.RequestException as e:
        allure.attach(str(e), name="Request Exception", attachment_type=allure.attachment_type.TEXT)
        raise SystemExit(e)

    context.responseHeaders = response.headers
    context.statusCode = str(response.status_code)

    allure.attach(context.statusCode, name="Response Status Code", attachment_type=allure.attachment_type.TEXT)
    allure.attach(json.dumps(dict(response.headers)), name="Response Headers", attachment_type=allure.attachment_type.JSON)

    if response.text:
        try:
            response_json = response.json()
            allure.attach(json.dumps(response_json, indent=4), name="Response Body", attachment_type=allure.attachment_type.JSON)
        except json.JSONDecodeError:
            allure.attach(response.text, name="Response Body", attachment_type=allure.attachment_type.TEXT)
    else:
        allure.attach("Empty Response Body", name="Response Body", attachment_type=allure.attachment_type.TEXT)

@then(u'I receive a HTTP response on updates with the following data')
def receive_patch_response103(context):
    for element in context.table.rows:
        valid_response = dict(element.as_dict())
        print(valid_response)
        valid_response['Status-Code']
        assert_that(context.statusCode, is_(valid_response['Status-Code']))


#
# DELETE
#
@when(u'I send DELETE HTTP request no body to "{url}"')
def perform_delete_request103(context, url): # Renamed from set_req_body103
    allure.attach("DELETE", name="Request Method", attachment_type=allure.attachment_type.TEXT)
    allure.attach(url, name="Request URL", attachment_type=allure.attachment_type.TEXT)
    allure.attach("No payload", name="Request Payload", attachment_type=allure.attachment_type.TEXT)
    # Assuming this DELETE does not use context.header, if it did, it would be attached here.
    # e.g., if hasattr(context, 'header') and context.header: allure.attach(json.dumps(context.header), name="Request Headers", attachment_type=allure.attachment_type.JSON)

    try:
        response = delete(url, verify=False)
    except exceptions.RequestException as e:
        allure.attach(str(e), name="Request Exception", attachment_type=allure.attachment_type.TEXT)
        raise SystemExit(e)

    context.responseHeaders = response.headers
    context.statusCode = str(response.status_code)

    allure.attach(context.statusCode, name="Response Status Code", attachment_type=allure.attachment_type.TEXT)
    allure.attach(json.dumps(dict(response.headers)), name="Response Headers", attachment_type=allure.attachment_type.JSON)
    
    if response.text:
        try:
            response_json = response.json()
            allure.attach(json.dumps(response_json, indent=4), name="Response Body", attachment_type=allure.attachment_type.JSON)
        except json.JSONDecodeError:
            allure.attach(response.text, name="Response Body", attachment_type=allure.attachment_type.TEXT)
    else:
        allure.attach("Empty Response Body", name="Response Body", attachment_type=allure.attachment_type.TEXT)

@step(u'I receive a HTTP "{status_code}" response code')
def receive_http_status_code_after_delete(context, status_code): # Renamed from http_code_is_returned
    assert_that(context.statusCode, is_(status_code),
                "Response to CB notification has not got the expected HTTP response code: Message: {}"
                )


# GET
#
@when(u'I send GET HTTP request no body to assert to "{url}"')
def send_orion_get_version(context, url):
    allure.attach("GET", name="Request Method", attachment_type=allure.attachment_type.TEXT)
    allure.attach(url, name="Request URL", attachment_type=allure.attachment_type.TEXT)
    allure.attach("No payload", name="Request Payload", attachment_type=allure.attachment_type.TEXT)
    # Assuming this GET does not use context.header, if it did, it would be attached here.

    try:
        response = get(url, verify=False)
        response.encoding = response.apparent_encoding # Keep original encoding logic
    except exceptions.RequestException as e:
        allure.attach(str(e), name="Request Exception", attachment_type=allure.attachment_type.TEXT)
        raise SystemExit(e)

    context.statusCode = str(response.status_code)
    # context.responseHeaders was not set for GET in original, using response.headers for Allure
    allure.attach(context.statusCode, name="Response Status Code", attachment_type=allure.attachment_type.TEXT)
    allure.attach(json.dumps(dict(response.headers)), name="Response Headers", attachment_type=allure.attachment_type.JSON)
    
    if response.text:
        try:
            response_json = response.json()
            allure.attach(json.dumps(response_json, indent=4), name="Response Body", attachment_type=allure.attachment_type.JSON)
        except json.JSONDecodeError:
            allure.attach(response.text, name="Response Body", attachment_type=allure.attachment_type.TEXT)
    else:
        allure.attach("Empty Response Body", name="Response Body", attachment_type=allure.attachment_type.TEXT)

@step(u'I receive a DELETE HTTP "{status_code}" response code') # Gherkin text kept as original
def receive_get_related_delete_http_status_code(context, status_code): # Renamed from http_code_is_returned
    assert_that(context.statusCode, is_(status_code),
                "Response to CB notification has not got the expected HTTP response code: Message: {}"
                )
