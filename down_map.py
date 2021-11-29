import os
import sys as sy
import getopt

file = open("/home/gabriel/index/", "r")
links = [line for line in file]
domain = "http://www.unispel.com/catalog/images/"

cmd = "wget"

sys = os.system

for img in links:
  sys("%s %s%s" % (cmd, domain, img) )
