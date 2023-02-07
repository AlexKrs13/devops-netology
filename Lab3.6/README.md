### Lab3.6 Компьютерные сети. Лекция 1

```
1. Работа c HTTP через телнет.
Подключитесь утилитой телнет к сайту stackoverflow.com telnet stackoverflow.com 80
Отправьте HTTP запрос:

GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]

В ответе укажите полученный HTTP код, что он означает?
```
Ответ сервера: HTTP/1.1 403 Forbidden   
Означает, что сервер получил запрос, но отказывается его авторизовать (доступ запрещен).

![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/Lab3.6/lab36_1.png)

```
2. Повторите задание 1 в браузере, используя консоль разработчика F12.
укажите в ответе полученный HTTP код
проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
приложите скриншот консоли браузера в ответ
```
Ответ сервера: 200 OK  
![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/Lab3.6/lab36_2.png)
![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/Lab3.6/lab36_3.png)

```
3. Какой IP адрес у вас в интернете?
```
https://whoer.net  
My IP: 176.116.164.129  

```
4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой whois
```
❯ whois 176.116.164.129  

* organisation:   ORG-KL61-RIPE
* org-name:       Kristelecom Ltd.
* country:        RU
* org-type:       OTHER
* address:        1, Kretova str., Minusinsk, Russia, 662600


❯ whois -h whois.radb.net 176.116.164.129 | grep origin  
origin:         AS31257

```
5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8?
Через какие AS? Воспользуйтесь утилитой traceroute
```
❯ traceroute -a 8.8.8.8  
![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/Lab3.6/lab36_5.png)

На сколько я понимаю в выводе только два номера AS: AS31257 и AS15169, AS0 - служебные номера
[AS0] rt-ax58u-68a8 - это мой локальный роутер ASUS
AS31257 - сети интернет-провайдера "Orion Telecom" далее пакет уходит на  
AS15169 - инженерные сети google  

```
6. Повторите задание 5 в утилите mtr. На каком участке наибольшая задержка - delay?
```
❯ sudo mtr -z 8.8.8.8
![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/Lab3.6/lab36_6.png)

```
7. Какие DNS сервера отвечают за доменное имя dns.google?
Какие A записи? Воспользуйтесь утилитой dig
```
Список NS серверов можно посмотреть командой:  
❯ dig dns.google NS
![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/Lab3.6/lab36_4.png)

Не понял вопроса по поводу A записей.  
dns.google - это одна A запись с двумя IP адресами.  
❯ dig dns.google  
;; ANSWER SECTION:  
dns.google.		116	IN	A	8.8.4.4  
dns.google.		116	IN	A	8.8.8.8  

```
8. Проверьте PTR записи для IP адресов из задания 7.
Какое доменное имя привязано к IP? Воспользуйтесь утилитой dig
```
❯ dig -x 216.239.32.114  
;; ANSWER SECTION:  
114.32.239.216.in-addr.arpa. 42911 IN	PTR	ns1.zdns.google. 

❯ dig -x 216.239.34.114  
;; ANSWER SECTION:  
114.34.239.216.in-addr.arpa. 42913 IN	PTR	ns2.zdns.google.  

❯ dig -x 216.239.36.114  
;; ANSWER SECTION:  
114.36.239.216.in-addr.arpa. 43200 IN	PTR	ns3.zdns.google.  

❯ dig -x 216.239.38.114  
;; ANSWER SECTION:  
114.38.239.216.in-addr.arpa. 43200 IN	PTR	ns4.zdns.google.  