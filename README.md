# ARaevich: devops-netology learning project

#============== Lab: Git Tools ==============
#1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea
❯ git show aefea 
commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
Date:   Thu Jun 18 10:29:58 2020 -0400

    Update CHANGELOG.md

❯ git log --pretty=format:"%H - %h - %s" | grep "^aefea"
aefead2207ef7e2aa5dc81a34aedf0cad4c32545 - aefead220 - Update CHANGELOG.md

#2. Какому тегу соответствует коммит 85024d3?
❯ git show 85024d3
commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)

#3. Сколько родителей у коммита b8d720? Напишите их хеши.
#У merge commit два родителя
❯ git show b8d720f8^1
commit 56cd7859e05c36c06b56d013b55a252d0bb7e158
❯ git show b8d720f8^2
commit 9ea88f22fc6269854151c571162c5bcf958bee2b

#4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24
❯ git log --pretty=oneline v0.12.23...v0.12.24
33ff1c03bb960b332be3af2e333462dde88b279e (tag: v0.12.24) v0.12.24
b14b74c4939dcab573326f4e3ee2a62e23e12f89 [Website] vmc provider links
3f235065b9347a758efadc92295b540ee0a5e26e Update CHANGELOG.md
6ae64e247b332925b872447e9ce869657281c2bf registry: Fix panic when server is unreachable
5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 website: Remove links to the getting started guide's old location
06275647e2b53d97d4f0a19a0fec11f6d69820b5 Update CHANGELOG.md
d5f9411f5108260320064349b757f55c09bc4b80 command: Fix bug when using terraform login on Windows
4b6d06cc5dcb78af637bbb19c198faff37a066ed Update CHANGELOG.md
dd01a35078f040ca984cdd349f18d0b67e486c35 Update CHANGELOG.md
225466bc3e5f35baa5d07197bbc079345b77525e Cleanup after v0.12.23 release

#5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).
❯ git log -S "func providerSource" --pretty=format:"%h - %an - %ad - %s"
5af1e6234 - Martin Atkins - Tue Apr 21 16:28:59 2020 -0700 - main: Honor explicit provider_installation CLI config when present

#6. Найдите все коммиты в которых была изменена функция globalPluginDirs
❯ git log -S "func globalPluginDirs" --pretty=format:"%h - %an - %ad - %s"
8364383c3 - Martin Atkins - Thu Apr 13 18:05:58 2017 -0700 - Push plugin discovery down into command package

#7. Кто автор функции synchronizedWriters
❯ git log -S synchronizedWriters
commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Wed May 3 16:25:41 2017 -0700

❯ git show 5ac311e2a91e381e2f52234668b49ba670aa0fe5 | grep "func synchronizedWriters"
+func synchronizedWriters(targets ...io.Writer) []io.Writer {
#============================================

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
