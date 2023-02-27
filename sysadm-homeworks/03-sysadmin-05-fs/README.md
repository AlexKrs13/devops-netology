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
<img src="https://github.com/aleksey-raevich/devops-netology/blob/master/images/img003.png" width="568" height="489">

### 6. Соберите mdadm RAID1 на паре разделов 2 Гб.
<img src="https://github.com/aleksey-raevich/devops-netology/blob/master/images/img004.png" width="688" height="791">

### 7. Соберите mdadm RAID0 на второй паре маленьких разделов.
<img src="https://github.com/aleksey-raevich/devops-netology/blob/master/images/img005.png" width="665" height="756">

### 8. Создайте 2 независимых PV на получившихся md-устройствах.
```bash
vagrant@vagrant:~$ sudo pvcreate /dev/md0
  Physical volume "/dev/md0" successfully created.
vagrant@vagrant:~$ sudo pvcreate /dev/md1
  Physical volume "/dev/md1" successfully created.
```

### 9. Создайте общую volume-group на этих двух PV.
```bash
vagrant@vagrant:~$ sudo vgcreate vgnew /dev/md0 /dev/md1
  Volume group "vgnew" successfully created
vagrant@vagrant:~$ sudo vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  ubuntu-vg   1   1   0 wz--n- <61.45g 30.72g
  vgnew       2   0   0 wz--n-   2.87g  2.87g
```

### 10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
```bash
vagrant@vagrant:~$ sudo lvcreate -L 100m -n lv-r0-v100 vgnew /dev/md1
  Logical volume "lv-r0-v100" created.
vagrant@vagrant:~$ sudo lvs -o +devices
  LV         VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert Devices
  ubuntu-lv  ubuntu-vg -wi-ao----  30.72g                                                     /dev/sda3(0)
  lv-r0-v100 vgnew     -wi-a----- 100.00m                                                     /dev/md1(0)
```

### 11. Создайте mkfs.ext4 ФС на получившемся LV.
```bash
vagrant@vagrant:~$ sudo mkfs.ext4 /dev/mapper/vgnew-lv--r0--v100
mke2fs 1.45.5 (07-Jan-2020)
Discarding device blocks: done
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```

### 12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.
```bash
vagrant@vagrant:~$ mkdir /tmp/new
vagrant@vagrant:~$ sudo mount /dev/mapper/vgnew-lv--r0--v100 /tmp/new/
```
<img src="https://github.com/aleksey-raevich/devops-netology/blob/master/images/img006.png" width="551" height="402">

### 13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.
```bash
vagrant@vagrant:~$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2023-02-27 09:53:54--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 24719353 (24M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz                                              100%[==============================================================================================================================================>]  23.57M  2.05MB/s    in 11s

2023-02-27 09:54:05 (2.12 MB/s) - ‘/tmp/new/test.gz’ saved [24719353/24719353]
```
### 14. Прикрепите вывод lsblk.
<img src="https://github.com/aleksey-raevich/devops-netology/blob/master/images/img007.png" width="548" height="404">

### 15. Протестируйте целостность файла:
```
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
```
### 16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
```bash
vagrant@vagrant:~$ sudo pvmove -n lv-r0-v100 /dev/md1 /dev/md0
  /dev/md1: Moved: 100.00%
```
### 17. Сделайте --fail на устройство в вашем RAID1 md.
```bash
vagrant@vagrant:~$ sudo mdadm --fail /dev/md0 /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0
```

### 18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.
```bash
vagrant@vagrant:~$ sudo pvmove -n lv-r0-v100 /dev/md1 /dev/md0
  /dev/md1: Moved: 100.00%
vagrant@vagrant:~$ sudo mdadm --fail /dev/md0 /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0
vagrant@vagrant:~$ sudo dmesg | grep md0 | tail -n 10
[14546.296526] md/raid1:md0: not clean -- starting background reconstruction
[14546.296528] md/raid1:md0: active with 2 out of 2 mirrors
[14546.296538] md0: detected capacity change from 0 to 2144337920
[14546.296642] md: resync of RAID array md0
[14556.663047] md: md0: resync done.
[17339.814716] md/raid1:md0: Disk failure on sdb1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
```
### 19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:
```
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
```
<img src="https://github.com/aleksey-raevich/devops-netology/blob/master/images/img008.png" width="407" height="51">

### 20. Погасите тестовый хост, vagrant destroy.
ok