#!/usr/bin/env python3

import argparse
import re
import sys

parser = argparse.ArgumentParser(description='Get release version from branch ref.')
parser.add_argument("branch", type=str)
args = parser.parse_args()

m = re.search('^[r|R]elease/(\d+.\d+.\d+)$', args.branch)

if m == None:
    print("PR branch needs to be a release branch.")
    sys.exit(1)

print(m.group(1))