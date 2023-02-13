## Lab3.7 Компьютерные сети. Лекция 2


### 1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

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

### 2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?

### 3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.
* Технология VLAN

### 6. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
1. Всего маска подсети содержит 32 бита. Тогда 32-29=3 бита остается для хостов. 2^3-2(два адреса служебные)=6 - IP адресов для хостов.  
2. Подсети /29 - это 3 бита под хосты, а /24 - это 8 бит, итого: 2^8=256, 2^3=8, 256/8=32 - адреса в диапазоне.
3. Пример:

| Network Address  |     Usable Host Range	     | Broadcast Address |
|:----------------:|:--------------------------:|:----------------:|
|    10.10.10.0    |  10.10.10.1 - 10.10.10.6   |   	10.10.10.7    |
|   10.10.10.8	    | 10.10.10.9 - 10.10.10.14	  |   10.10.10.15   |
|   10.10.10.16	   | 10.10.10.17 - 10.10.10.22	 |   10.10.10.23    |
|   10.10.10.24	   | 10.10.10.25 - 10.10.10.30	 |   10.10.10.31    |
|   10.10.10.32	   | 10.10.10.33 - 10.10.10.38	 |   10.10.10.39    |
|   10.10.10.40	   | 10.10.10.41 - 10.10.10.46	 |   10.10.10.47    |

Расчет в ipcalc:
<img src="https://github.com/aleksey-raevich/devops-netology/blob/master/Lab3.7/lab37_2.png" width="548" height="583">

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
<img src="https://github.com/aleksey-raevich/devops-netology/blob/master/Lab3.7/lab37_1.png" width="446" height="617">
* Команды для очистки кэша таблицы  
C:\Windows\system32>arp -d  

C:\Windows\system32>netsh interface IP delete arpcache
Ok.