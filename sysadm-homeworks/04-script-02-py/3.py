#!/usr/bin/env python3

import os
import sys
import subprocess
import traceback

# get catalog from argument
try:
    arg_path = sys.argv[1]
except IndexError:
    # get current path
    arg_path = os.path.abspath(os.path.dirname(__file__))

# search git root catalog for path
git_root_path = arg_path
try:
    git_search = subprocess.Popen(["git", "rev-parse", "--show-toplevel"], stdin=None, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                  cwd=arg_path, text=True).communicate()
except FileNotFoundError:
    print("Catalog \"{0}\" doesn't exists, check it correct path or run script locally".format(arg_path))
    exit()
except Exception:
    # Something went wrong
    traceback.print_exc()
    exit()
else:
    if git_search[1].find("fatal:") >=0:
        print("Catalog \"{0}\" doesn't have a git repository (or any of the parent directories)".format(arg_path))
        exit()
    else:
        git_root_path = git_search[0].split("\n")[0]

# Check git repository status
try:
    git_status = subprocess.Popen(["git", "status", "--porcelain"], stdin=None, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                  cwd=git_root_path, text=True).communicate()
except Exception:
    # Something went wrong
    traceback.print_exc()
    exit()
else:
    if git_status[1].find("fatal:") >=0:
        print("Git status error:\n {0}".format(git_status[1]))
        exit()
    else:
        git_repository_files = git_status[0].split("\n")

# Process git files list
git_status_dict = {'M': 'modified', '??': 'untracked', 'R': 'renamed'}
for git_file in git_repository_files:
    if not git_file == "":
        key_marker = list(filter(lambda x: x+' ' in git_file, git_status_dict))
        print(git_status_dict[key_marker[0]] + ': ' + git_root_path + '/' + git_file.split(key_marker[0] + ' ')[1])
