#!/usr/bin/env python

from urllib2 import urlopen
from ClientForm import ParseResponse

forms = ParseResponse(urlopen("https://netlogon.student.uu.se"))
form = forms[0]
form["login"] = "gaja0203"
form["password"] = "jUngf+faBr"
response = urlopen(form.click())


 
