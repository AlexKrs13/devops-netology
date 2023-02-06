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

