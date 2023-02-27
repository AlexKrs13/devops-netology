# Домашнее задание к занятию "3.5. Файловые системы"

### 1. Узнайте о sparse (разряженных) файлах.
```
Почитал, посмотрел видео
```

### 2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
* Жесткие ссылки:
  * Имеют ту же информацию inode и набор разрешений, что и у исходного файла;
  * Разрешения на ссылку изменяться при изменении разрешений файла;
  * Можно перемещать и переименовывать и даже удалять файл без вреда ссылке.
* Символические ссылки:
  * Права доступа и номер inode отличаются от исходного файла;
  * При изменении прав доступа для исходного файла, права на ссылку останутся неизменными;
  * После удаления, перемещения или переименования файла становятся недействительными;

Т.е жесткая ссылка указывает на то же место, где находиться основной файл, в то же самое место на жестком диске. Мягкая же ссылка, сама по себе является отдельным файлом и у нее совершенно другой inode.

### 3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:
```bash
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.provider :virtualbox do |vb|
    lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
    lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
    vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
    vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
  end
end
```
* Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.  

* Примечание: на macos в Parallels desktop использовать такой конфиг не получится, новый Vagrantfile:
```bash
Vagrant.configure("2") do |config|
  config.vm.box_download_insecure = true
  config.vm.box = "jeffnoxon/ubuntu-20.04-arm64"

  config.vm.provider "parallels" do |vb|
    vb.memory = 2048
    vb.cpus = 2

    vb.customize ["set", :id, "--device-add", "hdd", "--size", 2500, "--iface", "sata"]
    vb.customize ["set", :id, "--device-add", "hdd", "--size", 2500, "--iface", "sata"]
  end
end
```
<img src="https://github.com/aleksey-raevich/devops-netology/blob/master/images/img001.png" width="522" height="208">

### 4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
```
vagrant@vagrant:~$ sudo fdisk /dev/sdb
```  
<img src="https://github.com/aleksey-raevich/devops-netology/blob/master/images/img002.png" width="734" height="554">

### 5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.


### 6. Соберите mdadm RAID1 на паре разделов 2 Гб.

### 7. Соберите mdadm RAID0 на второй паре маленьких разделов.

### 8. Создайте 2 независимых PV на получившихся md-устройствах.

### 9. Создайте общую volume-group на этих двух PV.

### 10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

### 11. Создайте mkfs.ext4 ФС на получившемся LV.

### 12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.

### 13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.

### 14. Прикрепите вывод lsblk.

### 15. Протестируйте целостность файла:
```
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
```
### 16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

### 17. Сделайте --fail на устройство в вашем RAID1 md.

### 18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.

### 19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:
```
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
```
### 20. Погасите тестовый хост, vagrant destroy.