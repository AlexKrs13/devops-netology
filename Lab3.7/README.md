## Lab3.7 Компьютерные сети. Лекция 2

```
1. Проверьте список доступных сетевых интерфейсов на вашем компьютере.
Какие команды есть для этого в Linux и в Windows?
```

* ifconfig / ipconfig (win) - наверное, самые простые команды, которые сразу вспомнил
* ip - более современная утилита, пришедшая на замену ifconfig. сам именно ее и использую
vagrant@vagrant:~$ ip -c -br link
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
eth0             UP             00:1c:42:3e:f8:84 <BROADCAST,MULTICAST,UP,LOWER_UP>

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
* 
C:\Windows\system32>netsh interface IP delete arpcache
Ok.