#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import os
from jinja2 import Environment


def fileList(path, fileTypes):
    matches = []
    for root, dirnames, filenames in os.walk(path):
        for filename in filenames:
            if filename.endswith(fileTypes):
                matches.append(os.path.join(root, filename))
    return matches


env = Environment()
for path in sys.argv:
    for template in fileList(path, ('.conf', '.ini', '.jinja2')):
        with open(template) as t:
            print 'Checking:', template
            env.parse(t.read())
