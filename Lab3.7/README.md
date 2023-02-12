## Lab3.7 Компьютерные сети. Лекция 2


###  1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

* ifconfig / ipconfig (win) - наверное, самые простые команды, которые сразу вспомнил
* ip - более современная утилита, пришедшая на замену ifconfig (сам именно ее и использую)
```
vagrant@vagrant:~$ ip -c -br link
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
eth0             UP             00:1c:42:3e:f8:84 <BROADCAST,MULTICAST,UP,LOWER_UP>
```
* Информация по активным сетевым интерфейсам также сохраняется ядром linux в каталоге /sys/class/net
* Командой netstat можно получить информацию по сетевой активности, включая подробную информацию по сетевым интерфейсам
```
vagrant@vagrant:~$ netstat -ie
Kernel Interface table
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.211.55.5  netmask 255.255.255.0  broadcast 10.211.55.255
        inet6 fdb2:2c26:f4e4:0:21c:42ff:fe3e:f884  prefixlen 64  scopeid 0x0<global>
        inet6 fe80::21c:42ff:fe3e:f884  prefixlen 64  scopeid 0x20<link>
        ether 00:1c:42:3e:f8:84  txqueuelen 1000  (Ethernet)
        RX packets 757  bytes 91074 (91.0 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 707  bytes 106598 (106.5 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 84  bytes 6284 (6.2 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 84  bytes 6284 (6.2 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

### 7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

#### Linux
* Проверяем таблицу. Добавляем IP, удаляем из таблицы только один нужный IP.
```
vagrant@vagrant:~$ sudo arp -a -n
? (10.211.55.2) at f6:d4:88:f5:48:64 [ether] on eth0
? (10.211.55.1) at 00:1c:42:00:00:18 [ether] on eth0
vagrant@vagrant:~$ sudo arp -s 10.211.55.4 f6:d4:88:f5:48:00
vagrant@vagrant:~$ sudo arp -a -n
? (10.211.55.4) at f6:d4:88:f5:48:00 [ether] PERM on eth0
? (10.211.55.2) at f6:d4:88:f5:48:64 [ether] on eth0
? (10.211.55.1) at 00:1c:42:00:00:18 [ether] on eth0
vagrant@vagrant:~$ sudo arp -d 10.211.55.4
vagrant@vagrant:~$ sudo arp -a -n
? (10.211.55.2) at f6:d4:88:f5:48:64 [ether] on eth0
? (10.211.55.1) at 00:1c:42:00:00:18 [ether] on eth0
```
* Команда для очистки кэша таблицы
```
vagrant@vagrant:~$ sudo ip -s -s neigh flush all
```

#### Windows (запуск cmd от имени администратора)
* Проверяем таблицу. Добавляем IP, удаляем из таблицы только один нужный IP.
![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/Lab3.7/lab37_1.png)
* Команды для очистки кэша таблицы  
C:\Windows\system32>arp -d  

C:\Windows\system32>netsh interface IP delete arpcache
Ok.