#!/usr/bin/python

import os,string

chars={}

def nonascii(string):
    for char in string:
        if ord(char)>127 and char not in chars:
            chars[char]=string

for root, dirs, files in os.walk(os.getcwd()):
    for d in dirs:
        nonascii(d)

    for f in files:
        nonascii(f)

print "These non-ascii characters found on filesystem:"
for char,filename in chars.items():
    print "%c (%X) in %s" % (char, ord(char), filename)
