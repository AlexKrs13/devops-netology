#!/usr/bin/env python3

import os

# Find root path of the project by relative path
project_path_command = ["cd ~/Documents/Develop/Learning/devops-netology/", "git rev-parse --show-toplevel"]
project_path = os.popen(' && '.join(project_path_command)).read().replace("\n", "")

# Change current location to True root of the project and get all modified files
project_status_command = ["cd {0}".format(project_path), "git status"]
project_status_result = os.popen(' && '.join(project_status_command)).read()

is_change = False
for line in project_status_result.split('\n'):
    if line.find('modified') != -1:
        prepare_result = line.replace('\tmodified:   ', '')
        print(os.path.join(project_path, prepare_result))
