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
Создайте пользователя test в БД c паролем test-pass, используя:

плагин авторизации mysql_native_password
срок истечения пароля — 180 дней
количество попыток авторизации — 3
максимальное количество запросов в час — 100
аттрибуты пользователя:
Фамилия "Pretty"
Имя "James".
Предоставьте привелегии пользователю test на операции SELECT базы test_db.

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES, получите данные по пользователю test и приведите в ответе к задаче.
</details>

* Создайте пользователя test в БД c паролем test-pass:

```text
mysql> CREATE USER IF NOT EXISTS 'test'@'localhost'
    ->   IDENTIFIED WITH mysql_native_password BY 'test-pass'
    ->   WITH MAX_CONNECTIONS_PER_HOUR 100
    ->   PASSWORD EXPIRE INTERVAL 180 DAY
    ->   FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2
    ->   ATTRIBUTE '{"first_name":"James", "last_name":"Pretty"}';
Query OK, 0 rows affected (0.03 sec)
```

* Предоставьте привелегии пользователю test на операции SELECT базы test_db:

```text
mysql> grant select on test_db.* to 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.01 sec)
```

* Получите данные по пользователю test и приведите в ответе к задаче:

```text
mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user = 'test';
+------+-----------+------------------------------------------------+
| USER | HOST      | ATTRIBUTE                                      |
+------+-----------+------------------------------------------------+
| test | localhost | {"last_name": "Pretty", "first_name": "James"} |
+------+-----------+------------------------------------------------+
1 row in set (0.01 sec)
```

### Задача 3

<details><summary>Описание задачи 3</summary>
Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;.

Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.

Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:

на MyISAM,
на InnoDB.
</details>

* Текущий ENGINE:

```text
mysql> SELECT table_schema,table_name,engine FROM information_schema.tables WHERE table_schema = DATABASE();
+--------------+------------+--------+
| TABLE_SCHEMA | TABLE_NAME | ENGINE |
+--------------+------------+--------+
| test_db      | orders     | InnoDB |
+--------------+------------+--------+
1 row in set (0.00 sec)
```

* Изменение engine и вывод результатов profiling:

```text
mysql> show profiles;
+----------+------------+--------------------------------------+
| Query_ID | Duration   | Query                                |
+----------+------------+--------------------------------------+
|        4 | 0.06807675 | alter table orders engine = 'MyISAM' |
|        5 | 0.06156775 | alter table orders engine = 'InnoDB' |
|        6 | 0.05821600 | alter table orders engine = 'MyISAM' |
|        7 | 0.07801000 | alter table orders engine = 'InnoDB' |
|        8 | 0.07597750 | alter table orders engine = 'MyISAM' |
|        9 | 0.03893600 | alter table orders engine = 'InnoDB' |
|       10 | 0.08880550 | alter table orders engine = 'MyISAM' |
|       11 | 0.07159525 | alter table orders engine = 'InnoDB' |
|       12 | 0.07037475 | alter table orders engine = 'MyISAM' |
|       13 | 0.06803425 | alter table orders engine = 'InnoDB' |
+----------+------------+--------------------------------------+
10 rows in set, 1 warning (0.00 sec)
```


### Задача 4

<details><summary>Описание задачи 4</summary>
Изучите файл my.cnf в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):

скорость IO важнее сохранности данных;
нужна компрессия таблиц для экономии места на диске;
размер буффера с незакомиченными транзакциями 1 Мб;
буффер кеширования 30% от ОЗУ;
размер файла логов операций 100 Мб.
Приведите в ответе изменённый файл my.cnf.
</details>

```text
[mysqld]
skip-host-cache
skip-name-resolve
datadir             =/var/lib/mysql
socket              =/var/run/mysqld/mysqld.sock
secure-file-priv    =/var/lib/mysql-files
pid-file            =/var/run/mysqld/mysqld.pid
user=mysql

[client]
socket=/var/run/mysqld/mysqld.sock

!includedir /etc/mysql/conf.d/

# New conf lines
innodb_flush_log_at_trx_commit = 2
innodb_file_per_table = ON
innodb_buffer_pool_size = 614M
innodb_log_buffer_size = 1M
innodb_log_file_size = 100M
```

Описание параметров для тюнинга: https://highload.today/index-php-2009-04-23-optimalnaya-nastroyka-mysql-servera/
