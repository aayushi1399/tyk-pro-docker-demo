from tyk.decorators import *
from gateway import TykGateway as tyk
from time import time

@Hook
def SetAuthToken(request, session, spec):
    tyk.log("PostHook is called", "info")
    request.add_header("testheader", "testvalue")
    return request, session
    