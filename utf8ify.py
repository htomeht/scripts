#!/usr/bin/python

import os

def utf8ify(root,path):
    # path is a file or directory. rename it if necessary
    utf_8_path = path.decode('ISO-8859-1').encode('UTF-8')
    if utf_8_path != path:
        print "renaming '%s' to '%s'" % (path, utf_8_path)
        os.rename(os.path.join(root,path),os.path.join(root,utf_8_path))

for root, dirs, files in os.walk(os.getcwd(),False):
    for dirname in dirs:
        utf8ify(root,dirname)

    for filename in files:
        utf8ify(root,filename)
