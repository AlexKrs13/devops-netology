# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Задание 1
```
Есть скрипт:
```

```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

* Какое значение будет присвоено переменной c?
```
Будет ошибка
TypeError: unsupported operand type(s) for +: 'int' and 'str'
```

* Как получить для переменной c значение 12?
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = (a + int(b)) * (int(b) ** 2)
```

* Как получить для переменной c значение 3?
```python
c = a + int(b)
```

## Задание 2
```
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer.
Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений.
Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся.
Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?
```

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

* Новый скрипт:
```python
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
```

## Задание 3
```
Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр.
Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.
```

* Новый скрипт:
```python
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
```

## Задание 4
```Наша команда разрабатывает несколько веб-сервисов, доступных по http.
Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис.
Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена.
Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков.
Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>.
Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки.
Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>.
Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.
``` 

* Cкрипт:
```python
#!/usr/bin/env python3

import socket
import time
from datetime import datetime
import traceback

services = {
    "drive.google.com": {"ips": {"192.168.0.1"}, "dt": "2023-02-26 18:59:21"},
    "mail.google.com": {"ips": {"192.168.0.1", "142.251.1.83"}, "dt": "2023-02-26 18:59:22"},
    "google.com": {"ips": {"192.168.0.1"}, "dt": "2023-02-26 18:59:23"}
}

while True:
    for service in services:
        saved_service_ips = services[service]["ips"]
        saved_service_dt = services[service]["dt"]
        print(f"Service: {service}\tSaved ips: {saved_service_ips}  \tSaved check time: {saved_service_dt}")

        try:
            now = datetime.now()
            check_time = now.strftime("%Y-%m-%d %H:%M:%S")

            checked_service = socket.gethostbyname_ex(service)
            checked_service_ips = set(checked_service[2])
            for ip in checked_service_ips:
                if ip in saved_service_ips:
                    print(f"[CHECKED] {service} - {ip}\tCheck time: {check_time}")
                else:
                    print(f"[ERROR] {service} IP {ip} mismatch: {saved_service_ips}\tCheck time: {check_time}")

            # Save current result
            services[service]["ips"] = checked_service_ips
            services[service]["dt"] = check_time
        except Exception:
            traceback.print_exc()

    now = datetime.now()
    dt = now.strftime("%Y-%m-%d %H:%M:%S")

    print(f"\t\t===================={dt}=====================")
    time.sleep(2)
```