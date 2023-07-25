## PostgreSQL

### Задача 1

<details><summary>Описание задачи 1</summary>
Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL, используя psql.

Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.

Найдите и приведите управляющие команды для:

вывода списка БД,
подключения к БД,
вывода списка таблиц,
вывода описания содержимого таблиц,
выхода из psql.
</details>

```text
docker run -d \
	--name postgresql \
    -e POSTGRES_USER=pgadmin \
	-e POSTGRES_PASSWORD=pgadmin \
	-e PGDATA=/var/lib/postgresql/data/pgdata \
    -v $(PWD)/postgres/backup:/media/postgresql/backup \
	-v $(PWD)/postgres/data:/var/lib/postgresql/data \
    -p 5432:5432 \
	postgres:13.3
	
docker exec -it postgresql bash
```
* Вывод списка БД:

```text
\l[+]   [PATTERN]      list databases
```

* Подключения к БД:

```text
\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                        connect to new database (currently "pgadmin")
```

* Вывод списка таблиц:

```text
\dt[S+] [PATTERN]      list tables
```

* Вывода описания содержимого таблиц:

```text
\d[S+]  NAME           describe table, view, sequence, or index
```

* Выход из psql:

```text
\q                     quit psql
```

### Задача 2

<details><summary>Описание задачи 2</summary>
Используя psql, создайте БД test_database.

Изучите бэкап БД.

Восстановите бэкап БД в test_database.

Перейдите в управляющую консоль psql внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.

Приведите в ответе команду, которую вы использовали для вычисления, и полученный результат.
</details>

* Используя psql, создайте БД test_database:

```text
# create database test_database;
CREATE DATABASE
```

* Восстановите бэкап БД в test_database:

```text
psql -h localhost -p 5432 -U pgadmin --dbname test_database -f /media/postgresql/backup/test_dump.sql
```

* Приведите в ответе команду, которую вы использовали для вычисления, и полученный результат:

```text
test_database=# SELECT attname, avg_width FROM pg_stats WHERE tablename = 'orders' order by avg_width desc limit 1;
 attname | avg_width
---------+-----------
 title   |        16
(1 row)
```

### Задача 3

<details><summary>Описание задачи 3</summary>
Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.

Предложите SQL-транзакцию для проведения этой операции.

Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?
</details>

* Предложите SQL-транзакцию для проведения этой операции:

```text
begin;
    -- Создаём таблицы-партиции
    CREATE TABLE public.orders_gt499 (CHECK (price>499)) INHERITS (public.orders);
    CREATE TABLE public.orders_lt499 (CHECK (price<=499)) INHERITS (public.orders);

    -- Создаем индексы на таблицы-партиции
    ALTER TABLE ONLY public.orders_gt499 ADD CONSTRAINT orders_gt499__pkey PRIMARY KEY (id);
    ALTER TABLE ONLY public.orders_lt499 ADD CONSTRAINT orders_lt499__pkey PRIMARY KEY (id);

    -- Правила вставки записей
    create rule orders_insert_over_499 as on insert to public.orders
    where (price>499)
    do instead insert into public.orders_gt499 values(NEW.*);

    create rule orders_insert_499_or_less as on insert to public.orders
    where (price<=499)
    do instead insert into public.orders_lt499 values(NEW.*);

    -- Разносим данные из мастер-таблицы по партициям, очищая мастер-таблицу
    WITH mas AS (
    DELETE FROM ONLY public.orders
        WHERE price BETWEEN 0 AND 499 RETURNING *)
    INSERT INTO orders_lt499
    SELECT * FROM mas;

    WITH mas AS (
    DELETE FROM ONLY public.orders
        WHERE price > 499 RETURNING *)
    INSERT INTO orders_gt499
    SELECT * FROM mas;

commit;
```

* Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?
```text
Да можно:
1) сразу создать таблицы-партиции и правила вставки;
2) или создать триггер, который мог бы автоматически добавлять партиции при разрастании таблицы.
```


### Задача 4

<details><summary>Описание задачи 4</summary>
Используя утилиту pg_dump, создайте бекап БД test_database.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?
</details>

* Используя утилиту pg_dump создайте бекап БД test_database:

```text
pg_dump -h localhost -U pgadmin test_database > /media/postgresql/backup/test_database.sql
```

* Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?

```text
title character varying(80) NOT NULL UNIQUE,
```