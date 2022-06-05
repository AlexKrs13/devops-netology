# ARaevich: devops-netology learning project

# Описание директив в terraform/.gitignore

# Local .terraform directories
# соответсвует любому файлу или подкаталогу, который содержится в скрытом подкаталоге .terraform,
# который в свою очередь может находиться на любой уровне (глубине) вложенности ** 
# т.е. ** значит сопоставление каталогов в любом месте репозитория
**/.terraform/*

# .tfstate files
# не обрабатывать файлы, имя которых заканчивается на .tfstate
# * - подстановочный знак, соответствует любому количеству символов
*.tfstate
# в имени файла содержится .tfstate. в любом месте имени файла,
# т.к. * может соответствовать как любому кол-ву символов, так и ни одному
*.tfstate.*

# Crash log files
# игнорировать log файлов crash.log
crash.log
# файлов, которые содержат любую последовательность символов между точками 
crash.*.log

# Exclude all .tfvars files, which are likely to contain sensitive data, such as
# password, private keys, and other secrets. These should not be part of version 
# control as they are data points which are potentially sensitive and subject 
# to change depending on the environment.
# игнорирование файлов, которые заканчиваются на .tfvars
*.tfvars
# игнорирование файлов, которые заканчиваются на .tfvars.json
*.tfvars.json

# Ignore override files as they are usually used to override resources locally and so
# are not checked in
# игнорирование файлов override.tf и override.tf.json
override.tf
override.tf.json
# игнорирование файлов, которые заканчиваются на _override.tf и _override.tf.json
*_override.tf
*_override.tf.json

# Include override files you do wish to add to version control using negated pattern
# !example_override.tf

# Include tfplan files to ignore the plan output of command: terraform plan -out=tfplan
# example: *tfplan*

# Ignore CLI configuration files
# игнорировать скрытые файлы .terraformrc и файлы terraform.rc
.terraformrc
terraform.rc
# 05.06.2022
