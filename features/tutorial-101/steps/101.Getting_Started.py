# created by Amani Boughanmi on 20.05.2021

from behave import *
import requests
import json
import shlex
import subprocess
#from json_schema.json_differ import diff_jsons
global actual_response

expected_response = (["""
  {
  "orion": {
    "version": "3.0.0",
    "uptime": "0 d, 0 h, 17 m, 19 s",
    "git_hash": "d6f8f4c6c766a9093527027f0a4b3f906e7f04c4",
    "compile_time": "Mon Apr 12 14:48:44 UTC 2021",
    "compiled_by": "root",
    "compiled_in": "f307ca0746f5",
    "release_date": "Mon Apr 12 14:48:44 UTC 2021",
    "machine": "x86_64",
    "doc": "https://fiware-orion.rtfd.io/en/3.0.0/"
    "libversions": {
     "boost": "1_66",
     "libcurl": "libcurl/7.61.1 OpenSSL/1.1.1g zlib/1.2.11 nghttp2/1.33.0",
     "libmicrohttpd": "0.9.70",
     "openssl": "1.1",
     "rapidjson": "1.1.0",
     "mongoc": "1.17.4",
     "bson": "1.17.4"
    }
  }
 }
"""])

class AttrDict(dict):
    def __init__(self, *args, **kwargs):
        super(AttrDict, self).__init__(*args, **kwargs)
        self.__dict__ = self



@given(u'I set the tutorial')
def step_impl(context):
	assert True

# START GET/version Scenario
@given(u'I Send GET HTTP request')
def step_impl(context):
    global actual_response
    cUrl= r""" curl -X GET http://localhost:1026/version """
    # split the cUrl into an array
    sp_cUrl = shlex.split(cUrl)
    process = subprocess.Popen(sp_cUrl, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
   # acquire the response and the err if exists
    resp, err = process.communicate() 
    # transform json response to python dict
    actual_response = json.loads(str(resp.decode("UTF-8"))) 
    print (actual_response)

@then(u'the json response is valid')
def step_impl(context):
    assert True

# END GET/version Scenario

    #raise NotImplementedError(u'Then the json response is valid')

    

    """if (actual_response['orion']['version'] == expected_response['orion']['version']):
        assert True
    if (actual_response[0][0] == expected_response[0][0]): 
        assert True"""
     
    
    
    

	