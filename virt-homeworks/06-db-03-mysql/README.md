## MySQL

### Задача 1

<details><summary>Описание задачи 1</summary>
Используя Docker, поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите бэкап БД и восстановитесь из него.

Перейдите в управляющую консоль mysql внутри контейнера.

Используя команду \h, получите список управляющих команд.

Найдите команду для выдачи статуса БД и приведите в ответе из её вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

Приведите в ответе количество записей с price > 300.

В следующих заданиях мы будем продолжать работу с этим контейнером.
</details>

* Запуск и подключение к контейнеру:
```text
docker run --name mysql \
    -e MYSQL_DATABASE=test_db \
    -e MYSQL_ROOT_PASSWORD=root \
    -v $(PWD)/mysql/backup:/media/mysql/backup \
    -v $(PWD)/mysql/data:/var/lib/mysql \
    -v $(PWD)/mysql/config:/etc/mysql/conf.d \
    -p 3306:3306 \
    -d mysql:8
    
docker exec -it mysql mysql -uroot -p
```

* Найдите команду для выдачи статуса БД и приведите в ответе из её вывода версию сервера БД:
![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/virt-homeworks/06-db-03-mysql/lab_06-db-03-mysql_img1.png)

* Восстановление БД из бэкапа:
```text
export MYSQL_ROOT_PASSWORD=root && docker exec -i mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" test_db' < mysql/backup/test_dump.sql
```

* Результат выполнения запроса:
```text
mysql> use test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select count(*) from orders where price > 300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```


### Задача 2

<details><summary>Описание задачи 2</summary>

</details>


### Задача 3

<details><summary>Описание задачи 3</summary>

</details>


### Задача 4

<details><summary>Описание задачи 4</summary>

</details>