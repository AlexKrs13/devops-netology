### Lab3.1 Terminal

```
1. Установите средство виртуализации Parallels Desktop.
```
Установлено

```
2. Установите средство автоматизации Hashicorp Vagrant.
```
❯ brew install --cask vagrant  
❯ vagrant plugin install vagrant-parallels  

```
3. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал.
```
Установлен iTerm2 + zsh.  

```
4. С помощью базового файла конфигурации запустите Ubuntu 20.04 в VirtualBox посредством Vagrant
```
Содержание Vagrantfile:  
Vagrant.configure("2") do |config|  
  config.vm.box_download_insecure = true  
  config.vm.box = "jeffnoxon/ubuntu-20.04-arm64"  
end  

```
5. Ознакомьтесь с графическим интерфейсом VirtualBox, 
посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, 
какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?
```
***Выделенные ВМ ресурсы:***
* CPU: 2
* RAM: 1024MB
* HDD: 64GB

```
6. Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: документация.
Как добавить оперативной памяти или ресурсов процессора виртуальной машине?
```
***Добавить в Vagrantfile строки:***  
config.vm.provider "parallels" do |vp|  
  vp.memory = 2048  
  vp.cpus = 1  
end

```
7. Команда vagrant ssh из директории, в которой содержится Vagrantfile,
позволит вам оказаться внутри виртуальной машины без каких-либо дополнительных настроек.
Попрактикуйтесь в выполнении обсуждаемых команд в терминале Ubuntu.
```
Выполнено

```
8. Ознакомиться с разделами man bash, почитать о настройках самого bash:
8.1 какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?
```
MacOs:

    590        HISTFILE
    591               The  name of the file in which command history is saved (see HISTORY below).  The default value is ~/.bash_history.  If unset, the command
    592               history is not saved when an interactive shell exits.
    593        HISTFILESIZE
    594               The maximum number of lines contained in the history file.  When this variable is assigned a value, the history file is truncated, if nec-
    595               essary, by removing the oldest entries, to contain no more than that number of lines.  The default value is 500.  The history file is also
    596               truncated to this size after writing it when an interactive shell exits.

    603        HISTSIZE
    604               The number of commands to remember in the command history (see HISTORY below).  The default value is 500.

```
8.2 что делает директива ignoreboth в bash?
```
ignoreboth - сокращение для директив ignorespace and ignoredups  
ignorespace - не сохранять в истории строки, начинающиеся с пробела  
ignoredups - не сохранять строки, соответствующие предыдущей записи в истории

```
9. В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?
```
{} - зарезервированные слова  
используется для подстановки элементов из списка, используется в различных условных циклах,  
условных операторах, или ограничивает тело функции  
MacOS: строка 251  
Ubuntu: строка 343  

```
10. С учётом ответа на предыдущий вопрос, как создать однократным вызовом touch 100000 файлов?
Получится ли аналогичным образом создать 300000? Если нет, то почему?
```
Ubuntu:  
$ touch {000001..100000}.txt  
ok  

$ touch {000001..300000}.txt  
bash: /usr/bin/touch: Argument list too long  

```
11. В man bash поищите по /\[\[. Что делает конструкция [[ -d /tmp ]]
```
Возвращает статус 0 или 1 наличия каталога /tmp  
[[ -d /tmp ]]  - код возврата 0, "истина"  

script.sh:  
```
#!/bin/bash  

if [[ -d /tmp ]]  
then  
    echo "/tmp exists"  
fi  
```
$ bash script.sh  
/tmp exists  

```
12. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; 
командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:
bash is /tmp/new_path_directory/bash
bash is /usr/local/bin/bash
bash is /bin/bash
```
![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/Lab3.1/Screenshot.png)

```
13. Чем отличается планирование команд с помощью batch и at?
```
at - используется для назначения одноразового задания на заданное время  
batch — для назначения одноразовых задач, которые должны выполняться, когда загрузка системы становится меньше 1,5  

```
14. Завершите работу виртуальной машины чтобы не расходовать ресурсы компьютера и/или батарею ноутбука.
```
❯ vagrant suspend
